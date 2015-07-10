//
//  DLBBackgroundDispatch.h
//  DLB
//
//  Created by Matic Oblak on 7/10/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    DLBBackgroundDispatchPriorityDefault,
    DLBBackgroundDispatchPriorityLow,
    DLBBackgroundDispatchPriorityHigh
} DLBBackgroundDispatchPriority;


@interface DLBBackgroundDispatch : NSObject

+ (void)performBlock:(void (^)(void))block withPriority:(DLBBackgroundDispatchPriority)priority inBackgroundAndReturnToMainThread:(void (^)(void))callback;
+ (void)performBlock:(void (^)(void))block inBackgroundAndReturnToMainThread:(void (^)(void))callback;

@end
