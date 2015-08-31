//
//  DLBPostponedOperation.m
//
//  Created by Matic Oblak on 1/13/15.
//  Copyright (c) 2015 Wandera Ltd. All rights reserved.
//

#import "DLBPostponedOperation.h"

@interface DLBPostponedOperation()

@property (nonatomic, strong) NSInvocation *invocation;
@property (nonatomic) NSInteger performRetainCount;
@property (nonatomic, strong) id targetRetainmentObject;

@end


@implementation DLBPostponedOperation

- (instancetype)initWithTarget:(id)target selector:(SEL)selector
{
    if((self = [super init]))
    {
        self.performRetainCount = 0;
        self.minimumElapsedTime = .5;
        self.invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:selector]];
        self.invocation.target = target;
        self.invocation.selector = selector;
    }
    return self;
}

- (void)perform
{
    self.performRetainCount++;
    self.targetRetainmentObject = self.invocation.target;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(releaseAction) withObject:nil afterDelay:self.minimumElapsedTime];
    });
}

- (void)releaseAction
{
    self.performRetainCount--;
    if(self.performRetainCount <= 0)
    {
        self.performRetainCount = 0;
        [self.invocation invoke];
        self.targetRetainmentObject = nil;
    }
}

@end
