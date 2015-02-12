//
// Created by Urban Puhar on 05/02/15.
// Copyright (c) 2015 Matic Oblak. All rights reserved.
//

@import UIKit;

@interface DLBProgressBarView : UIView

// Maximum/"top right" value of bar
@property (nonatomic) CGFloat maxValue;

// Color of progress bar while moving from @minValue to @maxValue
@property (nonatomic, retain) UIColor *progressColor;

// Color of progress bar if @maxValue reached
@property (nonatomic, retain) UIColor *maxProgressColor;

// Color of progress bar if over @maxValue
@property (nonatomic, retain) UIColor *overMaxProgressColor;

@property (nonatomic, retain) UIColor *backgroundProgreesColor;

@property (nonatomic, readonly) CGRect currentProgressFrame;
@property (nonatomic, readonly) CGFloat currentProgressValue;

// Time of progress animation in seconds.
@property (nonatomic) CGFloat animationTime;

// Time of color change aniation time.
@property (nonatomic) CGFloat colorChangeTime;

@property (nonatomic) CGFloat progressValue;

- (void)setProgressValue:(CGFloat)progressValue animate:(BOOL)animate withCompletion:(void(^)(void)) block;

@end