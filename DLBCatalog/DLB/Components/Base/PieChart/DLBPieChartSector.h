//
//  DLBPieChartSector.h
//  DLB
//
//  Created by Urban on 11/12/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

@import UIKit;

@interface DLBPieChartSector : NSObject

@property (nonatomic, strong) id userInfo;
@property (nonatomic) float sectorValue;
@property (nonatomic, strong) UIColor *sectorColor;

- (instancetype)initWithSectorValue:(float)value sectorColor:(UIColor *)color;

@end

