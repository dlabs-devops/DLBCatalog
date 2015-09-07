//
//  DLBDictionary.h
//  Outcast
//
//  Created by Crt Gregoric on 7. 09. 15.
//  Copyright (c) 2015 D·Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLBDictionary : NSObject

@property (nonatomic, readonly) NSDictionary *dictionary;

- (void)setObject:(id)object forKey:(id<NSCopying>)key;
- (id)objectForKey:(id<NSCopying>)key;

- (id)objectForKeyedSubscript:(id <NSCopying>)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

@end
