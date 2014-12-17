//
//  DLBPulseGraphCell.m
//  DLB
//
//  Created by Matic Oblak on 12/17/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "WNDPulseGraphCell.h"
#import "WNDPulseGraphView.h"

@interface WNDPulseGraphCell()
@property (weak, nonatomic) IBOutlet WNDPulseGraphView *pulseGraph;

@end


@implementation WNDPulseGraphCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.pulseGraph startAnimating];
}

@end
