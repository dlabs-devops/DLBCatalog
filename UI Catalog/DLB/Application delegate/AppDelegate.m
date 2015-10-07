//
//  AppDelegate.m
//  DLB
//
//  Created by Matic Oblak on 12/4/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "AppDelegate.h"
#import "DLBDateTools.h"

@interface AppDelegate ()

@end

#define XCTAssert(A, B) assert(A)

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    srand((unsigned int)[[NSDate date] timeIntervalSince1970]);
//    [self testDateTools];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)testDateTools
{
    NSDate *startDate = [DLBDateTools beginningOfTheMonth:[NSDate date]];
    
    NSTimeInterval interval = .0;
    NSTimeInterval dInterval = 12.1;
    
    // test near future
    while (interval < 60.0*60.0*100.0) {
        NSDate *endDate = [startDate dateByAddingTimeInterval:interval];
        
        NSString *text = [DLBDateTools durationStringFrom:startDate to:endDate];
        [self checkString:text forInteval:interval];
        
        interval += dInterval;
    }
    // test medium future
    dInterval = 60.0*60.0*1.5;
    while (interval < 60.0*60.0*24.0*100.0) {
        NSDate *endDate = [startDate dateByAddingTimeInterval:interval];
        
        NSString *text = [DLBDateTools durationStringFrom:startDate to:endDate];
        [self checkString:text forInteval:interval];
        
        interval += dInterval;
    }
    // test far future
    dInterval = 60.0*60.0*24.0*1.3;
    while (interval < 60.0*60.0*24.0*356.0*10.0) {
        NSDate *endDate = [startDate dateByAddingTimeInterval:interval];
        
        NSString *text = [DLBDateTools durationStringFrom:startDate to:endDate];
        [self checkString:text forInteval:interval];
        
        interval += dInterval;
    }
}

- (void)checkString:(NSString *)text forInteval:(NSTimeInterval)interval
{
    if([text isEqualToString:@"Just now"])
    {
        XCTAssert(interval<10.0*60.0, @"[durationString] Just now");
    }
    else if([text hasSuffix:@"minutes ago"])
    {
        XCTAssert(interval<60.0*60.0, @"[durationString] minutes ago");
    }
    else if([text hasSuffix:@"Less then an hour ago"])
    {
        XCTAssert(interval<60.0*60.0, @"[durationString] Less then an hour ago");
    }
    else if([text hasPrefix:@"About an hour ago"])
    {
        XCTAssert(interval >= 60.0*60.0 && interval <= 60.0*60.0*2.0, @"[durationString] About an hour ago");
    }
    else if([text hasSuffix:@"hours ago"])
    {
        XCTAssert(interval >= 60.0*60.0 &&
                  interval <= 60.0*60.0*25.0,
                  @"[durationString] hours ago");
    }
    else if([text hasSuffix:@"Today"])
    {
        XCTAssert(interval <= 60.0*60.0*25.0,
                  @"[durationString] Today");
    }
    else if([text hasSuffix:@"Yesterday"])
    {
        XCTAssert(interval <= 60.0*60.0*49.0,
                  @"[durationString] Yesterday");
    }
    else if([text hasSuffix:@"days ago"])
    {
        XCTAssert(interval >= 60.0*60.0*24.0 &&
                  interval <= 60.0*60.0*24.0*32.0,
                  @"[durationString] days ago");
    }
    else if([text hasSuffix:@"This month"])
    {
        XCTAssert(interval <= 60.0*60.0*24.0*32.0,
                  @"[durationString] This month");
    }
    else if([text hasSuffix:@"Last month"])
    {
        XCTAssert(interval <= 60.0*60.0*24.0*63.0,
                  @"[durationString] Last month");
    }
    else if([text hasSuffix:@"months ago"])
    {
        XCTAssert(interval >= 60.0*60.0*24.0*28.0 &&
                  interval <= 60.0*60.0*24.0*366.0,
                  @"[durationString] months ago");
    }
    else if([text hasSuffix:@"This year"])
    {
        XCTAssert(interval <= 60.0*60.0*24.0*366.0,
                  @"[durationString] This year");
    }
    else if([text hasSuffix:@"Last year"])
    {
        XCTAssert(interval <= 60.0*60.0*24.0*(366.0+365.0),
                  @"[durationString] Last year");
    }
    else if([text hasSuffix:@"years ago"])
    {
        XCTAssert(interval >= 60.0*60.0*24.0*365.0,
                  @"[durationString] years ago");
    }
}


@end
