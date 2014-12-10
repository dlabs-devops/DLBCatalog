//
//  WNDColorWheelMaker.h
//  DLB
//
//  Created by Urban on 10/12/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface WNDAngleGradientImageMaker : NSObject


/* The array of CGColorRef objects defining the color of each gradient
 * stop. Defaults to nil. */

@property(copy) NSArray *colors;

/* An optional array of NSNumber objects defining the location of each
 * gradient stop as a value in the range [0,1]. The values must be
 * monotonically increasing. If a nil array is given, the stops are
 * assumed to spread uniformly across the [0,1] range. When rendered,
 * the colors are mapped to the output colorspace before being
 * interpolated. Defaults to nil. */

@property(copy) NSArray *locations;

- (CGImageRef)newImageGradientInRect:(CGRect)rect;

@end
