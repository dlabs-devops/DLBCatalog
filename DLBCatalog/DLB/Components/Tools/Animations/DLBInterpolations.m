//
//  DLBInterpolations.m
//  DLB
//
//  Created by Matic Oblak on 1/6/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBInterpolations.h"

@implementation DLBInterpolations

#pragma mark - interpolations

+ (CGFloat)interpolateFloat:(CGFloat)source with:(CGFloat)target scale:(CGFloat)scale
{
    return source + (target-source)*scale;
}

+ (CGSize)interpolateSize:(CGSize)source with:(CGSize)target scale:(CGFloat)scale
{
    return CGSizeMake([self interpolateFloat:source.width with:target.width scale:scale],
                      [self interpolateFloat:source.height with:target.height scale:scale]);
}

+ (CGPoint)interpolatePoint:(CGPoint)source with:(CGPoint)target scale:(CGFloat)scale
{
    return CGPointMake([self interpolateFloat:source.x with:target.x scale:scale],
                      [self interpolateFloat:source.y with:target.y scale:scale]);
}

+ (CGRect)interpolateRect:(CGRect)source with:(CGRect)target scale:(CGFloat)scale
{
    return [self interpolateRect:source with:target scale:scale excludeZeroRect:NO];
}

+ (CGRect)interpolateRect:(CGRect)source with:(CGRect)target scale:(CGFloat)scale excludeZeroRect:(BOOL)exclude
{
    if(exclude)
    {
        if(CGRectIsEmpty(source))
        {
            return target;
        }
        else if (CGRectIsEmpty(target))
        {
            return source;
        }
        else
        {
            return CGRectMake([self interpolateFloat:source.origin.x with:target.origin.x scale:scale],
                              [self interpolateFloat:source.origin.y with:target.origin.y scale:scale],
                              [self interpolateFloat:source.size.width with:target.size.width scale:scale],
                              [self interpolateFloat:source.size.height with:target.size.height scale:scale]);
        }
    }
    else
    {
        return CGRectMake([self interpolateFloat:source.origin.x with:target.origin.x scale:scale],
                          [self interpolateFloat:source.origin.y with:target.origin.y scale:scale],
                          [self interpolateFloat:source.size.width with:target.size.width scale:scale],
                          [self interpolateFloat:source.size.height with:target.size.height scale:scale]);
    }
}

+ (UIColor *)interpolateColor:(UIColor *)source with:(UIColor *)target scale:(CGFloat)scale
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

@end
