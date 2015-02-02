//
//  DLBDateTools.h
//  DLB
//
//  Created by Matic Oblak on 1/7/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

@import Foundation;

@interface DLBDateTools : NSObject

+ (NSDate *)date:(NSDate *)date byAddingMonths:(NSInteger)months;
+ (NSDate *)date:(NSDate *)date byAddingDays:(NSInteger)days;
+ (NSDate *)date:(NSDate *)date byAddingHours:(NSInteger)hours;

//
// Returns the beginning of the given date according to local time zone
//
+ (NSDate *)beginningOfTheDate:(NSDate *)date;
//
// Returns the beginning of the given week according to local time zone
//
+ (NSDate *)beginningOfTheWeek:(NSDate *)date;
//
// Returns the beginning of the given month according to local time zone
//
+ (NSDate *)beginningOfTheMonth:(NSDate *)date;

@end
