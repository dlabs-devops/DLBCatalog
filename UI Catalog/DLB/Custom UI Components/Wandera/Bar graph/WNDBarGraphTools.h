//
//  WNDBarGraphTools.h
//  DLB
//
//  Created by Matic Oblak on 1/7/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

@import Foundation;

//
// Transition style enumeration
//
typedef enum : NSUInteger {
    barGraphTransitionStyleRefresh, // will only resize elements
    barGraphTransitionStyleFromLeft, // will bring new view from left
    barGraphTransitionStyleFromRight, // will bring new view from right
    barGraphTransitionStyleCloseAndOpen // will close all to zero and open new elements
} eBarGraphTransitionStyle;
//
// Component period display enumeration
//
typedef enum : NSUInteger {
    barGraphComponentPeriodHour, // each bar represents an hour
    barGraphComponentPeriodDay // each bar represents a day
} eBarGraphComponentPeriod;


@interface WNDBarGraphTools : NSObject

@end
