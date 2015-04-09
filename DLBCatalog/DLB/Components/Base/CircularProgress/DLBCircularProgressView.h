//
//  DLBCircularProgressView.h
//  DLB
//
//  Created by Matic Oblak on 12/4/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

@import UIKit;

@class DLBCircularProgressView;

//
// Draws a circular progress view
//
@interface DLBCircularProgressView : UIView
// defaults to .0f
@property (nonatomic) CGFloat minimumValue;
// defaults to 1.0f
@property (nonatomic) CGFloat maximumValue;
// defaults to .0f
@property (nonatomic) CGFloat value;
// Line width of circle line behind progress circle
@property (nonatomic) float backgroundCircleStrokeWidth;
// indicator line width
@property (nonatomic) CGFloat progressStrokeWidth;
// animation time
@property (nonatomic) CGFloat animationTime;
// Background color of circle line behind progress circle
@property (nonatomic, strong) UIColor *backgroundCircleStrokeColor;

- (void)setValue:(CGFloat)value animated:(BOOL)animated withCompletion:(void(^)(void))completion;

// caled after cliping
- (void)drawInProgressClipRect:(CGRect)rect withContext:(CGContextRef)context;



@end
