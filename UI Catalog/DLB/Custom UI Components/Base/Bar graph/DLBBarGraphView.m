//
//  DLBBarGraphView.m
//  DLB
//
//  Created by Matic Oblak on 12/18/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "DLBBarGraphView.h"
#import "DLBBarGraphNode.h"
#import "DLBAnimatableFloat.h"

@interface DLBBarGraphView()

@property (nonatomic, strong) NSArray *targetNodes;
@property (nonatomic, strong) NSArray *sourceNodes;

@property (nonatomic, strong) DLBAnimatableFloat *animationScale;

@property (nonatomic) NSInteger cachedComponentCount;

@end


@implementation DLBBarGraphView

#pragma mark - Properties

- (CGFloat)barWidth
{
    //
    // Will try to compute a value if one does not exist
    //
    if(_barWidth <= .0f)
    {
        NSInteger count = [self.dataSource DLBBarGraphViewNumberOfComponents:self];
        if(!(count > 0))
        {
            count = self.targetNodes.count;
        }
        if(!(count > 0))
        {
            count = self.sourceNodes.count;
        }
        if(!(count > 0))
        {
            count = 30;
        }
        _barWidth = self.frame.size.width/count;
    }
    return _barWidth;
}

- (CGFloat)graphScale
{
    //
    // Will try to compute a value if one does not exist
    //
    if(_graphScale <= .0f)
    {
        return 1.0f;
    }
    return _graphScale;
}

- (UIColor *)backgroundColor
{
    //
    // Will try to compute a value if one does not exist
    //
    UIColor *toReturn = [super backgroundColor];
    if(toReturn == nil)
    {
        return [UIColor clearColor];
    }
    return toReturn;
}

#pragma mark - reload

- (void)reloadGraphAnimated:(BOOL)animated
{
    NSMutableArray *targetNodes = [[NSMutableArray alloc] init];
    NSInteger newCount = self.cachedComponentCount = [self.dataSource DLBBarGraphViewNumberOfComponents:self];
    for(NSInteger i=0; i<newCount; i++)
    {
        DLBBarGraphNode *newNode = [[DLBBarGraphNode alloc] init];
        newNode.index = i;
        newNode.scale = ([self.dataSource DLBBarGraphView:self valueAtIndex:i].floatValue)/self.graphScale;
        newNode.drawDelegate = self.nodeDrawDelegate;
        newNode.foregroundColor = self.nodeColor;
        newNode.backgroundColor = self.nodeBackgroundColor;
        newNode.frame = [self rectForFrameAtIndex:i];
        [targetNodes addObject:newNode];
    }
    
    if(animated)
    {
        [self.animationScale invalidateAnimation];
        self.animationScale = [[DLBAnimatableFloat alloc] initWithStartValue:.0f];
        self.animationScale.animationStyle = DLBAnimationStyleEaseInOut;
        self.sourceNodes = self.targetNodes;
        self.targetNodes = targetNodes;
        [self.animationScale animateTo:1.0f withDuration:.36 onFrameBlock:^(BOOL willEnd) {
            [self setNeedsDisplay];
            if(willEnd)
            {
                self.sourceNodes = nil;
            }
        }];
        
    }
    else
    {
        self.sourceNodes = nil;
        self.targetNodes = targetNodes;
        [self setNeedsDisplay];
    }
}

