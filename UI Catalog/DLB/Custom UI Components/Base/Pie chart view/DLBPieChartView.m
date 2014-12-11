//
//  DLBPieChart.m
//  DLB
//
//  Created by Urban on 11/12/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "DLBPieChartView.h"

@interface DLBPieChartView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
//@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation DLBPieChartView

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
    [[NSBundle mainBundle] loadNibNamed:@"DLBPieChartView" owner:self options:nil];
    
    // The following is to make sure content view, extends out all the way to fill whatever our view size is even as our view's size is changed by autolayout
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview: self.contentView];
    
    [[self class] addEdgeConstraint:NSLayoutAttributeLeft superview:self subview:self.contentView];
    [[self class] addEdgeConstraint:NSLayoutAttributeRight superview:self subview:self.contentView];
    [[self class] addEdgeConstraint:NSLayoutAttributeTop superview:self subview:self.contentView];
    [[self class] addEdgeConstraint:NSLayoutAttributeBottom superview:self subview:self.contentView];
    
    [self layoutIfNeeded];
}

+ (void)addEdgeConstraint:(NSLayoutAttribute)edge superview:(UIView *)superview subview:(UIView *)subview
{
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                          attribute:edge
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:edge
                                                         multiplier:1
                                                           constant:0]];
}

@end
