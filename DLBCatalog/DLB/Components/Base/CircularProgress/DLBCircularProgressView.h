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
// progress color
@property (nonatomic, strong) UIColor *progressColor;
// progress background image. @progressColor must be clear to enable background image.
@property (nonatomic, strong) UIImage *progressBackgoundImage;
// Line width of circle line behind progress circle
@property (nonatomic) float backgroundCircleStrokeWidth;
// Background color of circle line behind progress circle
@property (nonatomic, strong) UIColor *backgroundCircleStrokeColor;
// indicator line width
@property (nonatomic) CGFloat progressStrokeWidth;
// animation time
@property (nonatomic) CGFloat animationTime;
- (void)setValue:(CGFloat)value animated:(BOOL)animated;

// called last animation frame
- (void)valueAnimationWillEnd;

// called before first animation frame
- (void)valueAnimationWillBegin;

@end
