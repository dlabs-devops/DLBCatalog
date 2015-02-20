//
// Created by Urban Puhar on 05/02/15.
// Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBProgressBarView.h"
#import "DLBAnimatableFloat.h"

@interface DLBProgressBarView ()

@property (nonatomic, strong) DLBAnimatableFloat *animatableScale;
@property (nonatomic) CGFloat currentScale;
//@property (nonatomic) CGFloat progressValue;
@property (nonatomic) CGRect currentProgressFrame;
@property (nonatomic) CGFloat currentProgressValue;
@property (nonatomic) BOOL animationRunning;

@end


@implementation DLBProgressBarView

- (CGFloat)animationTime
{
    if (_animationTime == 0.0f)
    {
        _animationTime = 2.5f;
    }

    return _animationTime;
}

- (void)setProgressValue:(CGFloat)progress animate:(BOOL)animate withCompletion:(void(^)(void)) block
{
    self.progressValue = progress;

    if (self.animationRunning)
    {
        [self.animatableScale invalidateAnimation];
        self.currentScale = 1.0f;
        [self setNeedsDisplay];
    }

    // start animation
    if(animate)
    {
        self.animatableScale = [[DLBAnimatableFloat alloc] initWithStartValue:0];
        self.animatableScale.animationStyle = DLBAnimationStyleEaseInOut;
        [self.animatableScale animateTo:1.0f withDuration:self.animationTime onFrameBlock:^(BOOL willEnd)
        {
            self.animationRunning = YES;
            self.currentScale = (float)self.animatableScale.floatValue;
            self.currentProgressValue = self.progressValue * self.currentScale;

            if(willEnd)
            {
                self.animatableScale = nil;
                if (block)
                {
                    block();
                }
            }

            [self setNeedsDisplay];
        }];
    }
    else
    {
        [self.animatableScale invalidateAnimation];
        self.currentScale = 1.0f;
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();

    //draw progress background color
    [self.backgroundProgreesColor setFill];
    CGContextFillRect(context, rect);

    // get current progress rect
    self.currentProgressFrame = [self rectForValue:self.currentProgressValue inFrame:rect];


    if(self.maxValue >= self.currentProgressValue)
    {
        // if progress is smaller than max draw given progress
        [self.progressColor setFill];
        CGContextFillRect(context, self.currentProgressFrame);
    }
    else
    {
        // if progress is bigger than max
        // fill entire rect with max progress color
        [self.maxProgressColor setFill];
        CGContextFillRect(context, rect);

        // fill current progress rect
        [self.overMaxProgressColor setFill];
        CGContextFillRect(context, self.currentProgressFrame);
    }
}

#pragma mark -
#pragma mark - Private

// get rect for current progress values.
- (CGRect)rectForValue:(CGFloat)value inFrame:(CGRect)rect
{
    CGRect returnValue = rect;

    if (value > self.maxValue)
    {
        // if current progress value si bigger than max value
        // current value becomes max value and progress is calculated as max/currentValue
        // and progress is continuing from right to left
        returnValue.size.width = rect.size.width - (self.maxValue / value) * rect.size.width;
        returnValue.origin.x = (self.maxValue / value) * rect.size.width;
    }
    else
    {
        returnValue.size.width = (value / self.maxValue) * rect.size.width;
    }


    return returnValue;
}

@end