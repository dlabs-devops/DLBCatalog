//
//  DLBAnimatableFloat.m
//  DLB
//
//  Created by Matic Oblak on 12/4/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "DLBAnimatableFloat.h"

@interface DLBAnimatableFloat()
@property (nonatomic) CGFloat floatValue;

@property (nonatomic) CGFloat startValue;
@property (nonatomic) CGFloat endValue;

@end

@implementation DLBAnimatableFloat


- (instancetype)initWithStartValue:(CGFloat)startValue
{
    if((self = [self init]))
    {
        self.startValue = startValue;
        self.endValue = startValue;
        self.floatValue = startValue;
    }
    return self;
}

- (void)animateTo:(CGFloat)target withDuration:(NSTimeInterval)duration
{
    self.startValue = self.floatValue;
    self.endValue = target;
    [self animateWithDuration:duration];
}

- (void)animateTo:(CGFloat)target withDuration:(NSTimeInterval)duration onFrameBlock:(void (^)(BOOL willENd))frameBlock
{
    self.startValue = self.floatValue;
    self.endValue = target;
    [self animateWithDuration:duration onFrameBlock:frameBlock];
}


- (void)onFrame
{
    [super onFrame];
    self.floatValue = self.startValue + (self.endValue-self.startValue)*self.currentInterpolator;
}

@end
