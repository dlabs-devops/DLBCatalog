//
//  DLBDateTools.h
//  DLB
//
//  Created by Matic Oblak on 1/7/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

@import Foundation;

@interface DLBDateTools : NSObject

+ (NSDate *)date:(NSDate *)date byAddingDays:(NSInteger)days;
+ (NSDate *)date:(NSDate *)date byAddingHours:(NSInteger)hours;

@end
