//
//  DLBFloatingRange.m
//  DLB
//
//  Created by Matic Oblak on 12/16/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "DLBFloatingRange.h"

@implementation DLBFloatingRange

+ (DLBFloatingRange *)withLocation:(CGFloat)location length:(CGFloat)length
{
    DLBFloatingRange *toRetunr = [[DLBFloatingRange alloc] init];
    toRetunr.location = location;
    toRetunr.length = length;
    return toRetunr;
}

@end
