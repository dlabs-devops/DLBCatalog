//
//  DLBNumericCounterView.m
//  DLB
//
//  Created by Matic Oblak on 1/5/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBNumericCounterView.h"
#import "DLBAnimatableFloat.h"
#import "DLBNumericCounterComponent.h"

@interface DLBNumericCounterView()

@property (nonatomic, strong) DLBAnimatableFloat *animatedScale;
@property (nonatomic, strong) NSMutableArray *viewComponents;
@property (nonatomic) NSInteger backupValue;

@end


@implementation DLBNumericCounterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame]))
    {
        [self loadDefaults];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        [self loadDefaults];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor clearColor].CGColor,
                            (id)[UIColor whiteColor].CGColor,
                            (id)[UIColor whiteColor].CGColor,
                            (id)[UIColor clearColor].CGColor,
                            nil];  
    gradientLayer.locations = @[@.0,
                                @.3,
                                @.7,
                                @1.0];
    self.layer.mask = gradientLayer;
}

- (void)loadDefaults
{
    self.minimumValue = 0;
    self.maximumValue = 100;
    self.currentValue = 0;
    self.componentWHRatio = 32.0f/48.0f;
    self.componentAlignment = NSTextAlignmentRight;
}

- (UIFont *)font
{
    if(_font == nil)
    {
        return [UIFont systemFontOfSize:200.0f];
    }
    return _font;
}

- (UIFont *)suffixFont
{
    if(_suffixFont == nil)
    {
        return [UIFont systemFontOfSize:30.0f];
    }
    return _suffixFont;
}

- (UIColor *)suffixColor
{
    if(_suffixColor == nil)
    {
        return self.textColor;
    }
    return _suffixColor;
}

- (void)setCurrentValue:(NSInteger)currentValue
{
    [self setCurrentValue:currentValue animated:NO];
}


- (void)setCurrentValue:(NSInteger)currentValue animated:(BOOL)animated
{
    if(animated == NO)
    {
        [self.animatedScale invalidateAnimation];
        [self repositionViewsForScale:1.0f from:self.currentValue to:currentValue];
        self.animatedScale = nil;
        _currentValue = currentValue;
    }
    else
    {
        NSLog(@"Animating to: %@", [@(currentValue) stringValue]);
        if(self.animatedScale)
        {
            _currentValue = self.currentValue + self.animatedScale.floatValue*(self.backupValue-self.currentValue);
            [self.animatedScale invalidateAnimation];
        }
        self.animatedScale = [[DLBAnimatableFloat alloc] initWithStartValue:.0f];
        self.animatedScale.animationStyle = DLBAnimationStyleEaseInOut;
        self.backupValue = currentValue;
        [self.animatedScale animateTo:1.0f withDuration:2.0 onFrameBlock:^(BOOL willENd) {
            if(willENd)
            {
                [self setCurrentValue:self.backupValue animated:NO];
            }
            else
            {
                [self repositionViewsForScale:self.animatedScale.floatValue from:self.currentValue to:self.backupValue];
            }
        }];
    }
    
}

- (UIColor *)textColor
{
    if(_textColor == nil)
    {
        return [UIColor blackColor];
    }
    return _textColor;
}

#pragma mark - internal

- (NSMutableArray *)viewComponents
{
    if(_viewComponents == nil)
    {
        _viewComponents = [[NSMutableArray alloc] init];
    }
    return _viewComponents;
}

- (DLBNumericCounterComponent *)componentAtIndex:(NSInteger)index
{
    if(self.viewComponents.count>index && index>=0)
    {
        return self.viewComponents[(NSUInteger)index];
    }
    return nil;
}

- (CGRect)frameForIndex:(NSInteger)index elementCount:(NSInteger)elementCount
{
    CGFloat componentWidth = self.frame.size.height*self.componentWHRatio*.7f;
    return CGRectMake(self.frame.size.width-componentWidth*(1.0f+index),
                      .0f,
                      componentWidth,
                      self.frame.size.height);
}

- (void)repositionViewsForScale:(CGFloat)scale from:(NSInteger)start to:(NSInteger)end
{
    NSInteger iterator = 0;
    
    CGRect componentFrame = [self frameForIndex:iterator elementCount:0];
    
    if(self.suffix)
    {
        componentFrame = [self frameForIndex:iterator elementCount:0];
        DLBNumericCounterComponent *component = [self componentAtIndex:iterator];
        if(component == nil)
        {
            component = [[DLBNumericCounterComponent alloc] initWithFrame:componentFrame];
            component.textColor = self.suffixColor;
            component.font = self.suffixFont;
            [self addSubview:component];
            [self.viewComponents addObject:component];
        }
        component.frame = componentFrame;
        component.staticString = self.suffix;
        iterator++;
    }
    
    CGFloat startf = (CGFloat)start;
    CGFloat endf = (CGFloat)end;
    while (startf >= 1.0f || endf >= 1.0f || iterator<self.viewComponents.count) {
        componentFrame = [self frameForIndex:iterator elementCount:0];
        DLBNumericCounterComponent *component = [self componentAtIndex:iterator];
        if(component == nil)
        {
            component = [[DLBNumericCounterComponent alloc] initWithFrame:componentFrame];
            component.textColor = self.textColor;
            component.font = self.font;
            [self addSubview:component];
            [self.viewComponents addObject:component];
        }
        component.frame = componentFrame;
        component.staticString = nil;
        [component setFrom:startf to:endf scale:scale];
        startf/=10.0f;
        endf/=10.0f;
        iterator++;
    }
}

- (UILabel *)defaultLabelComponent
{
    UILabel *toReturn = [[UILabel alloc] initWithFrame:CGRectMake(.0f, .0f, self.componentWHRatio*self.frame.size.height, self.frame.size.height)];
    toReturn.textColor = [UIColor blackColor];
    toReturn.font = self.font;
    toReturn.adjustsFontSizeToFitWidth = YES;
    return toReturn;
}

- (void)removeSubviewsOnView:(UIView *)view
{
    for(UIView *view in view.subviews)
    {
        [view removeFromSuperview];
    }
}

@end
