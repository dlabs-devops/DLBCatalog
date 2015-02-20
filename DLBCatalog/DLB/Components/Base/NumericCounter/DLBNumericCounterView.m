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
@property (nonatomic) NSInteger internalCurrentValue;

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


- (NSInteger)currentValue
{
    return self.internalCurrentValue;
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
        self.internalCurrentValue = currentValue;
    }
    else
    {
        if(self.animatedScale)
        {
            self.internalCurrentValue = self.currentValue + (NSInteger)(self.animatedScale.floatValue*(self.backupValue-self.currentValue));
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
    if((NSInteger)self.viewComponents.count>index && index>=0)
    {
        return self.viewComponents[(NSUInteger)index];
    }
    return nil;
}

- (CGRect)frameForIndex:(NSInteger)index elementCount:(NSInteger)elementCount
{
    if(elementCount == 0)
    {
        return CGRectZero;
    }
    CGFloat componentWidth = self.frame.size.height*self.componentWHRatio*.7f;
    if(self.componentAlignment == NSTextAlignmentCenter)
    {
        if(elementCount%2)
        {
            NSInteger middle = elementCount/2+1;
            NSInteger offsetCount = middle-(index+1);
            return CGRectMake(self.frame.size.width*.5f+componentWidth*(-.5f+offsetCount),
                              .0f,
                              componentWidth,
                              self.frame.size.height);
        }
        else
        {
            NSInteger middle = elementCount/2;
            NSInteger offsetCount = middle-(index+1);
            return CGRectMake(self.frame.size.width*.5f+componentWidth*(offsetCount),
                              .0f,
                              componentWidth,
                              self.frame.size.height);
        }
    }
    else if(self.componentAlignment == NSTextAlignmentLeft)
    {
        return CGRectMake(componentWidth*(elementCount-index-1),
                          .0f,
                          componentWidth,
                          self.frame.size.height);
    }
    else
    {
        return CGRectMake(self.frame.size.width-componentWidth*(1.0f+index),
                          .0f,
                          componentWidth,
                          self.frame.size.height);
    }
}

- (NSInteger)componentCountForValue:(NSInteger)value
{
    NSInteger toReturn = self.suffix?1:0;
    if(value == 0 && self.zeroValueOptional == NO)
    {
        return toReturn+1;
    }
    while (value>0) {
        value/=10;
        toReturn++;
    }
    return toReturn;
}

- (void)repositionViewsForScale:(CGFloat)scale from:(NSInteger)start to:(NSInteger)end
{
    NSInteger iterator = 0;
    
    CGRect componentFrame = CGRectZero;
    
    CGFloat frameScale = .0f;
    static const CGFloat frameScaleTreshold = .8f;
    if(scale > frameScaleTreshold)
    {
        frameScale = (scale-frameScaleTreshold)/(1.0f-frameScaleTreshold);
    }
    
    if(self.suffix)
    {
        componentFrame = [DLBInterpolations interpolateRect:[self frameForIndex:iterator elementCount:[self componentCountForValue:start]]
                                                       with:[self frameForIndex:iterator elementCount:[self componentCountForValue:end]]
                                                      scale:frameScale
                                            excludeZeroRect:YES];
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
    NSInteger firstValueIndex = iterator;
    NSInteger startComponentCount = [self componentCountForValue:start];
    NSInteger endComponentCount = [self componentCountForValue:end];
    while (startf >= 1.0f ||
           endf >= 1.0f ||
           iterator < (NSInteger)self.viewComponents.count ||
           iterator < startComponentCount ||
           iterator < endComponentCount)
    {
        componentFrame = [DLBInterpolations interpolateRect:[self frameForIndex:iterator elementCount:[self componentCountForValue:start]]
                                                       with:[self frameForIndex:iterator elementCount:[self componentCountForValue:end]]
                                                      scale:frameScale
                                            excludeZeroRect:YES];

        DLBNumericCounterComponent *component = [self componentAtIndex:iterator];
        if(component == nil)
        {
            component = [[DLBNumericCounterComponent alloc] initWithFrame:componentFrame];
            component.textColor = self.textColor;
            component.font = self.font;
            [self addSubview:component];
            [self.viewComponents addObject:component];
        }
        component.forceZero = iterator == firstValueIndex;
        component.frame = componentFrame;
        component.staticString = nil;
        [component setFrom:startf to:endf scale:scale];
        startf/=10.0f;
        endf/=10.0f;
        iterator++;
    }
}


@end
