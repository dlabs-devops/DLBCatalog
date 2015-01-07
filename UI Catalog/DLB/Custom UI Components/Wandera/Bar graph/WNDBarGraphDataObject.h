//
//  WNDBarGraphDataObject.h
//  DLB
//
//  Created by Matic Oblak on 1/7/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

@import UIKit;
#import "WNDBarGraphTools.h"

@interface WNDBarGraphDataObject : NSObject

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic) NSInteger componentCount;
@property (nonatomic, strong) NSArray *componentValues;

@property (nonatomic) CGFloat scale;

@property (nonatomic) eBarGraphComponentPeriod componentPeriod;


@property (nonatomic, readonly) NSArray *componentStartDates;

//
// Will construct all missing parameters
//
- (void)commitData;
//
// A convenience method to return a value at index or zero if out of bounds
//
- (NSNumber *)valueAtIndex:(NSInteger)index;

@end
