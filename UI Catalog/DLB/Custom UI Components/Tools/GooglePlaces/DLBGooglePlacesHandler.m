//
//  DLBGooglePlacesHandler.m
//  DLB
//
//  Created by Matic Oblak on 7/10/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBGooglePlacesHandler.h"
#import "DLBBackgroundDispatch.h"



@interface DLBGooglePlacesHandler ()

@property (nonatomic, strong) NSArray *responses;
@property (nonatomic, strong) NSError *error;

@end

@implementation DLBGooglePlacesHandler

- (NSString *)parameterString
{
    NSMutableDictionary *components = [[NSMutableDictionary alloc] init];
    if(self.searchString)
    {
        components[@"input"] = self.searchString;
    }
    if(self.apiKey)
    {
        components[@"key"] = self.apiKey;
    }
    if(self.latitude && self.longitude)
    {
        components[@"location"] = [NSString stringWithFormat:@"%f,%f", self.latitude.floatValue, self.longitude.floatValue];
    }
    if(self.maximumRadius && self.maximumRadius.floatValue > .0f)
    {
        components[@"radius"] = [NSString stringWithFormat:@"%i", (int)self.maximumRadius];
    }
    NSString *toReturn = nil;
    for(NSString *key in [components allKeys])
    {
        if(toReturn == nil)
        {
            toReturn = [NSString stringWithFormat:@"?%@=%@", key, components[key]];
        }
        else
        {
            toReturn = [toReturn stringByAppendingFormat:@"&%@=%@", key, components[key]];
        }
    }
    return toReturn;
}

- (NSURL *)requestURL
{
    NSString *basePath = @"https://maps.googleapis.com/maps/api/place/textsearch/json";
    NSString *parametersString = [self parameterString];
    
    return [NSURL URLWithString:parametersString?[basePath stringByAppendingString:parametersString]:basePath];
}

- (void)fetchPlaces:(void (^)(NSInteger placesFound, NSError *error))callback
{
    [DLBBackgroundDispatch performBlock:^{
        NSData *data = [NSData dataWithContentsOfURL:[self requestURL]];
        if(data)
        {
            NSError *error;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSArray *items = response[@"results"];
            self.error = error;
            
            NSMutableArray *responses = [[NSMutableArray alloc] init];
            for(NSDictionary *item in items)
            {
                DLBGooglePlacesResponse *place = [[DLBGooglePlacesResponse alloc] initWithDescriptor:item];
                place.owner = self;
                place.apiKey = self.apiKey;
                [responses addObject:place];
            }
            self.responses = responses.count>0?responses:nil;
        }
        else
        {
            self.responses = nil;
        }
    } inBackgroundAndReturnToMainThread:^{
        if(callback)
        {
            callback(self.responses.count, self.error);
        }
    }];
}

@end



@interface DLBGooglePlacesResponse ()

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSURL *iconURL;
@property (nonatomic, strong) NSString *placeID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *photoIDs;
@property (nonatomic, strong) NSNumber *rating;

@property (nonatomic, strong) UIImage *firstImage;

@end


@implementation DLBGooglePlacesResponse

- (instancetype)initWithDescriptor:(NSDictionary *)descriptor
{
    if((self = [self init]))
    {
        self.address = descriptor[@"formatted_address"];
        self.latitude = descriptor[@"geometry"][@"location"][@"lat"];
        self.longitude = descriptor[@"geometry"][@"location"][@"lng"];
        self.iconURL = [NSURL URLWithString:descriptor[@"icon"]];
        self.placeID = descriptor[@"place_id"];
        self.name = descriptor[@"name"];
        self.rating = descriptor[@"rating"];
        NSMutableArray *imageIDs = [[NSMutableArray alloc] init];
        for(NSDictionary *photoDescriptor in descriptor[@"photos"])
        {
            NSString *ref = photoDescriptor[@"photo_reference"];
            if(ref)
            {
                [imageIDs addObject:ref];
            }
        }
        if(imageIDs.count > 0)
        {
            self.photoIDs = [imageIDs copy];
        }
    }
    return self;
}

- (NSString *)apiKey
{
    if(_apiKey)
    {
        return _apiKey;
    }
    else if(self.owner.apiKey)
    {
        return self.owner.apiKey;
    }
    else
    {
        return nil;
    }
}

- (CGSize)imageSize
{
    CGSize size = self.owner.preferedImageSize;
    if(size.width >= 1.0f && size.height >= 1.0f && size.width < 1600.0f && size.height < 1600.0f)
    {
        return size;
    }
    else
    {
        return CGSizeMake(1600.0f, 1600.0f);
    }
}

- (NSURL *)imageURLForID:(NSString *)imageID
{
    NSString *basePath = @"https://maps.googleapis.com/maps/api/place/photo";
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if(self.apiKey)
    {
        parameters[@"key"] = self.apiKey;
    }
    parameters[@"maxwidth"] = @([self imageSize].width);
    parameters[@"maxheight"] = @([self imageSize].height);
    if(imageID)
    {
        parameters[@"photoreference"] = imageID;
    }
    NSString *parametersString = nil;
    for(NSString *key in [parameters allKeys])
    {
        if(parametersString == nil)
        {
            parametersString = [NSString stringWithFormat:@"?%@=%@", key, parameters[key]];
        }
        else
        {
            parametersString = [parametersString stringByAppendingFormat:@"&%@=%@", key, parameters[key]];
        }
    }
    
    return [NSURL URLWithString:parametersString?[basePath stringByAppendingString:parametersString]:basePath];
}

- (void)loadImageWithID:(NSString *)imageID callback:(void (^)(UIImage *image))callback
{
    __block UIImage *image = nil;
    [DLBBackgroundDispatch performBlock:^{
        NSData *data = [NSData dataWithContentsOfURL:[self imageURLForID:imageID]];
        image = [UIImage imageWithData:data];
    } inBackgroundAndReturnToMainThread:^{
        if(callback)
        {
            callback(image);
        }
    }];
}

- (void)fetchFirstImage:(void (^)(UIImage *image))callback
{
    if(self.firstImage)
    {
        if(callback)
        {
            callback(self.firstImage);
        }
    }
    else if(self.photoIDs.count > 0)
    {
        [self loadImageWithID:self.photoIDs.firstObject callback:^(UIImage *image) {
            self.firstImage = image;
            if(callback)
            {
                callback(self.firstImage);
            }
        }];
    }
    else
    {
        callback(nil);
    }
}

@end
