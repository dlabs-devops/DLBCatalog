//
//  DLBStarView.m
//  DLB
//
//  Created by Matic Oblak on 2/24/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBStarView.h"

@interface DLBStarView()

@property (nonatomic, strong) UIView *normalPannel;
@property (nonatomic, strong) UIView *highlightedPannel;

@property (nonatomic, strong) NSMutableArray *normalRatings;
@property (nonatomic, strong) NSMutableArray *highlightedRatings;

@end


@implementation DLBStarView

@synthesize rating = _rating;
@synthesize ratingSize = _ratingSize;
@synthesize maximumRating = _maximumRating;

#pragma mark - initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame]))
    {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.ratingContentMode = UIViewContentModeScaleAspectFit;
    [self refreshPositions];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self refreshPositions];
}

#pragma mark - controls

- (NSInteger)ratingSize
{
    if(_ratingSize <= 0)
    {
        return 5;
    }
    return _ratingSize;
}

- (CGFloat)maximumRating
{
    if(_maximumRating <= .0f)
    {
        return 5.0f;
    }
    return _maximumRating;
}

#pragma mark setters

- (void)setRatingSize:(NSInteger)ratingSize
{
    _ratingSize = ratingSize;
    [self refreshPositions];
}

- (void)setRatingImage:(UIImage *)ratingImage
{
    _ratingImage = ratingImage;
    for(UIImageView *view in self.normalRatings)
    {
        view.image = ratingImage;
    }
}

- (void)setRatingHighlightedImage:(UIImage *)ratingHighlightedImage
{
    _ratingHighlightedImage = ratingHighlightedImage;
    for(UIImageView *view in self.highlightedRatings)
    {
        view.image = ratingHighlightedImage;
    }
}

- (void)setRating:(CGFloat)rating
{
    _rating = rating;
    [self refreshPositions];
}

- (void)setMaximumRating:(CGFloat)maximumRating
{
    _maximumRating = maximumRating;
    [self refreshPositions];
}

- (void)setRatingContentMode:(UIViewContentMode)ratingContentMode
{
    _ratingContentMode = ratingContentMode;
    for(UIImageView *view in self.normalRatings)
    {
        view.contentMode = ratingContentMode;
    }
    for(UIImageView *view in self.highlightedRatings)
    {
        view.contentMode = ratingContentMode;
    }
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets
{
    _edgeInsets = edgeInsets;
    [self refreshPositions];
}

#pragma mark - internal

- (UIView *)normalPannel
{
    if(_normalPannel == nil)
    {
        _normalPannel = [[UIView alloc] initWithFrame:[self normalPannelRect]];
        _normalPannel.clipsToBounds = YES;
        [self addSubview:_normalPannel];
    }
    return _normalPannel;
}

- (UIView *)highlightedPannel
{
    if(_highlightedPannel == nil)
    {
        _highlightedPannel = [[UIView alloc] initWithFrame:[self highlightedPannelRect]];
        _highlightedPannel.clipsToBounds = YES;
        [self addSubview:_highlightedPannel];
    }
    return _highlightedPannel;
}

- (NSMutableArray *)normalRatings
{
    if(_normalRatings == nil)
    {
        _normalRatings = [[NSMutableArray alloc] init];
    }
    return _normalRatings;
}

- (NSMutableArray *)highlightedRatings
{
    if(_highlightedRatings == nil)
    {
        _highlightedRatings = [[NSMutableArray alloc] init];
    }
    return _highlightedRatings;
}

#pragma mark positioning

- (void)refreshPositions
{
    [self repositionPannels];
    [self repositionRatings];
}

- (CGFloat)scale
{
    CGFloat toReturn = self.rating;
    if(self.roundingValue > .0f)
    {
        CGFloat min = .0f;
        while (min+self.roundingValue < toReturn) {
            min+=self.roundingValue;
        }
        CGFloat max = min+self.roundingValue;
        
        toReturn = fabsf(((float)(toReturn-min)))<fabsf(((float)(toReturn-max)))?min:max;
    }
    return toReturn/self.maximumRating;
}

- (CGRect)pannelRect
{
    return UIEdgeInsetsInsetRect(CGRectMake(.0f, .0f, self.frame.size.width, self.frame.size.height), self.edgeInsets);
}

- (CGRect)normalPannelRect
{
    CGRect rect = [self pannelRect];
    
    CGFloat offset = rect.size.width*[self scale];
    rect.origin.x += offset;
    rect.size.width -= offset;
    
    return rect;
}

- (CGRect)highlightedPannelRect
{
    CGRect rect = [self pannelRect];
    
    CGFloat offset = rect.size.width*[self scale];
    rect.size.width = offset;
    
    return rect;
}

- (void)repositionPannels
{
    self.normalPannel.frame = [self normalPannelRect];
    self.highlightedPannel.frame = [self highlightedPannelRect];
}

- (void)repositionRatings
{
    CGSize size = [self pannelRect].size;
    size.width /= self.ratingSize;
    
    CGFloat offset = [self normalPannelRect].origin.x-[self pannelRect].origin.x;
    
    for(NSUInteger i=0; i<(NSUInteger)self.ratingSize || i<self.normalRatings.count; i++)
    {
        // normal ratings
        if(self.normalRatings.count > i)
        {
            UIImageView *normalRating = self.normalRatings[i];
            normalRating.frame = CGRectMake(size.width*i-offset, .0f, size.width, size.height);
        }
        else
        {
            UIImageView *normalRating = [[UIImageView alloc] initWithFrame:CGRectMake(size.width*i-offset, .0f, size.width, size.height)];
            normalRating.contentMode = self.ratingContentMode;
            normalRating.image = self.ratingImage;
            [self.normalPannel addSubview:normalRating];
            [self.normalRatings addObject:normalRating];
        }
        // highlighted ratings
        if(self.highlightedRatings.count > i)
        {
            UIImageView *highlightedRating = self.highlightedRatings[i];
            highlightedRating.frame = CGRectMake(size.width*i, .0f, size.width, size.height);
        }
        else
        {
            UIImageView *highlightedRating = [[UIImageView alloc] initWithFrame:CGRectMake(size.width*i, .0f, size.width, size.height)];
            highlightedRating.contentMode = self.ratingContentMode;
            highlightedRating.image = self.ratingHighlightedImage;
            [self.highlightedPannel addSubview:highlightedRating];
            [self.highlightedRatings addObject:highlightedRating];
        }
    }
}

@end
