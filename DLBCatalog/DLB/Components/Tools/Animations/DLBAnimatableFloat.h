//
//  DLBAnimatableFloat.h
//  DLB
//
//  Created by Matic Oblak on 12/4/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

@import Foundation;
#import "DLBAnimatable.h"

@interface DLBAnimatableFloat : DLBAnimatable

@property (nonatomic, readonly) CGFloat floatValue;

- (instancetype)initWithStartValue:(CGFloat)startValue;
- (void)animateTo:(CGFloat)target withDuration:(NSTimeInterval)duration;
- (void)animateTo:(CGFloat)target withDuration:(NSTimeInterval)duration onFrameBlock:(void (^)(BOOL willENd))frameBlock;

@end
