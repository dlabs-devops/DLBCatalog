//
//  DLBBarGraphView.h
//  DLB
//
//  Created by Matic Oblak on 12/18/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

@import UIKit;

@class DLBBarGraphView;

@protocol DLBBarGraphDataSource <NSObject>

- (NSInteger)DLBBarGraphViewNumberOfComponents:(DLBBarGraphView *)sender;

- (NSNumber *)DLBBarGraphView:(DLBBarGraphView *)sender valueAtIndex:(NSInteger)index;

@end

@protocol DLBBarGraphDelegate <NSObject>

- (void)DLBBarGraphDelegateEndedAnimation:(DLBBarGraphView *)sender;

@end

@protocol DLBBarGraphNodeDrawing;

@interface DLBBarGraphView : UIView
//
// Width of a single bar
//
@property (nonatomic) CGFloat barWidth;
//
// Top most value on the graph
//
@property (nonatomic) CGFloat graphScale;
//
// Default node foreground color
//
@property (nonatomic, strong) UIColor *nodeColor;
//
// Default node background color
//
@property (nonatomic, strong) UIColor *nodeBackgroundColor;

@property (nonatomic, weak) id<DLBBarGraphDataSource> dataSource;
@property (nonatomic, weak) id<DLBBarGraphDelegate> delegate;
@property (nonatomic, weak) id<DLBBarGraphNodeDrawing> nodeDrawDelegate;

- (void)reloadGraphAnimated:(BOOL)animated;

@end
