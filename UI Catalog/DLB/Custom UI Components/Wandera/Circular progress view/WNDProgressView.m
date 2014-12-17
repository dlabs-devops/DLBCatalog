//
//  WNDProgressView.m
//  DLB
//
//  Created by Matic Oblak on 12/4/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "WNDProgressView.h"

@interface WNDProgressView()
@property (nonatomic, strong) UIImage *colorWheel;
@end

@implementation WNDProgressView

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.colorWheel = [UIImage imageNamed:@"wandera_indicator_gradient"];
}

- (void)drawRect:(CGRect)rect
{
    if (self.backgroundCircleStrokeWidth == 0)
    {
        self.backgroundCircleStrokeWidth = self.indicatorLineWidth;
    }
    
    float viewWidth = self.frame.size.width;
    float viewHeight = self.frame.size.height;
    CGPoint center = CGPointMake(viewWidth/2.0f , viewHeight/2.0f);
    CGFloat startAngle = (CGFloat)(-M_PI_2);
    CGFloat endAngle = startAngle + ((CGFloat)(M_PI*2.0)) * self.scale;
    
    float backgroundCircleRadius = viewWidth*0.5f - self.backgroundCircleStrokeWidth*0.5f;
    
    // background
    // Create circle with bezier for background
    UIBezierPath *backgroundCircle = [UIBezierPath bezierPath];
    [backgroundCircle addArcWithCenter:center
                             radius:backgroundCircleRadius
                         startAngle:0
                           endAngle:2.0f*M_PI
                          clockwise:YES];
    backgroundCircle.lineWidth = self.backgroundCircleStrokeWidth;
    [self.backgroundCircleStrokeColor setStroke];
    [backgroundCircle stroke];
    
    // Create circular bezier path for moving indicator
    UIBezierPath *indicatorPath = [UIBezierPath bezierPath];
    [indicatorPath addArcWithCenter:center
                          radius:backgroundCircleRadius + self.indicatorLineWidth*.5f
                      startAngle:startAngle
                        endAngle:endAngle
                       clockwise:YES];
    [indicatorPath addArcWithCenter:center
                             radius:backgroundCircleRadius - self.indicatorLineWidth*.5f
                         startAngle:endAngle
                           endAngle:startAngle
                          clockwise:NO];
    indicatorPath.usesEvenOddFillRule = YES;
    [indicatorPath fill];
    // clip to indicator bezier path
    [indicatorPath addClip];
    
    // draw image
    [self.colorWheel drawInRect:CGRectMake(0, 0, viewWidth, viewHeight)];
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


@end
