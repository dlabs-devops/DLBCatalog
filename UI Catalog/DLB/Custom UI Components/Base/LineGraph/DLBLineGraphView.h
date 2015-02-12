//
//  DLBLineGraphView.h
//  DLB
//
//  Created by Urban Puhar on 08/01/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

@import UIKit;

@class DLBLineGraphView;
@class DLBPathRenderer;

@protocol DLBLineGraphViewDelgate

@end

@protocol DLBLineGraphViewDataSource

- (NSInteger)numberOfValuesInGraphView:(DLBLineGraphView *)graphView;
- (NSInteger)numberOfHorizontalSectionsInGraphView:(DLBLineGraphView *)graphView;
- (NSInteger)numberOfVerticalSectionsInGraphView:(DLBLineGraphView *)graphView;
- (CGFloat)lineGraph:(DLBLineGraphView  *)graphView valueAtIndex:(NSInteger)index;
- (NSString *)lineGraph:(DLBLineGraphView  *)graphView horizontalLabelAtIndex:(NSInteger)index;
- (NSString *)lineGraph:(DLBLineGraphView  *)graphView verticalLabelAtIndex:(NSInteger)index;

@end

@interface DLBLineGraphView : UIView

@property (nonatomic, weak) id<DLBLineGraphViewDataSource> dataSource;
@property (nonatomic, weak) id<DLBLineGraphViewDelgate> delegate;
@property (nonatomic, strong) NSDictionary *horizontalLabelAttributes;
@property (nonatomic, strong) NSDictionary *verticalLabelAttributes;
@property (nonatomic) CGFloat minValue;
@property (nonatomic) CGFloat maxValue;
@property (nonatomic) CGFloat verticalScalaWidth;
@property (nonatomic) CGFloat horizontalScalaHeight;
@property (nonatomic, retain) NSArray *gradientColors;
@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) BOOL horizonatalLabelFloating;
@property (nonatomic) BOOL verticalLabelFloating;

// reloads data (calls data source delegate)
- (void)reloadDataAnimated:(BOOL)animated;

// redraws chart with. It does not call delegates numberOfSectionsInGraphView
- (void)redrawGraphAnimated:(BOOL)animated;


@end
