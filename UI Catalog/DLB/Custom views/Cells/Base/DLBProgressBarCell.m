//
// Created by Urban Puhar on 05/02/15.
// Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBProgressBarCell.h"
#import "WNDProgressBar.h"

@interface DLBProgressBarCell()

@property (weak, nonatomic) IBOutlet WNDProgressBar *progressBarView;

@end

@implementation DLBProgressBarCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.progressBarView.maxValue = 100;
    self.progressBarView.progressColor = [UIColor greenColor];
    self.progressBarView.maxProgressColor = [UIColor blueColor];
    self.progressBarView.overMaxProgressColor = [UIColor redColor];
    self.progressBarView.animationTime = 2.0f;
    self.progressBarView.progressLabel = @"CAP  EXCEEDED BY";

    [self.progressBarView setProgressValue:800 animate:YES withCompletion:nil];
}


@end