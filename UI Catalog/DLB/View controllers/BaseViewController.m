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
    baseComponentBarGraph,
    baseComponentNumericCounter,
    baseComponentAnimations,
    baseComponentRecording,
    baseComponentImageCrop,
    baseComponentCount
} eBaseComponent;

@interface BaseViewController()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation BaseViewController

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == baseComponentNumericCounter)
    {
        [self.navigationController pushViewController:[UIStoryboard storyboardWithName:@"BaseCounter" bundle:nil].instantiateInitialViewController animated:YES];
    }
    if(indexPath.row == baseComponentRecording)
    {
        [self.navigationController pushViewController:[UIStoryboard storyboardWithName:@"BaseMediaRecorder" bundle:nil].instantiateInitialViewController animated:YES];
    }
    else if(indexPath.row == baseComponentImageCrop)
    {
        [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"ImageCrop" bundle:nil] instantiateViewControllerWithIdentifier:@"square"] animated:YES];
    }
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
        case baseComponentBarGraph:
        {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"barGraphViewCell"];
            toReturn = cell;
            break;
        }
        case baseComponentNumericCounter:
        {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"numericCounterCell"];
            toReturn = cell;
            break;
        }
        case baseComponentAnimations:
        {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"animationsCell"];
            toReturn = cell;
            break;
        }
        case baseComponentRecording:
        {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"recordingCell"];
            toReturn = cell;
            break;
        }
        case baseComponentImageCrop:
        {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cropCell"];
            toReturn = cell;
            break;
        }
        default:
            break;
    }
    return toReturn;
}

@end
