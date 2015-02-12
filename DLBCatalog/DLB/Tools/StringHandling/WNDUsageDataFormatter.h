//
//  WNDUsageDataFormatter.h
//  Wandera
//
//  Created by Urban on 17/12/14.
//  Copyright (c) 2014 Wandera Ltd. All rights reserved.
//

@import Foundation;

@interface WNDUsageDataFormatter : NSObject


+ (NSString *)numberStringForUsageAmount:(NSNumber *)usageAmount;
+ (NSString *)unitStringForUsageAmount:(NSNumber *)usageAmount;

+ (NSNumberFormatter *)megaFormatter;
+ (NSNumberFormatter *)gigaFormatter;
+ (NSNumberFormatter *)currencyFormatter;

@end
