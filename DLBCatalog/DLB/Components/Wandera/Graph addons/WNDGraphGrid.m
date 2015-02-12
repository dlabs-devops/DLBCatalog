//
//  WNDGraphGrid.m
//  DLB
//
//  Created by Matic Oblak on 1/8/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "WNDGraphGrid.h"
#import "DLBInterpolations.h"
#import "DLBAnimatableFloat.h"

@interface WNDGraphGrid()

@property (nonatomic, strong) WNDGraphGridParameters *currentParameters;
@property (nonatomic, strong) WNDGraphGridParameters *previousParameters;
@property (nonatomic, strong) DLBAnimatableFloat *scale;

@end

@implementation WNDGraphGrid

- (UIColor *)backgroundColor
{
    UIColor *color = [super backgroundColor];
    if(color == nil)
    {
        return [UIColor clearColor];
    }
    return color;
}

- (void)invalidateAnimation
{
    [self.scale invalidateAnimation];
    self.scale = nil;
    self.previousParameters = nil;
}

- (void)setParameters:(WNDGraphGridParameters *)parameters animated:(BOOL)animated
{
    if(animated)
    {
        if(self.scale)
        {
            self.previousParameters = [self currentAnimatedParameters];
            [self invalidateAnimation];
        }
        else
        {
            self.previousParameters = self.currentParameters;
        }
        self.currentParameters = parameters;
        self.scale = [[DLBAnimatableFloat alloc] init];
        self.scale.animationStyle = DLBAnimationStyleEaseInOut;
        [self.scale animateTo:1.0f withDuration:.35f onFrameBlock:^(BOOL willENd) {
            [self setNeedsDisplay];
            if(willENd)
            {
                [self invalidateAnimation];
            }
        }];
    }
    else
    {
        [self invalidateAnimation];
        self.currentParameters = parameters;
        [self setNeedsDisplay];
    }
}

- (WNDGraphGridParameters *)currentAnimatedParameters
{
    return [WNDGraphGridParameters interpolatedParametersWithSource:self.previousParameters target:self.currentParameters scale:self.scale.floatValue];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Draw background
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(.0f, .0f, self.frame.size.width, self.frame.size.height));
    // Draw lines
    WNDGraphGridParameters *currentParameters = [self currentAnimatedParameters];
    CGContextSetFillColorWithColor(context, currentParameters.lineColor.CGColor);
    if(currentParameters.lineSegmentSize.width > .0f)
    {
        
        CGFloat startX = currentParameters.lineStartPoint.x;
        while (startX < self.frame.size.width) {
            CGFloat previousX = startX;
            CGContextFillRect(context, CGRectMake(startX-currentParameters.lineWidth*.5f,
                                                  .0f,
                                                  currentParameters.lineWidth,
                                                  self.frame.size.height));
            startX += currentParameters.lineSegmentSize.width;
            if(currentParameters.subgridHorizontalPixelSkipCount > 0)
            {
                CGContextSetFillColorWithColor(context, currentParameters.subGridLineColor.CGColor);
                while (previousX < startX) {
                    CGContextFillRect(context, CGRectMake(previousX-currentParameters.subGridLineWidth*.5f,
                                                          .0f,
                                                          currentParameters.subGridLineWidth,
                                                          self.frame.size.height));
                    previousX += currentParameters.subGridLineWidth*(1+currentParameters.subgridHorizontalPixelSkipCount);
                }
                CGContextSetFillColorWithColor(context, currentParameters.lineColor.CGColor);
            }
        }
    }
    if(currentParameters.lineSegmentSize.height > .0f)
    {
        
        CGFloat startY = currentParameters.lineStartPoint.y;
        while (startY < self.frame.size.height) {
            CGFloat previousY = startY;
            CGContextFillRect(context, CGRectMake(.0f,
                                                  startY-currentParameters.lineWidth*.5f,
                                                  self.frame.size.width,
                                                  currentParameters.lineWidth));
            startY += currentParameters.lineSegmentSize.height;
            if(currentParameters.subgridVerticalPixelSkipCount > 0)
            {
                CGContextSetFillColorWithColor(context, currentParameters.subGridLineColor.CGColor);
                while (previousY < startY) {
                    CGContextFillRect(context, CGRectMake(.0f,
                                                          previousY-currentParameters.subGridLineWidth*.5f,
                                                          self.frame.size.width,
                                                          currentParameters.subGridLineWidth));
                    previousY += currentParameters.subGridLineWidth*(1+currentParameters.subgridVerticalPixelSkipCount);
                }
                CGContextSetFillColorWithColor(context, currentParameters.lineColor.CGColor);
            }
        }
    }
}

@end

@interface WNDGraphGridParameters()
@property (nonatomic, readonly) CGFloat segmentWidth;
@property (nonatomic, readonly) CGFloat segmentHeight;
@end

@implementation WNDGraphGridParameters

- (UIColor *)lineColor
{
    if(_lineColor == nil)
    {
        return [UIColor colorWithWhite:.6f alpha:.4f];
    }
    return _lineColor;
}

- (UIColor *)subGridLineColor
{
    if(_lineColor == nil)
    {
        return [UIColor colorWithWhite:.6f alpha:.2f];
    }
    return _lineColor;
}


- (CGFloat)lineWidth
{
    if(_lineWidth <= .0f)
    {
        return 1.0f;
    }
    return _lineWidth;
}

- (CGFloat)subGridLineWidth
{
    if(_lineWidth <= .0f)
    {
        return 1.0f;
    }
    return _lineWidth;
}

+ (WNDGraphGridParameters *)interpolatedParametersWithSource:(WNDGraphGridParameters *)source target:(WNDGraphGridParameters *)target scale:(CGFloat)scale
{
    if(target == nil)
    {
        return source;
    }
    else if(source == nil)
    {
        return target;
    }
    WNDGraphGridParameters *toReturn = [[WNDGraphGridParameters alloc] init];
    
    toReturn.lineColor = [DLBInterpolations interpolateColor:source.lineColor with:target.lineColor scale:scale];
    toReturn.lineWidth = [DLBInterpolations interpolateFloat:source.lineWidth with:target.lineWidth scale:scale];
    
    toReturn.lineStartPoint = [DLBInterpolations interpolatePoint:source.lineStartPoint with:target.lineStartPoint scale:scale];
    toReturn.lineSegmentSize = [DLBInterpolations interpolateSize:source.lineSegmentSize with:target.lineSegmentSize scale:scale];
    toReturn.subgridHorizontalPixelSkipCount = target.subgridHorizontalPixelSkipCount;
    toReturn.subgridVerticalPixelSkipCount = target.subgridVerticalPixelSkipCount;
    toReturn.subGridLineColor = [DLBInterpolations interpolateColor:source.subGridLineColor with:target.subGridLineColor scale:scale];
    toReturn.subGridLineWidth = [DLBInterpolations interpolateFloat:source.subGridLineWidth with:target.subGridLineWidth scale:scale];
    
    return toReturn;
}

@end