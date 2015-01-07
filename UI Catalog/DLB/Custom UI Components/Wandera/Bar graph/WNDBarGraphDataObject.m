//
//  WNDBarGraphDataObject.m
//  DLB
//
//  Created by Matic Oblak on 1/7/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "WNDBarGraphDataObject.h"
#import "DLBDateTools.h"

@interface WNDBarGraphDataObject()
@property (nonatomic, strong) NSArray *componentStartDates;
@end

@implementation WNDBarGraphDataObject

- (void)commitData
{
    if([self.startDate compare:self.endDate] != NSOrderedAscending)
    {
        NSLog(@"Can not construct data without appropriate dates set: from %@ to %@", self.startDate, self.endDate);
    }
    
    // iterate through dates
    NSDate *iterator = self.startDate;
    NSMutableArray *componentDates = [[NSMutableArray alloc] init];
    while ([iterator compare:self.endDate] != NSOrderedDescending) {
        [componentDates addObject:iterator];
        if(self.componentPeriod == barGraphComponentPeriodHour)
        {
            iterator = [DLBDateTools date:iterator byAddingHours:1];
        }
        else
        {
            iterator = [DLBDateTools date:iterator byAddingDays:1];
        }
    }
    self.componentStartDates = [componentDates copy];
    self.componentCount = self.componentStartDates.count-1;
}

- (CGFloat)scale
{
    if(_scale <= .0f)
    {
        CGFloat max = .0f;
        for(NSNumber *value in self.componentValues)
        {
            CGFloat floatingValue = value.floatValue;
            if(max < floatingValue)
            {
                max = floatingValue;
            }
        }
        if(max <= .0f)
        {
            max = 1.0f;
        }
        return max;
    }
    else
    {
        return _scale;
    }
}

- (NSNumber *)valueAtIndex:(NSInteger)index
{
    if(index < 0 || index >= self.componentValues.count)
    {
        return @(.0f);
    }
    return self.componentValues[(NSUInteger)index];
}

@end
