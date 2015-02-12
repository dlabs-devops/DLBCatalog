//
// Created by Urban Puhar on 21/01/15.
// Copyright (c) 2015 Matic Oblak. All rights reserved.
//

@import UIKit;

@interface DLBPathRenderer : NSObject

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic, strong) NSArray *pathPoints;
@property (nonatomic, strong) NSArray *gradientColors;

- (void)drawLineInContext:(CGContextRef)context inFrame:(CGRect)frame;

@end