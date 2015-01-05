//
//  DLBNumericCounterComponent.m
//  DLB
//
//  Created by Matic Oblak on 1/5/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBNumericCounterComponent.h"

@interface DLBNumericCounterComponent()

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, strong) UILabel *bottomLabel;

@end

@implementation DLBNumericCounterComponent

- (UILabel *)topLabel
{
    if(_topLabel == nil)
    {
        _topLabel = [[UILabel alloc] initWithFrame:[self rectForTopLabel]];
        _topLabel.adjustsFontSizeToFitWidth = YES;
        _topLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _topLabel.text = [self textForValue:self.mainValue+1];
        _topLabel.font = self.font;
        _topLabel.textColor = self.textColor;
        [self addSubview:_topLabel];
    }
    return _topLabel;
}

- (UILabel *)mainLabel
{
    if(_mainLabel == nil)
    {
        _mainLabel = [[UILabel alloc] initWithFrame:[self rectForMainLabel]];
        _mainLabel.adjustsFontSizeToFitWidth = YES;
        _mainLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _mainLabel.text = [self textForValue:self.mainValue];
        _mainLabel.font = self.font;
        _mainLabel.textColor = self.textColor;
        [self addSubview:_mainLabel];
    }
    return _mainLabel;
}

- (UILabel *)bottomLabel
{
    if(_bottomLabel == nil)
    {
        _bottomLabel = [[UILabel alloc] initWithFrame:[self rectForBottomLabel]];
        _bottomLabel.adjustsFontSizeToFitWidth = YES;
        _bottomLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _bottomLabel.text = [self textForValue:self.mainValue-1];
        _bottomLabel.font = self.font;
        _bottomLabel.textColor = self.textColor;
        [self addSubview:_bottomLabel];
    }
    return _bottomLabel;
}

- (NSString *)textForValue:(NSInteger)value
{
    while(value < 0)
    {
        value += 10;
    }
    while(value > 9)
    {
        value -= 10;
    }
    if(value == 0 && self.allowZero == NO)
    {
        return @"";
    }
    return [@(value) stringValue];
}

- (CGRect)rectForTopLabel
{
    return CGRectMake(.0f, self.frame.size.height*(-1.0f-self.offsetScale), self.frame.size.width, self.frame.size.height);
}

- (CGRect)rectForMainLabel
{
    return CGRectMake(.0f, self.frame.size.height*(-self.offsetScale), self.frame.size.width, self.frame.size.height);
}

- (CGRect)rectForBottomLabel
{
    return CGRectMake(.0f, self.frame.size.height*(1.0f-self.offsetScale), self.frame.size.width, self.frame.size.height);
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    self.topLabel.font = font;
    self.mainLabel.font = font;
    self.bottomLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.topLabel.textColor = textColor;
    self.mainLabel.textColor = textColor;
    self.bottomLabel.textColor = textColor;
}

- (void)setOffsetScale:(CGFloat)offsetScale
{
    _offsetScale = offsetScale;
    self.topLabel.frame = [self rectForTopLabel];
    self.mainLabel.frame = [self rectForMainLabel];
    self.bottomLabel.frame = [self rectForBottomLabel];
}

- (void)setMainValue:(NSInteger)mainValue
{
    _mainValue = mainValue;
    self.topLabel.text = [self textForValue:self.mainValue+1];
    self.mainLabel.text = [self textForValue:self.mainValue];
    self.bottomLabel.text =  [self textForValue:self.mainValue-1];
}

- (void)setFrom:(CGFloat)start to:(CGFloat)end scale:(CGFloat)scale
{
    CGFloat current = (NSInteger)start + scale*((NSInteger)end-(NSInteger)start);
    
    NSInteger mainValue = [self round:current];
    CGFloat offset = mainValue-current;
    
    BOOL shouldHideZero = fabsf((float)current) < 5.0f;
    
    while (mainValue>10) {
        mainValue-=10;
    }
    while (mainValue<0) {
        mainValue+=10;
    }
    
    self.allowZero = !shouldHideZero;
    
    self.mainValue = mainValue;
    self.offsetScale = offset;
    
    self.mainLabel.alpha = 1.0f-fabsf((float)offset);
    self.topLabel.alpha = offset;
    self.bottomLabel.alpha = offset;
}

- (NSInteger)round:(CGFloat)amount
{
    return (NSInteger)(roundf((float)amount));
}

@end
