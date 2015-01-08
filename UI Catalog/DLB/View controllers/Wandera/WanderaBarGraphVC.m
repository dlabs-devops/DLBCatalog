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

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic) NSInteger periodeMode;

@end

@implementation WanderaBarGraphVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedDate = [NSDate date];
    self.periodeMode = 2;
    
    self.graphView.dataSource = self;
    self.graphView.barWidth = 5.0f/320.0f * self.view.frame.size.width;
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
        self.periodeMode = 1;
    }
    else if(sender == self.monthButton)
    {
        self.monthButton.backgroundColor = [UIColor colorWithWhite:.3f alpha:1.0f];
        self.periodeMode = 2;
    }
    if(sender == self.dayButton)
    {
        self.dayButton.backgroundColor = [UIColor colorWithWhite:.3f alpha:1.0f];
        self.periodeMode = 0;
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
    return self.selectedDate;
}
- (NSDate *)WNDBarGraphViewDisplayEndDate:(WNDBarGraphView *)sender
{
    NSDate *toReturn = self.selectedDate;
    switch (self.periodeMode) {
        case 0:
            toReturn = [DLBDateTools date:toReturn byAddingDays:1];
            break;
        case 1:
            toReturn = [DLBDateTools date:toReturn byAddingDays:7];
            break;
        case 2:
            toReturn = [DLBDateTools date:toReturn byAddingMonths:1];
            break;
        default:
            break;
    }
    return toReturn;
}
- (eBarGraphComponentPeriod)WNDBarGraphViewDisplayComponentPeriod:(WNDBarGraphView *)sender
{
    if(self.periodeMode == 0)
    {
        return barGraphComponentPeriodHour;
    }
    else
    {
        return barGraphComponentPeriodDay;
    }
}

- (IBAction)refreshFromLeft:(id)sender {
    switch (self.periodeMode) {
        case 0:
            self.selectedDate = [DLBDateTools date:self.selectedDate byAddingDays:-1];
            break;
        case 1:
            self.selectedDate = [DLBDateTools date:self.selectedDate byAddingDays:-7];
            break;
        case 2:
            self.selectedDate = [DLBDateTools date:self.selectedDate byAddingMonths:-1];
            break;
        default:
            break;
    }
    [self.graphView refreshWithStyle:barGraphTransitionStyleFromLeft animated:YES];
}
- (IBAction)refreshStatic:(id)sender {
    [self.graphView refreshWithStyle:barGraphTransitionStyleRefresh animated:YES];
}
- (IBAction)refreshInOut:(id)sender {
    [self.graphView refreshWithStyle:barGraphTransitionStyleCloseAndOpen animated:YES];
}
- (IBAction)refreshFromRight:(id)sender {
    switch (self.periodeMode) {
        case 0:
            self.selectedDate = [DLBDateTools date:self.selectedDate byAddingDays:1];
            break;
        case 1:
            self.selectedDate = [DLBDateTools date:self.selectedDate byAddingDays:7];
            break;
        case 2:
            self.selectedDate = [DLBDateTools date:self.selectedDate byAddingMonths:1];
            break;
        default:
            break;
    }
    [self.graphView refreshWithStyle:barGraphTransitionStyleFromRight animated:YES];
    
}

@end
