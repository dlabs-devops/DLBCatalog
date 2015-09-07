//
//  DLBDictionary.m
//  Outcast
//
//  Created by Crt Gregoric on 7. 09. 15.
//  Copyright (c) 2015 D·Labs. All rights reserved.
//

#import "DLBDictionary.h"

@interface DLBDictionary()

@property (nonatomic, strong) NSMutableDictionary *internalDictionary;

@end

@implementation DLBDictionary

#pragma mark - Setters and getters

- (NSMutableDictionary *)internalDictionary
{
    if (_internalDictionary == nil)
    {
        _internalDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return _internalDictionary;
}

- (NSDictionary *)dictionary
{
    return [self.internalDictionary copy];
}

#pragma mark - Public methods

- (void)setObject:(id)object forKey:(id<NSCopying>)key
{
    if (key)
    {
        if (object)
        {
            self.internalDictionary[key] = object;
        }
        else
        {
            [self.internalDictionary removeObjectForKey:key];
        }
    }
}

- (id)objectForKey:(id<NSCopying>)key
{
    if (key)
    {
        return [self.internalDictionary objectForKey:key];
    }
    
    return nil;
}

#pragma mark - Subscript methods

- (void)setObject:(id)object forKeyedSubscript:(id <NSCopying>)key
{
    [self setObject:object forKey:key];
}

- (id)objectForKeyedSubscript:(id <NSCopying>)key
{
    return [self objectForKey:key];
}

@end
