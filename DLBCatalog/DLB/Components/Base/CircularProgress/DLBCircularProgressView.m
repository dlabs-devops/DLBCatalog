//
//  DLBCircularProgressView.m
//  DLB
//
//  Created by Matic Oblak on 12/4/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "DLBCircularProgressView.h"
#import "DLBAnimations.h"

#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)

@interface DLBCircularProgressView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, readonly) CGFloat scale;
@property (nonatomic, strong) DLBAnimatableFloat *animatableScale;
// Property used to store UIColor while cross fading.
@property (nonatomic, nonatomic) UIColor *tempColor;
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
#if TARGET_INTERFACE_BUILDER
    [[NSBundle bundleForClass:[self class]] loadNibNamed:@"DLBCircularProgressView" owner:self options:nil];
#else
    [[NSBundle mainBundle] loadNibNamed:@"DLBCircularProgressView" owner:self options:nil];
#endif

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

- (CGFloat)animationTime
{
    if (fequal(_animationTime, 0))
    {
        _animationTime = 0.5f;
    }

    return _animationTime;
}

- (void)resetToDefaults
{
    self.minimumValue = .0f;
    self.maximumValue = 1.0f;
    self.value = .0f;
    self.progressStrokeWidth = 6.0f;
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

- (void)setValue:(CGFloat)value animated:(BOOL)animated withCompletion:(void(^)(void))completion
{
    if(animated)
    {
        if (self.animatableScale)
        {
            [self.animatableScale invalidateAnimation];
            self.animatableScale = nil;
        }

        self.animatableScale = [[DLBAnimatableFloat alloc] initWithStartValue:self.value];
        self.animatableScale.animationStyle = DLBAnimationStyleEaseInOut;
        [self.animatableScale animateTo:value withDuration:self.animationTime onFrameBlock:^(BOOL willEnd) {
            self.value = self.animatableScale.floatValue;
            if(willEnd)
            {
                if (completion)
                {
                    completion();
                }
            }
        }];
    }
    else
    {
        [self.animatableScale invalidateAnimation];
        self.value = value;

        if (completion)
        {
            completion();
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    if (self.backgroundCircleStrokeWidth <= (CGFloat).0f)
    {
        self.backgroundCircleStrokeWidth = (float)self.progressStrokeWidth;
    }

    CGFloat viewWidth = self.frame.size.width;
    CGFloat viewHeight = self.frame.size.height;
    CGPoint center = CGPointMake(viewWidth/2.0f , viewHeight/2.0f);
    CGFloat startAngle = (CGFloat)(-M_PI_2);
    CGFloat endAngle = startAngle + ((CGFloat)(M_PI*2.0)) * self.scale;

    CGFloat backgroundCircleRadius = viewWidth*0.5f - self.backgroundCircleStrokeWidth*0.5f;

    // background
    // Create circle with bezier for background
    UIBezierPath *backgroundCircle = [UIBezierPath bezierPath];
    [backgroundCircle addArcWithCenter:center
                                radius:backgroundCircleRadius
                            startAngle:0
                              endAngle:2.0f*(CGFloat)M_PI
                             clockwise:YES];
    backgroundCircle.lineWidth = self.backgroundCircleStrokeWidth;
    [self.backgroundCircleStrokeColor setStroke];
    [backgroundCircle stroke];

    // Create clip mask
    // Create circular bezier path for moving indicator
    UIBezierPath *indicatorPath = [UIBezierPath bezierPath];
    [indicatorPath addArcWithCenter:center
                             radius:backgroundCircleRadius + self.progressStrokeWidth*.5f
                         startAngle:startAngle
                           endAngle:endAngle
                          clockwise:YES];
    [indicatorPath addArcWithCenter:center
                             radius:backgroundCircleRadius - self.progressStrokeWidth*.5f
                         startAngle:endAngle
                           endAngle:startAngle
                          clockwise:NO];
    indicatorPath.usesEvenOddFillRule = YES;
    [indicatorPath fill];

    // clip to indicator bezier path
    [indicatorPath addClip];

    [self drawInProgressClipRect:rect withContext:UIGraphicsGetCurrentContext()];


}

- (void)drawInProgressClipRect:(CGRect)rect withContext:(CGContextRef)context
{

}

@end
