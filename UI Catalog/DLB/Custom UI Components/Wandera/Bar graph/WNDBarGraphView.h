//
//  WNDBarGraphView.h
//  DLB
//
//  Created by Matic Oblak on 1/7/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

@import UIKit;
#import "WNDBarGraphTools.h"

@class WNDBarGraphView;
@class DLBBarGraphView;
@class WNDBarGraphDataObject;

#pragma mark - Data source

@protocol WNDBarGraphViewDataSource <NSObject>
//
// Return a value on a specific time range
// Start date should be inclusive (X>=T)
// End date should be exclusive (X<T)
//
- (NSNumber *)WNDBarGraphView:(WNDBarGraphView *)sender valueFrom:(NSDate *)startDate to:(NSDate *)endDate;
//
// Return a secondary value on a specific time range
// Start date should be inclusive (X>=T)
// End date should be exclusive (X<T)
//
- (NSNumber *)WNDBarGraphView:(WNDBarGraphView *)sender secondaryValueFrom:(NSDate *)startDate to:(NSDate *)endDate;
//
// Return graph scale.
// This value represents the top most point on the graph
//
- (NSNumber *)WNDBarGraphViewGraphScale:(WNDBarGraphView *)sender;
//
// Return a date representing a left most point on the graph
//
- (NSDate *)WNDBarGraphViewDisplayStartDate:(WNDBarGraphView *)sender;
//
// Return a date representing a right most point on the graph
//
- (NSDate *)WNDBarGraphViewDisplayEndDate:(WNDBarGraphView *)sender;
//
// Return a component period
// Represents a time interval for a single bar
//
- (eBarGraphComponentPeriod)WNDBarGraphViewDisplayComponentPeriod:(WNDBarGraphView *)sender;

@end

#pragma mark - Class

@interface WNDBarGraphView : UIView

@property (nonatomic, weak) id<WNDBarGraphViewDataSource> dataSource;

@property (nonatomic, strong) UIColor *primaryBarColor;
@property (nonatomic, strong) UIColor *secondaryBarColor;

@property (nonatomic) CGFloat barWidth;

@property (nonatomic, readonly) WNDBarGraphDataObject *currentDataObject;

//
// Will return NO if refresh is internaly blocked
// Try recalling later
//
- (BOOL)refreshWithStyle:(eBarGraphTransitionStyle)style animated:(BOOL)animated;

@end
