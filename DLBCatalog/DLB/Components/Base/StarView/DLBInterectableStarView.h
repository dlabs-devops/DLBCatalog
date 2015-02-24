//
//  DLBInterectableStarView.h
//  DLB
//
//  Created by Matic Oblak on 2/24/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBStarView.h"

@class DLBInterectableStarView;

@protocol DLBInterectableStarViewDelegate <NSObject>

- (void)interectableStarView:(DLBInterectableStarView *)sender selectedRating:(CGFloat)rating;

@end

@interface DLBInterectableStarView : DLBStarView
//
// Selection granularity rounds the selected rating
// For instance set to .5 so user can select values such as .0, .5, 1.0, 1.5...
//
@property (nonatomic) CGFloat selectionGranularity;

@property (nonatomic, weak) id<DLBInterectableStarViewDelegate> delegate;

@end
