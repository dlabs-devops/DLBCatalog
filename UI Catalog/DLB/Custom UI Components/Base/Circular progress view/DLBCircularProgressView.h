//
//  DLBCircularProgressView.h
//  DLB
//
//  Created by Matic Oblak on 12/4/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import <UIKit/UIKit.h>

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
// color of inidicator
@property (nonatomic, strong) UIColor *indicatorColor;
// indicator line width
@property (nonatomic) CGFloat indicatorLineWidth;

- (void)setValue:(CGFloat)value animated:(BOOL)animated;

@end
