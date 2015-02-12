//
//  DLBInternalError.h
//  DLB
//
//  Created by Matic Oblak on 2/9/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

@import UIKit;

typedef enum : NSUInteger {
    DLBInternalErrorTypeWarning,
    DLBInternalErrorTypeError
} DLBInternalErrorType;

@interface DLBInternalError : NSError

@property (nonatomic) DLBInternalErrorType errorType;
@property (nonatomic, readonly) NSString *internalMessage;
@property (nonatomic, readonly) NSString *developerComment;
@property (nonatomic, readonly) NSString *internalDescription;

- (instancetype)initAsWarning:(NSString *)message;
- (instancetype)initAsError:(NSString *)message;

- (instancetype)initAsWarning:(NSString *)message additionalInfo:(NSString *)info;
- (instancetype)initAsError:(NSString *)message additionalInfo:(NSString *)info;


@end
