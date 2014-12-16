//
//  DLBPieChartSector.m
//  DLB
//
//  Created by Urban on 11/12/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "DLBPieChartSector.h"

@implementation DLBPieChartSector

- (instancetype)initWithSectorValue:(float)value sectorColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        self.sectorValue = value;
        self.sectorColor = color;
    }
    return self;
}


@end
