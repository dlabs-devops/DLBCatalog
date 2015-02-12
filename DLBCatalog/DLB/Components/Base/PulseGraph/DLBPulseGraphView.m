//
//  DLBPulseGraphView.m
//  DLB
//
//  Created by Matic Oblak on 12/15/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "DLBPulseGraphView.h"


@interface DLBPulseGraphView()

@end


@implementation DLBPulseGraphView

- (NSArray *)linePoints
{
    if(_linePoints == nil)
    {
        return @[
                 [NSNumber valueWithCGPoint:CGPointMake(.0f, .0f)],
                 [NSNumber valueWithCGPoint:CGPointMake(.25f, .0f)],
                 [NSNumber valueWithCGPoint:CGPointMake(.3f, -.8f)],
                 [NSNumber valueWithCGPoint:CGPointMake(.35f, .3f)],
                 [NSNumber valueWithCGPoint:CGPointMake(.4f, -.2f)],
                 [NSNumber valueWithCGPoint:CGPointMake(.5f, .5f)],
                 [NSNumber valueWithCGPoint:CGPointMake(.65f, -.5f)],
                 [NSNumber valueWithCGPoint:CGPointMake(.75f, .0f)],
                 [NSNumber valueWithCGPoint:CGPointMake(1.0f, .0f)],
                 ];
    }
    return _linePoints;
}

- (NSArray *)pulseRanges
{
    if(_pulseRanges == nil)
    {
        return @[
                 [DLBFloatingRange withLocation:.8f length:.6f]
                 ];
    }
    return _pulseRanges;
}

- (CGFloat)lineWidth
{
    if(_lineWidth <= .0f)
    {
        return 2.0f;
    }
    return _lineWidth;
}

- (UIColor *)lineColor
{
    if(_lineColor == nil)
    {
        return [UIColor redColor];
    }
    return _lineColor;
}

- (UIColor *)lineDimmedColor
{
    if(_lineDimmedColor == nil)
    {
        return [[UIColor redColor] colorWithAlphaComponent:.2f];
    }
    return _lineDimmedColor;
}

- (UIColor *)backgroundColor
{
    if([super backgroundColor] == nil)
    {
        return [UIColor blackColor];
    }
    return [super backgroundColor];
}

- (CGPoint)relativePointAtIndex:(NSInteger)index
{
    CGPoint rawPoint = [self.linePoints[index] CGPointValue];
    
    
    return [self viewPointFromOwnedCoordianteSyste:rawPoint];
}

- (CGPoint)viewPointFromOwnedCoordianteSyste:(CGPoint)rawPoint
{
    return CGPointMake(rawPoint.x*self.frame.size.width, self.frame.size.height*.5f - rawPoint.y*self.frame.size.height*.5f);
}

- (CGPoint)floatingRangeStartPoint:(DLBFloatingRange *)range
{
    return CGPointMake((range.location-range.length)*self.frame.size.width, .0f);
}

- (CGPoint)floatingRangeEndPoint:(DLBFloatingRange *)range
{
    return CGPointMake((range.location)*self.frame.size.width, .0f);
}

- (CGPoint)headerCenterForRange:(DLBFloatingRange *)range
{
    CGPoint leftPoint = CGPointMake(-1000.0f, .0f);
    CGPoint rightPoint = CGPointMake(10000.0f, .0f);
    
    for(NSNumber *number in self.linePoints)
    {
        CGPoint tPoint = [number CGPointValue];
        
        if(tPoint.x <= range.location && tPoint.x > leftPoint.x)
        {
            leftPoint = tPoint;
        }
        if(tPoint.x >= range.location && tPoint.x < rightPoint.x)
        {
            rightPoint = tPoint;
        }
    }
    
    if(rightPoint.x > leftPoint.x)
    {
        CGFloat interpolation = leftPoint.y + (rightPoint.y-leftPoint.y) * ((range.location-leftPoint.x)/(rightPoint.x-leftPoint.x));
        
        return [self viewPointFromOwnedCoordianteSyste:CGPointMake(range.location, interpolation)];
    }
    else
    {
        return [self viewPointFromOwnedCoordianteSyste:CGPointMake(range.location, (leftPoint.y+rightPoint.y)*.5f)];
    }
}

- (UIColor *)pulseHeadColor
{
    if(_pulseHeadColor == nil)
    {
        return [UIColor whiteColor];
    }
    return _pulseHeadColor;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Draw background
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(.0f, .0f, self.frame.size.width, self.frame.size.height));
    
    if(self.linePoints.count < 2)
    {
        // can not draw a line
        return;
    }
    // Generate path from points
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint startPoint = [self relativePointAtIndex:0];
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    for(NSInteger i=1; i<(NSInteger)self.linePoints.count; i++)
    {
        CGPoint point = [self relativePointAtIndex:i];
        CGPathAddLineToPoint(path, NULL, point.x, point.y);
        CGContextMoveToPoint(context, point.x, point.y);
    }
    CGContextSetLineWidth(context, self.lineWidth);
    
    // draw background line with dimmed color
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextSetStrokeColorWithColor(context, self.lineDimmedColor.CGColor);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    // draw paths
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextReplacePathWithStrokedPath(context);
    CGContextClip(context);
    // draw gradients
    
    // generate gradient
    CGFloat colors [] = {
        1.0, .0f, .0f, .0,
        1.0, .0f, .0f, 1.0,
    };
    [self.lineColor getRed:colors green:colors+1 blue:colors+2 alpha:colors+3];
    [self.lineColor getRed:colors+4 green:colors+5 blue:colors+6 alpha:colors+7];
    colors[3] = .0f; // make transparent tail
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    
    for(DLBFloatingRange *value in self.pulseRanges)
    {
        CGContextDrawLinearGradient(context, gradient, [self floatingRangeStartPoint:value], [self floatingRangeEndPoint:value], 0);
    }
    
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(context);
    CGPathRelease(path);

    if(self.pulseHeadRadius > .0f)
    {
        for(DLBFloatingRange *value in self.pulseRanges)
        {
            CGPoint center = [self headerCenterForRange:value];
            CGContextSetFillColorWithColor(context, self.pulseHeadColor.CGColor);
            CGContextFillEllipseInRect(context, CGRectMake(center.x-self.pulseHeadRadius*.5f, center.y-self.pulseHeadRadius*.5f, self.pulseHeadRadius, self.pulseHeadRadius));
        }
    }
}

@end
