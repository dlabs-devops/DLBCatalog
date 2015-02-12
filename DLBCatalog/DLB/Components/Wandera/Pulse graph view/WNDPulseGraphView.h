//
//  WNDPulseGraphView.h
//  DLB
//
//  Created by Matic Oblak on 12/16/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

@import UIKit;
#import "DLBPulseGraphView.h"

@interface WNDPulseGraphView : DLBPulseGraphView

@property (nonatomic) CGFloat speed;
@property (nonatomic) NSInteger indicatorCount;

- (void)startAnimating;
- (void)stopAnimating;

@end
