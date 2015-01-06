//
//  DLBAnimatable.h
//  DLB
//
//  Created by Matic Oblak on 12/4/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

@import Foundation;
@import UIKit;

#import "DLBInterpolations.h"

typedef enum : NSUInteger {
    DLBAnimationStyleLinear,
    DLBAnimationStyleEaseIn,
    DLBAnimationStyleEaseOut,
    DLBAnimationStyleEaseInOut
} DLBAnimationStyle;

@interface DLBAnimatable : NSObject
@property (nonatomic) DLBAnimationStyle animationStyle;

- (void)animateWithDuration:(NSTimeInterval)duration;
- (void)animateWithDuration:(NSTimeInterval)duration onFrameBlock:(void (^)(BOOL willENd))frameBlock;
- (void)invalidateAnimation;

- (void)onFrame;
- (CGFloat)currentInterpolator;

@end
