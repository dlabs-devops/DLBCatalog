//
//  DLBBackgroundDispatch.m
//  DLB
//
//  Created by Matic Oblak on 7/10/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBBackgroundDispatch.h"

@implementation DLBBackgroundDispatch

+ (void)performBlock:(void (^)(void))block withPriority:(DLBBackgroundDispatchPriority)priority inBackgroundAndReturnToMainThread:(void (^)(void))callback
{
    int dispatchPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT;
    switch (priority) {
        case DLBBackgroundDispatchPriorityDefault:
            dispatchPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT;
            break;
        case DLBBackgroundDispatchPriorityLow:
            dispatchPriority = DISPATCH_QUEUE_PRIORITY_LOW;
            break;
        case DLBBackgroundDispatchPriorityHigh:
            dispatchPriority = DISPATCH_QUEUE_PRIORITY_HIGH;
            break;
    }
    dispatch_async(dispatch_get_global_queue(dispatchPriority, 0ul), ^{
        
        if(block)
        {
            block();
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(callback)
            {
                callback();
            }
        });
    });
}

+ (void)performBlock:(void (^)(void))block inBackgroundAndReturnToMainThread:(void (^)(void))callback
{
    [self performBlock:block withPriority:DLBBackgroundDispatchPriorityDefault inBackgroundAndReturnToMainThread:callback];
}


@end
