//
//  DLBFloatingRange.h
//  DLB
//
//  Created by Matic Oblak on 12/16/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

@import UIKit;

@interface DLBFloatingRange : NSObject

@property (nonatomic) CGFloat location;
@property (nonatomic) CGFloat length;

+ (DLBFloatingRange *)withLocation:(CGFloat)location length:(CGFloat)length;

@end
