//
//  DLBAnimationsCell.m
//  DLB
//
//  Created by Matic Oblak on 1/14/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBAnimationsCell.h"
#import "DLBAnimatableFloat.h"
#import "DLBInterpolations.h"

@interface DLBAnimationsCell()
@property (weak, nonatomic) IBOutlet UIView *previewView;

@property (nonatomic, strong) UIView *transitioningView;

@end

@implementation DLBAnimationsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self performSelector:@selector(beginTransitions) withObject:nil afterDelay:2.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIView *)transitioningView
{
    if(_transitioningView == nil)
    {
        _transitioningView = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, self.previewView.frame.size.width*.2f, self.previewView.frame.size.height*.5f)];
        _transitioningView.center = CGPointMake(-_transitioningView.frame.size.width*.5f, self.previewView.frame.size.height*.5f);
        _transitioningView.backgroundColor = [UIColor blueColor];
        [self.previewView addSubview:_transitioningView];
    }
    return _transitioningView;
}

- (void)beginTransitions
{
    [self moveToNextPosition];
}

- (void)moveToNextPosition
{
    static BOOL left = NO;
    static DLBAnimationStyle animationStyle = DLBAnimationStyleLinear;
    
    CGPoint newCenter = left?
                        CGPointMake(self.previewView.frame.size.width-self.transitioningView.frame.size.width*.5f-30.0f,
                                         self.previewView.frame.size.height*.5f):
                        CGPointMake(self.transitioningView.frame.size.width*.5f+30.0f,
                                    self.previewView.frame.size.height*.5f);
    
    DLBAnimatableFloat *animator = [[DLBAnimatableFloat alloc] initWithStartValue:.0f];
    animator.animationStyle = animationStyle;
    CGPoint startCenter = self.transitioningView.center;
    [animator animateTo:1.0 withDuration:.5 onFrameBlock:^(BOOL willENd) {
        self.transitioningView.center = [DLBInterpolations interpolatePoint:startCenter with:newCenter scale:animator.floatValue];
    }];
    
    animationStyle++;
    if(animationStyle > DLBAnimationStyleBreakThrough)
    {
        animationStyle = DLBAnimationStyleLinear;
    }
    
    
    left = !left;
    [self performSelector:@selector(moveToNextPosition) withObject:nil afterDelay:1.0f];
}

@end
