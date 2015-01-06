//
//  DLBNumericCounterView.h
//  DLB
//
//  Created by Matic Oblak on 1/5/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLBNumericCounterView : UIView
//
// Minimum value the counter is able to display
// Default is 0
//
@property (nonatomic) NSInteger minimumValue;
//
// Maximum value the counter is able to display
// Default is 100
//
@property (nonatomic) NSInteger maximumValue;
//
// Font used in the counter
// Default is system font of size 60
//
@property (nonatomic, strong) UIFont *font;
//
// Text color used in the counter
// Default is black
//
@property (nonatomic, strong) UIColor *textColor;
//
// Current presented value
// Default is 0
//
@property (nonatomic) NSInteger currentValue;
//
// Component width depended on the height
// Default is 32/48
//
@property (nonatomic) CGFloat componentWHRatio;
//
// Component alignment on the view
// Default is right
//
@property (nonatomic) NSTextAlignment componentAlignment;
//
// Suffix component
// Default is nil
//
@property (nonatomic, strong) NSString *suffix;
@property (nonatomic, strong) UIFont *suffixFont;
@property (nonatomic, strong) UIColor *suffixColor;
//
// Set the current value
// Can animate
//
- (void)setCurrentValue:(NSInteger)currentValue animated:(BOOL)animated;

@end
