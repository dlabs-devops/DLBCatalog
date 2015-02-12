//
//  DLBInternalError.m
//  DLB
//
//  Created by Matic Oblak on 2/9/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBInternalError.h"

static NSString *__internalDomainKey = @"internal";
static NSString *__internalMessageKey = @"internal_message";
static NSString *__internalTypeKey = @"internal_type";
static NSString *__internalDeveloperMessageKey = @"internal_message_develop";

@implementation DLBInternalError

#pragma mark - initialization

- (instancetype)initAsWarning:(NSString *)message
{
    if(message == nil)
    {
        message = @"Unknown warning";
    }
    if((self = [self initWithDomain:__internalDomainKey code:201 userInfo:@{__internalMessageKey:message, __internalTypeKey:@(DLBInternalErrorTypeWarning)}]))
    {
        self.errorType = DLBInternalErrorTypeWarning;
    }
    return self;
}

- (instancetype)initAsError:(NSString *)message
{
    if(message == nil)
    {
        message = @"Unknown error";
    }
    if((self = [self initWithDomain:__internalDomainKey code:401 userInfo:@{__internalMessageKey:message, __internalTypeKey:@(DLBInternalErrorTypeError)}]))
    {
        self.errorType = DLBInternalErrorTypeError;
    }
    return self;
}

- (instancetype)initAsWarning:(NSString *)message additionalInfo:(NSString *)info
{
    if(info == nil)
    {
        return [self initAsWarning:message];
    }
    NSDictionary *userInfo = @{__internalMessageKey:message,
                               __internalTypeKey:@(DLBInternalErrorTypeWarning),
                               __internalDeveloperMessageKey:info};
    if((self = [self initWithDomain:__internalDomainKey code:401 userInfo:userInfo]))
    {
        self.errorType = DLBInternalErrorTypeWarning;
    }
    return self;
}

- (instancetype)initAsError:(NSString *)message additionalInfo:(NSString *)info
{
    if(info == nil)
    {
        return [self initAsError:message];
    }
    NSDictionary *userInfo = @{__internalMessageKey:message,
                               __internalTypeKey:@(DLBInternalErrorTypeError),
                               __internalDeveloperMessageKey:info};
    if((self = [self initWithDomain:__internalDomainKey code:401 userInfo:userInfo]))
    {
        self.errorType = DLBInternalErrorTypeError;
    }
    return self;
}


#pragma mark - properties

- (NSString *)internalMessage
{
    return self.userInfo[__internalMessageKey];
}

- (NSString *)developerComment
{
    return self.userInfo[__internalDeveloperMessageKey];
}

- (NSString *)internalDescription
{
    NSString *toReturn = @"";
    
    switch (self.errorType) {
        case DLBInternalErrorTypeWarning:
            toReturn = @"[WARNING]";
            break;
        case DLBInternalErrorTypeError:
            toReturn = @"[ERROR]";
            break;
        default:
            break;
    }
    if(self.internalMessage.length > 0)
    {
        toReturn = [toReturn stringByAppendingFormat:@" %@", self.internalMessage];
    }
    if(self.developerComment.length > 0)
    {
        toReturn = [toReturn stringByAppendingFormat:@" (%@)", self.developerComment];
    }
    
    return toReturn;
}

@end
