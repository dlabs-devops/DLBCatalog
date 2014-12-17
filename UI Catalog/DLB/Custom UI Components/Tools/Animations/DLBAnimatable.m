//
//  DLBAnimatable.m
//  DLB
//
//  Created by Matic Oblak on 12/4/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "DLBAnimatable.h"

@interface DLBAnimatable()
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) void (^onFrameBlock)(BOOL willEnd);
@end


@implementation DLBAnimatable

- (void)animateWithDuration:(NSTimeInterval)duration onFrameBlock:(void (^)(BOOL willENd))frameBlock
{
    if(frameBlock)
    {
        self.onFrameBlock = frameBlock;
    }
    [self animateWithDuration:duration];
}

- (void)animateWithDuration:(NSTimeInterval)duration
{
    self.startDate = [NSDate date];
    self.endDate = [self.startDate dateByAddingTimeInterval:duration];
    
    [self commitAnimation];
}

- (void)commitAnimation
{
    if(self.displayLink == nil)
    {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onFrame)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop]
                               forMode:NSRunLoopCommonModes];
    }
}

- (void)onFrame
{
    BOOL willEnd = NO;
    if([self currentScale] >= 1.0f)
    {
        willEnd = YES;
    }
    
    if(self.onFrameBlock)
    {
        self.onFrameBlock(willEnd);
    }
    if(willEnd)
    {
        [self performSelector:@selector(invalidateAnimation) withObject:nil];
    }
}

- (void)invalidateAnimation
{
    [self.displayLink invalidate];
    self.displayLink = nil;
    [self performSelector:@selector(setOnFrameBlock:) withObject:nil];
}

- (CGFloat)currentInterpolator
{
    CGFloat toReturn = 1.0f;
    switch (self.animationStyle) {
        case DLBAnimationStyleLinear:
            toReturn = [self currentLinearInterpolator];
            break;
        case DLBAnimationStyleEaseIn:
            toReturn = [self currentEaseInInterpolator];
            break;
        case DLBAnimationStyleEaseOut:
            toReturn = [self currentEaseOutInterpolator];
            break;
        case DLBAnimationStyleEaseInOut:
            toReturn = [self currentEaseInOutInterpolator];
            break;
    }
    return toReturn;
}

- (CGFloat)currentScale
{
    NSDate *thisDate = [NSDate date];
    double scale = [thisDate timeIntervalSinceDate:self.startDate] / [self.endDate timeIntervalSinceDate:self.startDate];
    if(scale < .0f)
    {
        return .0f;
    }
    else if(scale > 1.0f)
    {
        return 1.0f;
    }
    else
    {
        return (CGFloat)scale;
    }
}

- (CGFloat)currentLinearInterpolator
{
    return [self currentScale];
}

- (CGFloat)currentEaseInInterpolator
{
    return (CGFloat)pow([self currentScale], 1.0/.7);
}

- (CGFloat)currentEaseOutInterpolator
{
    return (CGFloat)pow([self currentScale], .7);
}

- (CGFloat)currentEaseInOutInterpolator
{
    double x = (double)[self currentScale];
    double y = sin((x*M_PI)-M_PI_2)*.5f + .5f;
    
    double ratio = 1.0f;
    
    return (CGFloat)(x + (y-x)*ratio);
}

@end
