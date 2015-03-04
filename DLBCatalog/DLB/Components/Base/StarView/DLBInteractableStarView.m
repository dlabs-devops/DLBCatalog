//
//  DLBInteractableStarView.m
//  DLB
//
//  Created by Matic Oblak on 2/24/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBInteractableStarView.h"

@implementation DLBInteractableStarView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)]];
}

- (void)onPan:(UIPanGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self];
    CGFloat scale = (point.x-self.edgeInsets.left)/(self.frame.size.width-(self.edgeInsets.left+self.edgeInsets.right));
    if(scale < .0f)
    {
        scale = .0f;
    }
    else if(scale > 1.0f)
    {
        scale = 1.0f;
    }
    
    self.rating = [self roundRating:scale*self.maximumRating];
    [self.delegate interectableStarView:self selectedRating:self.rating];
}

- (CGFloat)roundRating:(CGFloat)rating
{
    CGFloat toReturn = rating;
    if(self.selectionGranularity > .0f)
    {
        CGFloat min = .0f;
        while (min+self.selectionGranularity < toReturn) {
            min+=self.selectionGranularity;
        }
        CGFloat max = min+self.selectionGranularity;
        
        toReturn = fabsf(((float)(toReturn-min)))<fabsf(((float)(toReturn-max)))?min:max;
    }
    return toReturn;
}

@end
