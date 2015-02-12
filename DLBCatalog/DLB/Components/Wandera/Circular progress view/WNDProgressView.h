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
 *  Line width of circle line behind progress circle
 */
@property (nonatomic) float backgroundCircleStrokeWidth;

/**
 *  Background color of circle line behind progress circle
 */
@property (nonatomic, strong) UIColor *backgroundCircleStrokeColor;

@end
