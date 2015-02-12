//
//  DLBLineGraphView.m
//  DLB
//
//  Created by Urban Puhar on 08/01/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBLineGraphView.h"
#import "DLBAnimatableFloat.h"
#import "DLBPathRenderer.h"

@interface DLBLineGraphView()

@property (nonatomic, retain) DLBAnimatableFloat *animatableScale;
@property (nonatomic) CGFloat currentScale;
@property (nonatomic) CGRect graphFrame;

@property (nonatomic, strong) NSMutableArray *targetPoints;
@property (nonatomic, strong) NSMutableArray *currentPoints;
@property (nonatomic, strong) NSMutableArray *horizontalLabels;
@property (nonatomic, strong) NSMutableArray *verticalLabels;
@property (nonatomic, strong) DLBPathRenderer *pathRederer;

@end

@implementation DLBLineGraphView


#pragma -
#pragma - Public

- (void)reloadDataAnimated:(BOOL)animated
{
    self.backgroundColor = [UIColor clearColor];

    // create array of target points
    NSInteger pointsCount = [self.dataSource numberOfValuesInGraphView:self];

    // create graph frame. Frame where line is. Without scala
    CGFloat graphWidth, graphHeight, graphX, graphY;
    if (self.verticalLabelFloating)
    {
        graphX = 0;
        graphWidth = self.frame.size.width;
    }
    else
    {
        graphX = self.verticalScalaWidth;
        graphWidth = self.frame.size.width - self.verticalScalaWidth;
    }

    if (self.horizonatalLabelFloating)
    {
        graphY = 0;
        graphHeight = self.frame.size.height;
    }
    else
    {
        graphY = 0;
        graphHeight = self.frame.size.height - self.horizontalScalaHeight;
    }

    self.graphFrame = CGRectMake(graphX, graphY, graphWidth, graphHeight);


    [self.targetPoints removeAllObjects];
    CGFloat dx = self.graphFrame.size.width / (pointsCount - 1);

    // calculate and transform graph points to match the graphFrame.
    for (NSInteger i = 0; i < pointsCount; i++)
    {
        CGFloat value = [self.dataSource lineGraph:self valueAtIndex:i];
        CGFloat y = value/(CGFloat)fabsf((float)self.maxValue - (float)self.minValue) * self.graphFrame.size.height;
        y = self.graphFrame.size.height - y - self.graphFrame.origin.y;
        CGFloat x = i * dx + self.graphFrame.origin.x;

        CGPoint newPoint = CGPointMake(x, y);

        [self.targetPoints addObject:[NSValue valueWithCGPoint:newPoint]];
    }

    // get labels
    NSInteger horizontalLabelsCount = [self.dataSource numberOfHorizontalSectionsInGraphView:self];
    NSInteger verticalLabelsCount = [self.dataSource numberOfVerticalSectionsInGraphView:self];

    [self.horizontalLabels removeAllObjects];
    for (NSInteger i = 0; i < horizontalLabelsCount; i++)
    {
        NSString *horizontalLabel = [self.dataSource lineGraph:self horizontalLabelAtIndex:i];
        [self.horizontalLabels addObject:horizontalLabel];
    }

    [self.verticalLabels removeAllObjects];
    for (NSInteger i = 0; i < verticalLabelsCount; i++)
    {
        NSString *verticalLabel = [self.dataSource lineGraph:self verticalLabelAtIndex:i];
        [self.verticalLabels insertObject:verticalLabel atIndex:0];
    }


    self.pathRederer.pathPoints = [NSArray arrayWithArray:self.targetPoints];

    // start animation
    if(animated)
    {
        [self.animatableScale invalidateAnimation];

        self.animatableScale = [[DLBAnimatableFloat alloc] initWithStartValue:0];
        self.animatableScale.animationStyle = DLBAnimationStyleEaseInOut;
        [self.animatableScale animateTo:1.0f withDuration:3.0f onFrameBlock:^(BOOL willEnd)
        {
            self.currentScale = self.animatableScale.floatValue;
            [self setNeedsDisplay];

            /*
            self.currentPath = [DLBLineGraphView quadCurvedPathWithPoints:self.targetPoints];
            [self setNeedsDisplay];
            */

            /*
             CGFloat maxPoint = self.frame.size.height;
             for (NSUInteger i = 0; i < self.targetPoints.count; i++)
             {
                CGPoint targetPoint = [self.targetPoints[i] CGPointValue];

                 if (targetPoint.y < maxPoint)
                 {
                     maxPoint = targetPoint.y;
                 }
             }


             //upadte current points
             for (NSUInteger i = 0; i < self.targetPoints.count; i++)
             {
                 NSValue *targetValue = self.targetPoints[i];
                 NSValue *currentValue = self.currentPoints[i];

                 CGPoint targetPoint = [targetValue CGPointValue];
                 CGPoint currentPoint = [currentValue CGPointValue];

                 if (currentPoint.y > targetPoint.y)
                 {
                     currentPoint.y = self.frame.size.height - (self.frame.size.height - maxPoint)*(self.currentScale);

                 }
                 else
                 {
                     currentPoint.y = targetPoint.y;
                 }

                 currentValue = [NSValue valueWithCGPoint:currentPoint];
                 self.currentPoints[i] = currentValue;
             }*/
             if(willEnd)
             {
                 self.animatableScale = nil;
             }
         }];
    }
    else
    {
        [self.animatableScale invalidateAnimation];
        self.currentScale = 1.0f;

    }
}