#pragma mark - draw

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Draw background
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(.0f, .0f, self.frame.size.width, self.frame.size.height));
    
    if(self.sourceNodes == nil)
    {
        for(DLBBarGraphNode *node in self.targetNodes)
        {
            [node drawInContext:context];
        }
    }
    else
    {
        NSInteger sourceCount = self.sourceNodes.count;
        NSInteger targetCount = self.targetNodes.count;
        NSInteger maxCount = sourceCount>targetCount?sourceCount:targetCount;
        
        for(NSInteger i=0; i<maxCount; i++)
        {
            if(i>=sourceCount)
            {
                // new node
                DLBBarGraphNode *targetNode = self.targetNodes[i];
                CGFloat interpolator = self.animationScale.floatValue;
                DLBBarGraphNode *newNode = [[DLBBarGraphNode alloc] init];
                newNode.index = i;
                newNode.scale = [self interpolateFloat:.0f with:targetNode.scale scale:interpolator];
                newNode.frame = targetNode.frame;
                newNode.foregroundColor = [self interpolateColor:[UIColor clearColor] with:targetNode.foregroundColor scale:interpolator];
                newNode.backgroundColor = [self interpolateColor:[UIColor clearColor] with:targetNode.backgroundColor scale:interpolator];
                newNode.drawDelegate = self.nodeDrawDelegate;
                
                [newNode drawInContext:context];
            }
            else if(i>=targetCount)
            {
                // node to be removed
                DLBBarGraphNode *sourceNode = self.sourceNodes[i];
                CGFloat interpolator = self.animationScale.floatValue;
                // generate interpolated node
                DLBBarGraphNode *newNode = [[DLBBarGraphNode alloc] init];
                newNode.index = i;
                newNode.scale = [self interpolateFloat:sourceNode.scale with:.0f scale:interpolator];
                newNode.frame = [self interpolateRect:sourceNode.frame with:[self rectForFrameAtIndex:newNode.index] scale:interpolator];
                newNode.foregroundColor = sourceNode.foregroundColor;
                newNode.backgroundColor = [self interpolateColor:sourceNode.backgroundColor with:[UIColor clearColor] scale:interpolator];
                newNode.drawDelegate = self.nodeDrawDelegate;
                
                [newNode drawInContext:context];
            }
            else
            {
                // refresh node
                DLBBarGraphNode *sourceNode = self.sourceNodes[i];
                DLBBarGraphNode *targetNode = self.targetNodes[i];
                CGFloat interpolator = self.animationScale.floatValue;
                // generate interpolated node
                DLBBarGraphNode *newNode = [[DLBBarGraphNode alloc] init];
                newNode.index = i;
                newNode.scale = [self interpolateFloat:sourceNode.scale with:targetNode.scale scale:interpolator];
                newNode.frame = [self interpolateRect:sourceNode.frame with:targetNode.frame scale:interpolator];
                newNode.foregroundColor = [self interpolateColor:sourceNode.foregroundColor with:targetNode.foregroundColor scale:interpolator];
                newNode.backgroundColor = [self interpolateColor:sourceNode.backgroundColor with:targetNode.backgroundColor scale:interpolator];
                newNode.drawDelegate = self.nodeDrawDelegate;
                
                [newNode drawInContext:context];
            }
        }
    }
}

#pragma mark - convenience

- (CGFloat)interpolateFloat:(CGFloat)source with:(CGFloat)target scale:(CGFloat)scale
{
    return source + (target-source)*scale;
}

- (CGRect)interpolateRect:(CGRect)source with:(CGRect)target scale:(CGFloat)scale
{
    return CGRectMake([self interpolateFloat:source.origin.x with:target.origin.x scale:scale],
                      [self interpolateFloat:source.origin.y with:target.origin.y scale:scale],
                      [self interpolateFloat:source.size.width with:target.size.width scale:scale],
                      [self interpolateFloat:source.size.height with:target.size.height scale:scale]);
}

- (UIColor *)interpolateColor:(UIColor *)source with:(UIColor *)target scale:(CGFloat)scale
{
    CGFloat sColor[4];
    CGFloat tColor[4];
    
    [source getRed:sColor green:sColor+1 blue:sColor+2 alpha:sColor+3];
    [target getRed:tColor green:tColor+1 blue:tColor+2 alpha:tColor+3];
    
    return [UIColor colorWithRed:[self interpolateFloat:sColor[0] with:tColor[0] scale:scale]
                           green:[self interpolateFloat:sColor[1] with:tColor[1] scale:scale]
                            blue:[self interpolateFloat:sColor[2] with:tColor[2] scale:scale]
                           alpha:[self interpolateFloat:sColor[3] with:tColor[3] scale:scale]];
}

#pragma mark nodes frame

- (CGRect)rectForFrameAtIndex:(NSInteger)index
{
    CGFloat separatorSize = (self.frame.size.width - (self.barWidth*self.cachedComponentCount))/self.cachedComponentCount;
    return CGRectMake(separatorSize*.5f + (self.barWidth+separatorSize)*index,
                      .0f,
                      self.barWidth,
                      self.frame.size.height);
}

@end
