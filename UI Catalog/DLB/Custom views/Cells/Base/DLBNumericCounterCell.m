//
//  DLBNumericCounterCell.m
//  DLB
//
//  Created by Matic Oblak on 1/5/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBNumericCounterCell.h"
#import "DLBNumericCounterView.h"

@interface DLBNumericCounterCell ()

@property (weak, nonatomic) IBOutlet DLBNumericCounterView *counterView;

@property (nonatomic) BOOL animate;

@end

@implementation DLBNumericCounterCell


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self layoutIfNeeded];
    
    [self.counterView layoutIfNeeded];
    self.counterView.suffix = @"%";
    self.counterView.clipsToBounds = YES;
    
    self.animate = YES;
    [self performSelector:@selector(randomValue) withObject:nil afterDelay:1.0];
}

- (void)randomValue
{
    [self.counterView setCurrentValue:rand()%200 animated:YES];
    if(self.animate)
    {
        [self performSelector:@selector(randomValue) withObject:nil afterDelay:3.0];
    }
}

@end
