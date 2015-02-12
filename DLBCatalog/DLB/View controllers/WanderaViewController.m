//
//  WanderaViewController.m
//  DLB
//
//  Created by Matic Oblak on 12/17/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "WanderaViewController.h"

typedef enum : NSUInteger {
    wanderaComponentCircularProgressView,
    wanderaComponentPulseGraph,
    wanderaComponentPieChart,
    wanderaComponentBarGraph,
    wanderaComponentCount
} eWanderaComponent;


@interface WanderaViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WanderaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, self.view.frame.size.width, 50.0f)];
}


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
    return wanderaComponentCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height/6.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellForComponent:(eWanderaComponent)indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == wanderaComponentPieChart)
    {
        [self.navigationController pushViewController:[UIStoryboard storyboardWithName:@"WanderaPieChart" bundle:nil].instantiateInitialViewController animated:YES];
        
    }
    if(indexPath.row == wanderaComponentBarGraph)
    {
        [self.navigationController pushViewController:[UIStoryboard storyboardWithName:@"WanderaBarGraph" bundle:nil].instantiateInitialViewController animated:YES];
        
    }
}

#pragma mark - Cells

- (UITableViewCell *)cellForComponent:(eWanderaComponent)component
{
    UITableViewCell *toReturn = nil;
    switch (component) {
        case wanderaComponentCircularProgressView:
        {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"circularViewCell"];
            toReturn = cell;
            break;
        }
        case wanderaComponentPulseGraph:
        {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"pulseGraphCell"];
            toReturn = cell;
            break;
        }
        case wanderaComponentPieChart:
        {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"pieChartViewCell"];
            toReturn = cell;
            break;
        }
        case wanderaComponentBarGraph:
        {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"barGraphViewCell"];
            toReturn = cell;
            break;
        }
        default:
            break;
    }
    return toReturn;
}

@end
