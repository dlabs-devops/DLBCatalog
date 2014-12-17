//
//  BaseViewController.m
//  DLB
//
//  Created by Matic Oblak on 12/17/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    baseComponentCircularProgressView,
    baseComponentPulseGraph,
    baseComponentPieChart,
    baseComponentCount
} eBaseComponent;

@interface BaseViewController()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation BaseViewController

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return baseComponentCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height/6.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellForComponent:(eBaseComponent)indexPath.row];
}

#pragma mark - Cells

- (UITableViewCell *)cellForComponent:(eBaseComponent)component
{
    UITableViewCell *toReturn = nil;
    switch (component) {
        case baseComponentCircularProgressView:
        {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"circularViewCell"];
            toReturn = cell;
            break;
        }
        case baseComponentPulseGraph:
        {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"pulseGraphCell"];
            toReturn = cell;
            break;
        }
        case baseComponentPieChart:
        {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"pieChartViewCell"];
            toReturn = cell;
            break;
        }
        default:
            break;
    }
    return toReturn;
}

@end
