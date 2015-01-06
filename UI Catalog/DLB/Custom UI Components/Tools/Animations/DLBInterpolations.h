//
//  DLBInterpolations.h
//  DLB
//
//  Created by Matic Oblak on 1/6/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

@import UIKit;

@interface DLBInterpolations : NSObject
+ (CGFloat)interpolateFloat:(CGFloat)source with:(CGFloat)target scale:(CGFloat)scale;
+ (CGRect)interpolateRect:(CGRect)source with:(CGRect)target scale:(CGFloat)scale;
+ (UIColor *)interpolateColor:(UIColor *)source with:(UIColor *)target scale:(CGFloat)scale;
+ (CGRect)interpolateRect:(CGRect)source with:(CGRect)target scale:(CGFloat)scale excludeZeroRect:(BOOL)exclude;
@end
