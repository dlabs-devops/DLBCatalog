//
//  BaseGooglePlacesSearchViewController.m
//  DLB
//
//  Created by Matic Oblak on 7/10/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "BaseGooglePlacesSearchViewController.h"
#import "DLBGooglePlacesHandler.h"
#import "DLBGogglePlaceTableViewCell.h"

@interface BaseGooglePlacesSearchViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *currentPlaces;

@end

@implementation BaseGooglePlacesSearchViewController

+ (instancetype)instanceFromStoryboard
{
    return [UIStoryboard storyboardWithName:@"BaseGoogleAPI" bundle:nil].instantiateInitialViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textField.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)textChanged:(id)sender
{
    if(self.textField.text.length > 1)
    {
        [self fetchPlaces];
    }
}

- (void)fetchPlaces
{
    DLBGooglePlacesHandler *places = [[DLBGooglePlacesHandler alloc] init];
    places.apiKey = @"AIzaSyDdsH_ImFrIh-J4ukmIXm7TbblogxF3HEc";
    places.searchString = self.textField.text;
    [places fetchPlaces:^(NSInteger placesFound, NSError *error) {
        self.currentPlaces = places.responses;
    }];
}

- (void)setCurrentPlaces:(NSArray *)currentPlaces
{
    _currentPlaces = currentPlaces;
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentPlaces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLBGogglePlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    cell.place = self.currentPlaces[indexPath.row];
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
