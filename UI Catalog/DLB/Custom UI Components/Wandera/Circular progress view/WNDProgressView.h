//
//  WNDProgressView.h
//  DLB
//
//  Created by Matic Oblak on 12/4/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "DLBCircularProgressView.h"

@interface WNDProgressView : DLBCircularProgressView

/**
 *  Line widths of circle line behind progress circle
 */
@property (nonatomic) float backgroundCircleLineWidth;

/**
 *  Background color of circle line behind progress circle
 */
@property (nonatomic, strong) UIColor *backgroundCircleLineColor;
//
// Image used to overlay the indicator
// If nil default will be used as wandera_indicator_gradient
//
@property (nonatomic, strong) UIImage *indicatorOverlayImage;

@end
