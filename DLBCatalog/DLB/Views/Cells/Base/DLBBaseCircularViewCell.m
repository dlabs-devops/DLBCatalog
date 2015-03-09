//
//  DLBBaseCircularViewCell.m
//  DLB
//
//  Created by Matic Oblak on 12/17/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "DLBBaseCircularViewCell.h"
#import "DLBCircularProgressView.h"

@interface DLBBaseCircularViewCell()
@property (weak, nonatomic) IBOutlet DLBCircularProgressView *circularView;

@end


@implementation DLBBaseCircularViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self layoutIfNeeded];
    [self.circularView layoutIfNeeded];
    [self.circularView awakeFromNib];
    self.circularView.progressColor = [UIColor blueColor];
    [self.circularView layoutIfNeeded];
    [self animateCircularView];
}

- (void)animateCircularView
{
    self.circularView.progressColor = [UIColor blueColor];
    CGFloat value = (CGFloat)(rand()%100)/100.0f;
    [self.circularView setValue:value animated:YES];
    
    [self performSelector:@selector(animateCircularView) withObject:nil afterDelay:3.0];
}

@end
