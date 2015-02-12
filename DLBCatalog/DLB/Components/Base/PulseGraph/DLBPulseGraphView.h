//
//  DLBPulseGraphView.h
//  DLB
//
//  Created by Matic Oblak on 12/15/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

@import UIKit;
#import "DLBFloatingRange.h"

@interface DLBPulseGraphView : UIView

@property (nonatomic) CGFloat lineWidth;
//
// Full line color
//
@property (strong, nonatomic) UIColor *lineColor;
//
// Minimum line color
//
@property (strong, nonatomic) UIColor *lineDimmedColor;
//
// linePoints are in coordinate system:
// Left: 0
// Right: 1
// Up: 1
// Down: -1
//
@property (nonatomic, strong) NSArray *linePoints;
//
// An array of DLBFloatingRange values representing specific pulse indicators
// The coordinate system is the same as for the line points
//
@property (nonatomic, strong) NSArray *pulseRanges;

@property (nonatomic) CGFloat pulseHeadRadius;
@property (nonatomic, strong) UIColor *pulseHeadColor;

@end

