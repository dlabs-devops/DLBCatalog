//
//  DLBCircularProgressView.m
//  DLB
//
//  Created by Matic Oblak on 12/4/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "DLBCircularProgressView.h"
#import "DLBAnimations.h"

@interface DLBCircularProgressView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, readonly) CGFloat scale;
@property (nonatomic, strong) DLBAnimatableFloat *animatableScale;
@end

@implementation DLBCircularProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame]))
    {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
    [[NSBundle mainBundle] loadNibNamed:@"DLBCircularProgressView" owner:self options:nil];
    
    // The following is to make sure content view, extends out all the way to fill whatever our view size is even as our view's size is changed by autolayout
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview: self.contentView];
    
    [[self class] addEdgeConstraint:NSLayoutAttributeLeft superview:self subview:self.contentView];
    [[self class] addEdgeConstraint:NSLayoutAttributeRight superview:self subview:self.contentView];
    [[self class] addEdgeConstraint:NSLayoutAttributeTop superview:self subview:self.contentView];
    [[self class] addEdgeConstraint:NSLayoutAttributeBottom superview:self subview:self.contentView];
    
    [self resetToDefaults];
    
    [self layoutIfNeeded];
}

+ (void)addEdgeConstraint:(NSLayoutAttribute)edge superview:(UIView *)superview subview:(UIView *)subview
{
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                          attribute:edge
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:edge
                                                         multiplier:1
                                                           constant:0]];
}

- (CGFloat)scale
{
    if(self.maximumValue > self.minimumValue)
    {
        return (self.value-self.minimumValue)/(self.maximumValue-self.minimumValue);
    }
    else
    {
        return .0f;
    }
}

- (void)resetToDefaults
{
    self.minimumValue = .0f;
    self.maximumValue = 1.0f;
    self.value = .0f;
    self.indicatorColor = [UIColor whiteColor];
    self.indicatorLineWidth = 6.0f;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setValue:(CGFloat)value
{
    if(value > self.maximumValue)
    {
        value = self.maximumValue;
    }
    else if(value < self.minimumValue)
    {
        value = self.minimumValue;
    }
    _value = value;
    [self setNeedsDisplay];
}

- (void)setValue:(CGFloat)value animated:(BOOL)animated
{
    if(animated)
    {
        self.animatableScale = [[DLBAnimatableFloat alloc] initWithStartValue:self.value];
        self.animatableScale.animationStyle = DLBAnimationStyleEaseInOut;
        [self.animatableScale animateTo:value withDuration:.5 onFrameBlock:^(BOOL willEnd) {
            self.value = self.animatableScale.floatValue;
            if(willEnd)
            {
                self.animatableScale = nil;
            }
        }];
    }
    else
    {
        [self.animatableScale invalidateAnimation];
        self.value = value;
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat border = self.indicatorLineWidth*.5f;
    // background
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(.0f, .0f, self.frame.size.width, self.frame.size.height));
    
    CGContextSetLineWidth(context, self.indicatorLineWidth);
    CGFloat startAngle = (CGFloat)(-M_PI_2);
    CGFloat endAngle = startAngle + ((CGFloat)(M_PI*2.0))*self.scale;
    // draw full circle
    CGContextSetStrokeColorWithColor(context, [self indicatorColor].CGColor);
    CGContextSetLineWidth(context, self.indicatorLineWidth);
    CGContextMoveToPoint(context, self.frame.size.width*.5f, .0f);
    CGContextAddArc(context, self.frame.size.width*.5f, self.frame.size.height*.5f, self.frame.size.width*.5f-border, startAngle, endAngle, 0);
    CGContextStrokePath(context);
}

@end
