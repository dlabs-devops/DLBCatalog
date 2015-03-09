//
// Created by Urban Puhar on 05/02/15.
// Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBProgressBarCell.h"
#import "DLBProgressBarView.h"

@interface DLBProgressBarCell()

@property (weak, nonatomic) IBOutlet DLBProgressBarView *progressBarView;

@end

@implementation DLBProgressBarCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.progressBarView.maxValue = 100;

    self.progressBarView.progressColor = [UIColor colorWithRed:0.42f green:0.85f blue:0.43f alpha:1.0f];
    self.progressBarView.maxProgressColor = [UIColor colorWithRed:0.93f green:0.4f blue:0.42f alpha:1];
    self.progressBarView.overMaxProgressColor = [UIColor colorWithRed:0.92f green:0.26f blue:0.28f alpha:1.0f];
    self.progressBarView.progressBackgroundColor = [UIColor colorWithRed:0.14f green:0.14f blue:0.16f alpha:1.0f];
    self.progressBarView.backgroundColor = [UIColor clearColor];
    self.progressBarView.animationTime = 2.0f;

    [self animateProgressBar];
}

- (void) animateProgressBar
{
    [self.progressBarView setProgressValue:arc4random()%200 animate:YES withCompletion:nil];
    [self performSelector:@selector(animateProgressBar) withObject:nil afterDelay:3.5f];
}

@end