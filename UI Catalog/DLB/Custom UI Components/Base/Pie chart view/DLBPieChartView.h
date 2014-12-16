//
//  DLBPieChart.h
//  DLB
//
//  Created by Urban on 11/12/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DLBPieChartSector;

/**
 *  Draws pie chart view.
 */
@interface DLBPieChartView : UIView

/**
 *  Radious of pie chart
 */
@property (nonatomic) float radious;

/**
 *  Current scale for animation
 */
@property (nonatomic) float scale;

/**
 *  Sets pie chart sectors.
 *
 *  @param sectors - array of pie chart sectors (DLBPieChartSector)
 *  @param animate - is animatable
 */
- (void)setChartSectors:(NSArray *)sectors animated:(BOOL)animate;


@end
