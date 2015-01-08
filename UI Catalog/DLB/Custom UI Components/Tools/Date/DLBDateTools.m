//
//  DLBDateTools.m
//  DLB
//
//  Created by Matic Oblak on 1/7/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBDateTools.h"

@implementation DLBDateTools

+ (NSDate *)date:(NSDate *)date byAddingDays:(NSInteger)days
{
    if(date == nil)
    {
        return nil;
    }
    return [[NSCalendar autoupdatingCurrentCalendar] dateByAddingUnit:NSCalendarUnitDay value:days toDate:date options:(NSCalendarOptions)0];
}

+ (NSDate *)date:(NSDate *)date byAddingHours:(NSInteger)hours
{
    if(date == nil)
    {
        return nil;
    }
    return [[NSCalendar autoupdatingCurrentCalendar] dateByAddingUnit:NSCalendarUnitHour value:hours toDate:date options:(NSCalendarOptions)0];
}

@end
