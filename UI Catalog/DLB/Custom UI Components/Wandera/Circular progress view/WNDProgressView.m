//
//  WNDProgressView.m
//  DLB
//
//  Created by Matic Oblak on 12/4/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "WNDProgressView.h"
#import "AngleGradientLayer.h"
#import "WNDAngleGradientImageMaker.h"

@interface WNDProgressView()
@property (nonatomic, strong) UIImage *colorWheel;
@property (nonatomic) CGImageRef imageRef;
@end

@implementation WNDProgressView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //color wheel colors
    NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:3];
    [colors addObject:(id)[UIColor colorWithRed:91.0f/255.0f green:166.0f/255.0f blue:242.0f/255.0f alpha:1].CGColor];//start
    [colors addObject:(id)[UIColor colorWithRed:241.0f/255.0f green:187.0f/255.0f blue:87.0f/255.0f alpha:1].CGColor];//middle
    [colors addObject:(id)[UIColor colorWithRed:237.0f/255.0f green:65.0f/255.0f blue:67.0f/255.0f alpha:1].CGColor];//end

    //create CGimageRef
    WNDAngleGradientImageMaker *maker = [[WNDAngleGradientImageMaker alloc] init];
    maker.colors = colors;
    self.imageRef = [maker newImageGradientInRect:self.frame];
}


- (void)drawRect:(CGRect)rect
{
    if (self.backgroundCircleLineWidth == 0)
    {
        self.backgroundCircleLineWidth = self.indicatorLineWidth;
    }
    
    float viewWidth = self.frame.size.width;
    float viewHeight = self.frame.size.height;
    CGPoint center = CGPointMake(viewWidth/2.0f , viewHeight/2.0f);
    CGFloat startAngle = (CGFloat)(-M_PI_2);
    CGFloat endAngle = startAngle + ((CGFloat)(M_PI*2.0)) * self.scale;
    
    float backgroundCircleRadious = viewWidth*0.5f - self.backgroundCircleLineWidth*0.5f;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // background
    // Create circle with bezier for background
    UIBezierPath *backgroundCircle = [UIBezierPath bezierPath];
    [backgroundCircle addArcWithCenter:center
                             radius:backgroundCircleRadious
                         startAngle:0
                           endAngle:2*M_PI
                          clockwise:YES];
    backgroundCircle.lineWidth = self.backgroundCircleLineWidth;
    [self.backgroundCircleLineColor setStroke];
    [backgroundCircle stroke];
    
    // Create circular bezier path for moving indicator
    UIBezierPath *indicatorPath = [UIBezierPath bezierPath];
    [indicatorPath addArcWithCenter:center
                          radius:backgroundCircleRadious + self.indicatorLineWidth*.5f
                      startAngle:startAngle
                        endAngle:endAngle
                       clockwise:YES];
    [indicatorPath addArcWithCenter:center
                             radius:backgroundCircleRadious - self.indicatorLineWidth*.5f
                         startAngle:endAngle
                           endAngle:startAngle
                          clockwise:NO];
    indicatorPath.usesEvenOddFillRule = YES;
    [indicatorPath fill];
    // clip to indicator bezier path
    [indicatorPath addClip];
    
    // draw image
    // miror
    CGContextTranslateCTM(context, 0, viewHeight);
    CGContextScaleCTM(context, 1.0, -1.0);
    // rotate
    CGContextRotateCTM(context, 90*M_PI/180.0f);
    CGContextTranslateCTM(context, 0, -viewHeight);
    CGContextDrawImage(context, CGRectMake(0, 0, viewWidth, viewHeight), self.imageRef);
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
