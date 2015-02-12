//
//  WNDGraphGrid.h
//  DLB
//
//  Created by Matic Oblak on 1/8/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

@import UIKit;

@class WNDGraphGrid;
@class WNDGraphGridParameters;

@interface WNDGraphGrid : UIView

- (void)setParameters:(WNDGraphGridParameters *)parameters animated:(BOOL)animated;

@end


@interface WNDGraphGridParameters : NSObject

//line properties
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic) CGFloat lineWidth;
//grid properties
@property (nonatomic) CGPoint lineStartPoint;
@property (nonatomic) CGSize lineSegmentSize;
//sub grid properties
@property (nonatomic) NSInteger subgridVerticalPixelSkipCount;
@property (nonatomic) NSInteger subgridHorizontalPixelSkipCount;
@property (nonatomic, strong) UIColor *subGridLineColor;
@property (nonatomic) CGFloat subGridLineWidth;

+ (WNDGraphGridParameters *)interpolatedParametersWithSource:(WNDGraphGridParameters *)source target:(WNDGraphGridParameters *)target scale:(CGFloat)scale;

@end


