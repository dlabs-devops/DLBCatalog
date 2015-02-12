//
//  DLBDateTools.m
//  DLB
//
//  Created by Matic Oblak on 1/7/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBDateTools.h"

@implementation DLBDateTools

#pragma mark - private

+ (NSCalendar *)userCalender
{
    static NSCalendar *calender = nil;
    if(calender == nil)
    {
        calender = [NSCalendar autoupdatingCurrentCalendar];
    }
    return calender;
}

#pragma mark - public

+ (NSDate *)date:(NSDate *)date byAddingMonths:(NSInteger)months
{
    if(date == nil)
    {
        return nil;
    }
    return [[NSCalendar autoupdatingCurrentCalendar] dateByAddingUnit:NSCalendarUnitMonth value:months toDate:date options:(NSCalendarOptions)0];
}

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

+ (NSDate *)beginningOfTheDate:(NSDate *)date
{
    if(date == nil)
    {
        return nil;
    }
    
    NSCalendarUnit units = (NSCalendarUnit)(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear);
    NSDateComponents *components = [[self userCalender] components:units fromDate:date];
    
    return [[self userCalender] dateFromComponents:components];
}

+ (NSDate *)beginningOfTheWeek:(NSDate *)date
{
    if(date == nil)
    {
        return nil;
    }
    NSDate *toReturn = nil;
    [[self userCalender] rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&toReturn interval:0 forDate:date];
    return toReturn;
}

+ (NSDate *)beginningOfTheMonth:(NSDate *)date
{
    if(date == nil)
    {
        return nil;
    }
    NSDate *toReturn = nil;
    [[self userCalender] rangeOfUnit:NSCalendarUnitMonth startDate:&toReturn interval:0 forDate:date];
    return toReturn;
}


@end
