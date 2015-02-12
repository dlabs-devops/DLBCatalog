//
//  WNDPieChart.m
//  DLB
//
//  Created by Urban on 11/12/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "WNDPieChart.h"

@implementation WNDPieChart

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setWanderaDefaults];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame]))
    {
        [self setWanderaDefaults];
    }
    return self;
}

- (void)setWanderaDefaults
{
    self.shadowWidth = 10.0f;
    self.shadowColor = [UIColor blackColor];
}

@end
