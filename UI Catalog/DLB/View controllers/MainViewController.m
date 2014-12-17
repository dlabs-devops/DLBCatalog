//
//  MainViewController.m
//  DLB
//
//  Created by Matic Oblak on 12/17/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "MainViewController.h"

typedef enum : NSUInteger {
    entryCategoryBase,
    entryCategoryWandera,
    entryCategoryCount
} eEntryCategory;

static NSString * __baseTableViewCellID = @"basicCell";

@interface MainViewController()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, self.view.frame.size.width, 50.0f)];
}

- (NSString *)nameForCategory:(eEntryCategory)category
{
    NSString *name = @"Unknown";
    switch (category) {
        case entryCategoryBase:
            name = @"Base";
            break;
        case entryCategoryWandera:
            name = @"Wandera";
            break;
        case entryCategoryCount:
            break;
    }
    return name;
}

- (NSString *)descriptionForCategory:(eEntryCategory)category
{
    NSString *name = @"Unknown";
    switch (category) {
        case entryCategoryBase:
            name = @"Base graphical comonents";
            break;
        case entryCategoryWandera:
            name = @"Wandera V4 UI components";
            break;
        case entryCategoryCount:
            break;
    }
    return name;
}


- (UIViewController *)controllerForCategory:(eEntryCategory)category
{
    UIStoryboard *storyboard = nil;
    switch (category) {
        case entryCategoryBase:
            storyboard = [UIStoryboard storyboardWithName:@"Base" bundle:nil];
            break;
        case entryCategoryWandera:
            storyboard = [UIStoryboard storyboardWithName:@"Wandera" bundle:nil];
            break;
        case entryCategoryCount:
            break;
    }
    return storyboard.instantiateInitialViewController;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return entryCategoryCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:__baseTableViewCellID forIndexPath:indexPath];
    cell.textLabel.text = [self nameForCategory:(eEntryCategory)indexPath.row];
    cell.detailTextLabel.text = [self descriptionForCategory:(eEntryCategory)indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[self controllerForCategory:(eEntryCategory)indexPath.row] animated:YES];
}

@end
