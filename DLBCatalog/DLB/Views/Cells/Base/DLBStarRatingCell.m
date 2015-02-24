//
//  DLBNumericCounterCell.m
//  DLB
//
//  Created by Matic Oblak on 1/5/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBStarRatingCell.h"
#import "DLBStarView.h"

@interface DLBStarRatingCell ()

@property (weak, nonatomic) IBOutlet DLBStarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@property (nonatomic) BOOL animate;

@end

@implementation DLBStarRatingCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self layoutIfNeeded];
    
    self.starView.ratingImage = [UIImage imageNamed:@"star-empty"];
    self.starView.ratingHighlightedImage = [UIImage imageNamed:@"star-full"];
    [self.starView layoutIfNeeded];
    self.starView.clipsToBounds = YES;
    self.starView.roundingValue = .5f;
    
    self.animate = YES;
    [self performSelector:@selector(randomValue) withObject:nil afterDelay:1.0];
}

- (void)randomValue
{
    [UIView animateWithDuration:1.2 animations:^{
        self.starView.rating = ((CGFloat)(rand()%200))/200.0f * self.starView.maximumRating;
    }];
    
    self.ratingLabel.text = [NSString stringWithFormat:@"%.1f / %.1f", self.starView.rating, self.starView.maximumRating];
    
    if(self.animate)
    {
        [self performSelector:@selector(randomValue) withObject:nil afterDelay:3.0];
    }
}

@end
