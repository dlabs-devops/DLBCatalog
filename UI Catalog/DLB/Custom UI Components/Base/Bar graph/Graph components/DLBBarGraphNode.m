//
//  DLBBarGraphNode.m
//  DLB
//
//  Created by Matic Oblak on 12/18/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "DLBBarGraphNode.h"

@implementation DLBBarGraphNode

- (UIColor *)backgroundColor
{
    if(_backgroundColor == nil)
    {
        return [UIColor clearColor];
    }
    return _backgroundColor;
}

- (UIColor *)foregroundColor
{
    if(_foregroundColor == nil)
    {
        return [UIColor clearColor];
    }
    return _foregroundColor;
}


- (void)drawInContext:(CGContextRef)context
{
    if(self.drawDelegate && [self.drawDelegate respondsToSelector:@selector(DLBBarGraphNode:drawIncontext:withRect:)])
    {
        [self.drawDelegate DLBBarGraphNode:self drawIncontext:context withRect:self.frame];
    }
    else
    {
        [self drawDefaultInContext:context];
    }
}

- (void)drawDefaultInContext:(CGContextRef)context
{
    CGRect rect = self.frame;
    
    // Draw background
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetFillColorWithColor(context, self.foregroundColor.CGColor);
    
    CGContextFillRect(context, CGRectMake(rect.origin.x, rect.size.height*(1.0-self.scale), rect.size.width, rect.size.height*self.scale));
}

@end
