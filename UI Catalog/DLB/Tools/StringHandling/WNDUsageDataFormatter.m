//
//  WNDUsageDataFormatter.m
//  Wandera
//
//  Created by Urban on 17/12/14.
//  Copyright (c) 2014 Wandera Ltd. All rights reserved.
//

#import "WNDUsageDataFormatter.h"

static const int kMB = 1;
static const int kGB = 2;

@implementation WNDUsageDataFormatter


+ (NSNumberFormatter *)megaFormatter
{
    NSNumberFormatter *formatter = nil;
    if(formatter == nil)
    {
        formatter = [[NSNumberFormatter alloc] init];
        formatter.maximumFractionDigits = 1;
        //formatter.minimumFractionDigits = 1;
        formatter.minimumIntegerDigits = 1;
        formatter.minimumSignificantDigits = 1;
    }
    return formatter;
}

+ (NSNumberFormatter *)gigaFormatter
{
    NSNumberFormatter *formatter = nil;
    if(formatter == nil)
    {
        formatter = [[NSNumberFormatter alloc] init];
        formatter.alwaysShowsDecimalSeparator = YES;
        formatter.minimumFractionDigits = 1;
        formatter.maximumFractionDigits = 1;
    }
    return formatter;
}

+ (NSNumberFormatter *)currencyFormatter
{
    NSNumberFormatter *formatter = nil;
    if(formatter == nil)
    {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        formatter.maximumFractionDigits = 2;
        formatter.minimumIntegerDigits = 1;
    }
    return formatter;
}

+ (NSString *)numberStringForUsageAmount:(NSNumber *)usageAmount
{
    float ceil = 0.0f;
    float giga = 1024.0f;
    
    int unit = [WNDUsageDataFormatter maxUnitCapForUsageAmount:usageAmount];
    NSString *numberString = nil;
    
    if (usageAmount.floatValue == 0.0f)
    {
        if (unit == kGB)
        {
             numberString = [[WNDUsageDataFormatter gigaFormatter] stringFromNumber:usageAmount];
        }
        else if (unit == kMB)
        {
            numberString = [[WNDUsageDataFormatter megaFormatter] stringFromNumber:usageAmount];
        }
        else
        {
            return nil;
        }
        
        return numberString;
    }
    
    if (unit == kGB)
    {
        ceil = usageAmount.floatValue / giga;
        numberString = [[WNDUsageDataFormatter gigaFormatter] stringFromNumber:@(ceil)];
    }
    else if (unit == kMB)
    {
        ceil = usageAmount.floatValue;
        numberString = [[WNDUsageDataFormatter megaFormatter] stringFromNumber:@(ceil)];
    }
    else
    {
        return nil;
    }
    
    return numberString;
}

+ (NSString *)unitStringForUsageAmount:(NSNumber *)usageAmount
{
    if ([WNDUsageDataFormatter maxUnitCapForUsageAmount:usageAmount] == kGB)
    {
        return @"GB";
    }
    else if ([WNDUsageDataFormatter maxUnitCapForUsageAmount:usageAmount] == kMB)
    {
        return @"MB";
    }
    else
    {
        return nil;
    }
}

+ (int)maxUnitCapForUsageAmount:(NSNumber *)usageAmount
{
    CGFloat giga = 2048.0f;
    
    if (usageAmount.floatValue > giga)
    {
        return kGB;
    }
    else
    {
        return kMB;
    }
}

+ (NSString *)stringForUnit:(int)unit
{
    if (unit == kGB)
    {
        return @"GB";
    }
    else if (unit == kMB)
    {
        return @"MB";
    }
    else
    {
        return nil;
    }
}

@end
