//
//  DLBNumericCounterComponent.h
//  DLB
//
//  Created by Matic Oblak on 1/5/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLBNumericCounterComponent : UIView

@property (nonatomic) NSInteger mainValue;
@property (nonatomic) CGFloat offsetScale;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic) BOOL allowZero;

- (void)setFrom:(CGFloat)start to:(CGFloat)end scale:(CGFloat)scale;

@end
