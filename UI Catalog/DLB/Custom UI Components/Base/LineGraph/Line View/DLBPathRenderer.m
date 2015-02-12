//
// Created by Urban Puhar on 21/01/15.
// Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBPathRenderer.h"

@interface DLBPathRenderer ()

@property (nonatomic, strong) UIBezierPath *currentPath;

@end

@implementation DLBPathRenderer


- (void)setPathPoints:(NSArray *)pathPoints
{
    _pathPoints = pathPoints;
    self.currentPath = [DLBPathRenderer quadCurvedPathWithPoints:pathPoints];
}

- (void)drawLineInContext:(CGContextRef)context inFrame:(CGRect)frame
{
    if (!self.currentPath)
    {
        return;
    }

    // Set clipping mask to line stroke
    CGContextSaveGState(context);
    CGContextAddPath(context, self.currentPath.CGPath);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextReplacePathWithStrokedPath(context);

    CGContextClip(context);

    // set gradient colors
    //int arrayLength = self.gradientColors.count * 4;
    CGFloat colors[12];
    NSInteger colorIndex = 0;
    for (UIColor *loopColor in self.gradientColors)
    {
        [loopColor getRed:&colors[colorIndex] green:&colors[colorIndex + 1] blue:&colors[colorIndex + 2] alpha:&colors[colorIndex + 3]];
        colorIndex = colorIndex + 4;
    }

    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 3);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    CGPoint startPoint = CGPointMake(frame.size.width/2.0f, 0.0f);
    CGPoint endPoint = CGPointMake(frame.size.width/2.0f, frame.size.height + self.lineWidth/2.0f);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;

    // draw Points
    /*
    [[UIColor greenColor] setFill];
    for (NSUInteger i = 0; i < self.pathPoints.count; i++)
    {
        CGPoint value = [self.pathPoints[i] CGPointValue];

        CGContextAddEllipseInRect(context, CGRectMake(value.x, value.y, 4, 4));
        CGContextFillPath(context);
    }
    */

    CGContextRestoreGState(context);
}


+ (UIBezierPath *)quadCurvedPathWithPoints:(NSArray *)points
{
    UIBezierPath *path = [UIBezierPath bezierPath];

    NSValue *value = points[0];
    CGPoint p1 = [value CGPointValue];
    [path moveToPoint:p1];

    if (points.count == 2)
    {
        value = points[1];
        CGPoint p2 = [value CGPointValue];
        [path addLineToPoint:p2];
        return path;
    }

    for (NSUInteger i = 1; i < points.count; i++)
    {
        value = points[i];
        CGPoint p2 = [value CGPointValue];

        CGPoint midPoint = [self pointBetweenPoint1:p1 point2:p2];
        CGPoint cPointLeft = [DLBPathRenderer controlPointBetweenPoint1:midPoint point2:p1];
        CGPoint cPointRight = [DLBPathRenderer controlPointBetweenPoint1:midPoint point2:p2];

        [path addQuadCurveToPoint:midPoint controlPoint:cPointLeft];
        [path addQuadCurveToPoint:p2 controlPoint:cPointRight];

        p1 = p2;
    }

    return path;
}

+ (CGPoint)pointBetweenPoint1:(CGPoint)p1 point2:(CGPoint)p2
{
    return CGPointMake((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
}

+ (CGPoint)controlPointBetweenPoint1:(CGPoint)p1 point2:(CGPoint)p2
{
    CGPoint controlPoint = [self pointBetweenPoint1:p1 point2:p2];
    CGFloat diffY = fabsf((float)p2.y - (float)controlPoint.y);

    // TODO: take into account x position. Not only y
    if (p1.y < p2.y)
    {
        controlPoint.y += diffY;
    }
    else if (p1.y > p2.y)
    {
        controlPoint.y -= diffY;
    }

    return controlPoint;
}

@end