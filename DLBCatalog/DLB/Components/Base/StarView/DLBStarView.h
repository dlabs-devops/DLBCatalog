//
//  DLBStarView.h
//  DLB
//
//  Created by Matic Oblak on 2/24/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

@import UIKit;
IB_DESIGNABLE
@interface DLBStarView : UIView
//
// Image displayed when rating not filled
//
@property (nonatomic, strong) IBInspectable UIImage *ratingImage;
//
// Image displayed when rating filled
//
@property (nonatomic, strong) IBInspectable UIImage *ratingHighlightedImage;
//
// Number of images displayed in the view
// Defaults to 5
//
@property (nonatomic) IBInspectable NSInteger ratingSize;
//
// Current rating
//
@property (nonatomic) IBInspectable CGFloat rating;
//
// Maximum rating
// Defaults to 5.0f
//
@property (nonatomic) IBInspectable CGFloat maximumRating;
//
// Image view content mode for rating
// Defaults to UIViewContentModeScaleAspectFit
//
@property (nonatomic) UIViewContentMode ratingContentMode;
//
// Whole view edge insets
//
@property (nonatomic) UIEdgeInsets edgeInsets;
//
// Rounding value
// Will round the result to a specific value
//
@property (nonatomic) IBInspectable CGFloat roundingValue;


@end
