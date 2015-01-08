//
//  WanderaBarGraphVC.m
//  DLB
//
//  Created by Matic Oblak on 1/8/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "WanderaBarGraphVC.h"
#import "WNDBarGraphView.h"
#import "DLBDateTools.h"

@interface WanderaBarGraphVC ()<WNDBarGraphViewDataSource>
@property (weak, nonatomic) IBOutlet WNDBarGraphView *graphView;
@property (weak, nonatomic) IBOutlet UIButton *weekButton;
@property (weak, nonatomic) IBOutlet UIButton *dayButton;
@property (weak, nonatomic) IBOutlet UIButton *monthButton;

@end

@implementation WanderaBarGraphVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.graphView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)periodSelected:(UIButton *)sender {
    self.weekButton.backgroundColor = [UIColor colorWithWhite:.11f alpha:1.0f];
    self.monthButton.backgroundColor = [UIColor colorWithWhite:.11f alpha:1.0f];
    self.dayButton.backgroundColor = [UIColor colorWithWhite:.11f alpha:1.0f];
    
    if(sender == self.weekButton)
    {
        self.weekButton.backgroundColor = [UIColor colorWithWhite:.3f alpha:1.0f];
    }
    else if(sender == self.monthButton)
    {
        self.monthButton.backgroundColor = [UIColor colorWithWhite:.3f alpha:1.0f];
    }
    if(sender == self.dayButton)
    {
        self.dayButton.backgroundColor = [UIColor colorWithWhite:.3f alpha:1.0f];
    }
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

- (void)animate
{
    int step = rand()%4;
    [self.graphView refreshWithStyle:step animated:YES];
}

@end
