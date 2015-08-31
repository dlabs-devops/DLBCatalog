//
//  DLBPostponedOperation.h
//
//  Created by Matic Oblak on 1/13/15.
//  Copyright (c) 2015 Wandera Ltd. All rights reserved.
//

@import Foundation;

//
// A class designed to call a specific method only if
// a certain time has elapsed between the two calls to it.
//
// Initialize it with a target and selector then call perform method on it
//

@interface DLBPostponedOperation : NSObject

//
// Minimum time that must pass before the next perform call for the method to be performed
//
@property (nonatomic) NSTimeInterval minimumElapsedTime;

- (instancetype)initWithTarget:(id)target selector:(SEL)selector;

- (void)perform;

@end
