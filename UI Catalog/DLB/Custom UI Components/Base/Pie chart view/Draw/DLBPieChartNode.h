//
//  DLBPieChartNode.h
//  DLB
//
//  Created by Urban on 12/12/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DLBPieChartSector;

@interface DLBPieChartNode : NSObject

@property (nonatomic, strong) DLBPieChartSector *pieChartSector;

// angle is interpolated from current value to "new" value. From currentStartAngle to newStartAngle
@property (nonatomic) float newStartAngle;
@property (nonatomic) float newEndAngle;
@property (nonatomic) float currentStartAngle;
@property (nonatomic) float currentEndAngle;

@property (nonatomic) BOOL removeOnNextUpdate;
@property (nonatomic) BOOL newThisUpdate;

-(id) initWithSector:(DLBPieChartSector *)sector;

@end
