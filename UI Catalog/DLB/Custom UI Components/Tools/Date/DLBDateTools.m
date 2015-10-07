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

+ (NSDateComponents *)dateComponentsBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime forCalendarUnit:(NSCalendarUnit)calendarUnit
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:calendarUnit startDate:&fromDate interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:calendarUnit startDate:&toDate interval:NULL forDate:toDateTime];
    
    return [calendar components:calendarUnit fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
}


+ (NSInteger)daysBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime
{
    NSDateComponents *difference = [self dateComponentsBetweenDate:fromDateTime andDate:toDateTime forCalendarUnit:NSCalendarUnitDay];
    return difference.day;
}

+ (NSInteger)monthsBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime
{
    return [self dateComponentsBetweenDate:fromDateTime andDate:toDateTime forCalendarUnit:NSCalendarUnitMonth].month;
}
+ (NSInteger)yearsBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime
{
    return [self dateComponentsBetweenDate:fromDateTime andDate:toDateTime forCalendarUnit:NSCalendarUnitYear].year;
}

+ (NSString *)durationStringFrom:(NSDate *)startDate to:(NSDate *)endDate
{
    NSTimeInterval interval = [endDate timeIntervalSinceDate:startDate];
    if(interval < .0)
    {
        return nil;
    }
    
    int minutes = (int)(interval/60.0);
    
    if(interval < 3.0*60.0)
    {
        return @"Just now";
    }
    else if(interval < 30.0*60.0)
    {
        return [NSString stringWithFormat:@"%d minutes ago", minutes];
    }
    else if(interval < 60.0*60.0)
    {
        return @"Less then an hour ago";
    }
    else // go to hours
    {
        int hours = (int)(interval/(60.0*60.0));
        if(hours < 2)
        {
            return @"About an hour ago";
        }
        else if(hours <= 8)
        {
            return [NSString stringWithFormat:@"%d hours ago", hours];
        }
        else // go to days
        {
            NSDate *thisDate = [NSDate date];
            NSDate *castDate = [[NSDate date] dateByAddingTimeInterval:-interval];
            int days = (int)[self daysBetweenDate:castDate andDate:thisDate];
            if(days == 0)
            {
                return @"Today";
            }
            else if(days == 1)
            {
                return @"Yesterday";
            }
            else if(days <= 10)
            {
                return [NSString stringWithFormat:@"%d days ago", days];
            }
            else // go to months
            {
                int months = (int)[self monthsBetweenDate:castDate andDate:thisDate];
                if(months == 0)
                {
                    return @"This month";
                }
                else if(months == 1)
                {
                    return @"Last month";
                }
                else if(months <= 11)
                {
                    return [NSString stringWithFormat:@"%d months ago", months];
                }
                else // go to years
                {
                    int years = (int)[self yearsBetweenDate:castDate andDate:thisDate];
                    if(years == 0)
                    {
                        return @"This year";
                    }
                    else if(years == 1)
                    {
                        return @"Last years";
                    }
                    else
                    {
                        return [NSString stringWithFormat:@"%d years ago", months];
                    }
                }
            }
        }
    }
}



@end