// redraws chart with. It does not call delegates numberOfSectionsInGraphView
- (void)redrawGraphAnimated:(BOOL)animated
{
    /*
    // clear points
    [self.currentPoints removeAllObjects];

    self.currentPoints = [NSMutableArray arrayWithArray:self.targetPoints];

    NSInteger pointsCount = [self.dataSource numberOfHorizontalSectionsInGraphView:self];
    for (int i = 0; i < pointsCount; ++i)
    {
        CGFloat y = [self.dataSource lineGraph:self valueAtIndex:i];

    }
    */
}

#pragma -
#pragma - Private

- (void)setGradientColors:(NSArray *)gradientColors
{
    _gradientColors = gradientColors;
    self.pathRederer.gradientColors = gradientColors;
}


- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    self.pathRederer.lineWidth = lineWidth;
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.pathRederer.lineColor = lineColor;
}

- (DLBPathRenderer *)pathRederer
{
    if (!_pathRederer)
    {
        _pathRederer = [[DLBPathRenderer alloc] init];
    }
    return _pathRederer;
}


- (NSMutableArray *)targetPoints
{
    if (!_targetPoints)
    {
        _targetPoints = [NSMutableArray array];
    }

    return _targetPoints;
}

- (NSMutableArray *)currentPoints
{
    if (!_currentPoints)
    {
        _currentPoints = [NSMutableArray  array];
    }

    return _currentPoints;
}

- (NSMutableArray *)horizontalLabels
{
    if (!_horizontalLabels)
    {
        _horizontalLabels = [NSMutableArray  array];
    }

    return _horizontalLabels;
}

- (NSMutableArray *)verticalLabels
{
    if (!_verticalLabels)
    {
        _verticalLabels = [NSMutableArray  array];
    }

    return _verticalLabels;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();

    //clip to rect animate graph line from left to right
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    CGContextAddRect(context, CGRectMake(0, 0, rect.size.width * self.currentScale, rect.size.height));
    CGContextClosePath(context);
    CGContextClip(context);

    [self.pathRederer drawLineInContext:context inFrame:self.graphFrame];

    CGContextRestoreGState(context);

    // draw vertical labels
    for (NSUInteger i = 0; i < self.horizontalLabels.count; i++)
    {
        NSString *horizontalLabel = [self.horizontalLabels objectAtIndex:i];
        CGRect horizontalLabelRect = [self frameForHorizonatlLabel:horizontalLabel atIndex:i];
        [horizontalLabel drawInRect:horizontalLabelRect withAttributes:self.horizontalLabelAttributes];
    }

    // draw vertical labels
    for (NSUInteger i = 0; i < self.verticalLabels.count; i++)
    {
        NSString *verticalLabel = [self.verticalLabels objectAtIndex:i];
        CGRect verticalLabelRect = [self frameForVerticalLabel:verticalLabel atIndex:i];
        [verticalLabel drawInRect:verticalLabelRect withAttributes:self.verticalLabelAttributes];
    }

}

- (CGRect)frameForHorizonatlLabel:(NSString *)label atIndex:(NSInteger)index
{
    return [self frameForLabel:label atIndex:index vertical:NO];
}

- (CGRect)frameForVerticalLabel:(NSString *)label atIndex:(NSInteger)index
{
    return [self frameForLabel:label atIndex:index vertical:YES];
}

- (CGRect)frameForLabel:(NSString *)label atIndex:(NSInteger)index vertical:(BOOL)vertical
{
    CGRect returnRect = CGRectZero;

    CGFloat dx = self.graphFrame.size.width/(self.horizontalLabels.count);
    CGFloat dy = self.graphFrame.size.height/(self.verticalLabels.count);

    if (vertical)
    {
        CGSize labelSize = [label sizeWithAttributes:self.verticalLabelAttributes];
        returnRect.origin.y = self.graphFrame.origin.y + dy * index + (dy - labelSize.height)/2.0f;
        returnRect.origin.x = (self.verticalScalaWidth - labelSize.width)/2.0f;
        returnRect.size = labelSize;
    }
    else
    {
        CGSize labelSize = [label sizeWithAttributes:self.horizontalLabelAttributes];
        returnRect.origin.x = self.graphFrame.origin.x + dx * index + (dx - labelSize.width)/2.0f;
        returnRect.origin.y = self.frame.size.height - self.horizontalScalaHeight + labelSize.height;
        returnRect.size = labelSize;
    }

    return returnRect;
}

@end
