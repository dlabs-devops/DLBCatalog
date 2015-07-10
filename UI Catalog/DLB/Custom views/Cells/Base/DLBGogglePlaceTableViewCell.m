//
//  DLBGogglePlaceTableViewCell.m
//  DLB
//
//  Created by Matic Oblak on 7/10/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBGogglePlaceTableViewCell.h"
#import "DLBGooglePlacesHandler.h"

@interface DLBGogglePlaceTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeFirstImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;



@end

@implementation DLBGogglePlaceTableViewCell

- (void)setPlace:(DLBGooglePlacesResponse *)place
{
    _place = place;
    self.titleTextLabel.text = place.address;
    self.addressLabel.text = place.name;
    [place fetchFirstImage:^(UIImage *image) {
        self.placeFirstImageView.image = image;
    }];
}

@end
