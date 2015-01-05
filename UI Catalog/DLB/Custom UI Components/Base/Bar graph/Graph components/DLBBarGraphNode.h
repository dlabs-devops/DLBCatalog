//
//  DLBBarGraphNode.h
//  DLB
//
//  Created by Matic Oblak on 12/18/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

@import UIKit;

@class DLBBarGraphNode;

@protocol DLBBarGraphNodeDrawing <NSObject>
@optional

- (void)DLBBarGraphNode:(DLBBarGraphNode *)node drawIncontext:(CGContextRef)context withRect:(CGRect)rect;

@end

@interface DLBBarGraphNode : NSObject

@property (nonatomic) NSInteger index;
@property (nonatomic) CGFloat scale;

@property (nonatomic, strong) UIColor *foregroundColor;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic) CGRect frame;

@property (nonatomic, weak) id<DLBBarGraphNodeDrawing> drawDelegate;

- (void)drawInContext:(CGContextRef)context;
- (void)drawDefaultInContext:(CGContextRef)context;

@end
