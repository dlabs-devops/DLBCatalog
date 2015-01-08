//
//  WNDBarGraphCell.m
//  DLB
//
//  Created by Matic Oblak on 1/7/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "WNDBarGraphCell.h"
#import "WNDBarGraphView.h"
#import "DLBDateTools.h"
@interface WNDBarGraphCell()<WNDBarGraphViewDataSource>
@property (weak, nonatomic) IBOutlet WNDBarGraphView *barGraph;

@end


@implementation WNDBarGraphCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.barGraph.clipsToBounds = YES;
    self.barGraph.dataSource = self;
    
    [self animate];
}

- (NSNumber *)WNDBarGraphView:(WNDBarGraphView *)sender valueFrom:(NSDate *)startDate to:(NSDate *)endDate
{
    int value = rand()%50;
    return @(value);
}
- (NSNumber *)WNDBarGraphView:(WNDBarGraphView *)sender secondaryValueFrom:(NSDate *)startDate to:(NSDate *)endDate
{
    int value = rand()%50;
    return @(value);
}

- (NSNumber *)WNDBarGraphViewGraphScale:(WNDBarGraphView *)sender
{
    return @(100.0f);
}
- (NSDate *)WNDBarGraphViewDisplayStartDate:(WNDBarGraphView *)sender
{
    NSInteger rnd = ((NSInteger)(rand()%20)) - 3;
    return [DLBDateTools date:[NSDate date] byAddingDays:-30+rnd];
}
- (NSDate *)WNDBarGraphViewDisplayEndDate:(WNDBarGraphView *)sender
{
    return [NSDate date];
}
- (eBarGraphComponentPeriod)WNDBarGraphViewDisplayComponentPeriod:(WNDBarGraphView *)sender
{
    return barGraphComponentPeriodDay;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.barGraph refreshWithStyle:barGraphTransitionStyleRefresh animated:NO];
}

- (void)animate
{
    int step = rand()%4;
    [self.barGraph refreshWithStyle:step animated:YES];
    [self performSelector:@selector(animate) withObject:nil afterDelay:3.0];
}


@end
