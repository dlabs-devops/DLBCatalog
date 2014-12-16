//
//  DLBPieChartNode.m
//  DLB
//
//  Created by Urban on 12/12/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "DLBPieChartNode.h"

@implementation DLBPieChartNode

- (instancetype)initWithSector:(DLBPieChartSector *)sector
{
    self = [super init];
    if (self) {
        self.pieChartSector = sector;
    }
    return self;
}

@end
