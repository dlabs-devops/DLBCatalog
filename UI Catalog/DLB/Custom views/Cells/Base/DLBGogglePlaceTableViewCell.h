//
//  DLBGogglePlaceTableViewCell.h
//  DLB
//
//  Created by Matic Oblak on 7/10/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DLBGooglePlacesResponse;

@interface DLBGogglePlaceTableViewCell : UITableViewCell

@property (nonatomic, strong) DLBGooglePlacesResponse *place;

@end
