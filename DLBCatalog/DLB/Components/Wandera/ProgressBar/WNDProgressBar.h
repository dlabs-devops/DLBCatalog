//
// Created by Urban Puhar on 09/02/15.
// Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBProgressBarView.h"

@interface WNDProgressBar : DLBProgressBarView

@property (retain, nonatomic) UIFont *labelsFont;
@property (retain, nonatomic) UIColor *labelsFontColor;

@property (retain, nonatomic) UIFont *progressLabelFont;
@property (retain, nonatomic) UIColor *progressLabelFontColor;

@property (retain, nonatomic) NSString *progressLabel;
@property (retain, nonatomic) NSString *progressLabeloverMax;

- (void)setUsageInMB:(NSNumber *)count withCapInMB:(NSNumber *)cap animate:(BOOL)animate;
- (void)setUsage:(NSNumber *)usage withCap:(NSNumber *)cap witCurrency:(NSString *)symbol animate:(BOOL)animate;

@end