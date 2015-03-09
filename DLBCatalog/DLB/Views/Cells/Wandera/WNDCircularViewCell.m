//
//  DLBBaseCircularViewCell.m
//  DLB
//
//  Created by Matic Oblak on 12/17/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "WNDCircularViewCell.h"
#import "WNDProgressView.h"

@interface WNDCircularViewCell()

@property (weak, nonatomic) IBOutlet WNDProgressView *circularView;

@end


@implementation WNDCircularViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self layoutIfNeeded];
    [self.circularView layoutIfNeeded];
    [self.circularView awakeFromNib];
    //self.circularView.progressColor = [UIColor blueColor];
    [self.circularView layoutIfNeeded];
    [self animateCircularView];
}

- (void)animateCircularView
{
    //self.circularView.progressColor = [UIColor redColor];
    self.circularView.backgroundCircleStrokeColor = [[UIColor redColor] colorWithAlphaComponent:.3f];
    self.circularView.progressStrokeWidth = 6.0f;
    self.circularView.backgroundCircleStrokeWidth = 12.0f;
    CGFloat value = (CGFloat)(rand()%100)/100.0f;
    [self.circularView setValue:value animated:YES];
    
    [self performSelector:@selector(animateCircularView) withObject:nil afterDelay:3.0];
}

@end
