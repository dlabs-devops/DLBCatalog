//
//  DLBGooglePlacesHandler.h
//  DLB
//
//  Created by Matic Oblak on 7/10/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

@import UIKit;

@interface DLBGooglePlacesHandler : NSObject

@property (nonatomic, readonly) NSArray *responses;

@property (nonatomic, strong) NSString *apiKey;

@property (nonatomic, strong) NSNumber *maximumRadius;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

@property (nonatomic, strong) NSString *searchString;

@property (nonatomic) CGSize preferedImageSize;


- (void)fetchPlaces:(void (^)(NSInteger placesFound, NSError *error))callback;

@end


@interface DLBGooglePlacesResponse : NSObject

@property (nonatomic, weak) DLBGooglePlacesHandler *owner;
@property (nonatomic, strong) NSString *apiKey;

@property (nonatomic, readonly) NSString *address;
@property (nonatomic, readonly) NSNumber *latitude;
@property (nonatomic, readonly) NSNumber *longitude;
@property (nonatomic, readonly) NSURL *iconURL;
@property (nonatomic, readonly) NSString *placeID;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSArray *photoIDs;
@property (nonatomic, readonly) NSNumber *rating;


- (instancetype)initWithDescriptor:(NSDictionary *)descriptor;

- (void)fetchFirstImage:(void (^)(UIImage *image))callback;

@end