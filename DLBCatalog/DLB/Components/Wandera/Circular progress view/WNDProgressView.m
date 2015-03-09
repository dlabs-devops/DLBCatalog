//
//  WNDProgressView.m
//  DLB
//
//  Created by Matic Oblak on 12/4/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "DLBAnimatableFloat.h"
#import "WNDProgressView.h"

@interface WNDProgressView()

@property (nonatomic) CGFloat alphaScale;

@end

@implementation WNDProgressView

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.progressBackgoundImage = [UIImage imageNamed:@"wandera_indicator_gradient"];
}

- (CGFloat)scale
{
    if(self.maximumValue > self.minimumValue)
    {
        return (self.value-self.minimumValue)/(self.maximumValue-self.minimumValue);
    }
    else
    {
        return .0f;
    }
}

- (void)valueAnimationWillBegin
{
    self.progressColor = [[UIColor colorWithRed:0.93f green:0.25f blue:0.26f alpha:1.0f] colorWithAlphaComponent:0.0f];
}

- (void)valueAnimationWillEnd
{
    NSLog(@"valueAnimationWillEnd: (%f, %f)", self.value, self.maximumValue);
    if (self.value < self.maximumValue)
    {
        self.progressColor = [[UIColor colorWithRed:0.93f green:0.25f blue:0.26f alpha:1.0f] colorWithAlphaComponent:0.0f];
        return;
    }

    // begin animating fade in progress color if scale is over 1.0f
    self.progressColor = [[UIColor colorWithRed:0.93f green:0.25f blue:0.26f alpha:1.0f] colorWithAlphaComponent:0.0f];
    DLBAnimatableFloat *animatableColorScale = [[DLBAnimatableFloat alloc] initWithStartValue:self.alphaScale];
    animatableColorScale.animationStyle = DLBAnimationStyleEaseIn;
    [animatableColorScale animateTo:1.0f withDuration:0.15f onFrameBlock:^(BOOL willEnd) {
        self.alphaScale = animatableColorScale.floatValue;
        self.progressColor = [self.progressColor colorWithAlphaComponent:self.alphaScale];
        [self setNeedsDisplay];
        if(willEnd)
        {

        }
    }];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}


@end
