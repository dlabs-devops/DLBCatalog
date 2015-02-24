//
//  BaseStarViewController.m
//  DLB
//
//  Created by Matic Oblak on 2/24/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "BaseStarViewController.h"
#import "DLBInterectableStarView.h"

@interface BaseStarViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, DLBInterectableStarViewDelegate>
@property (weak, nonatomic) IBOutlet DLBInterectableStarView *starView;

@property (nonatomic, strong) UIPickerView *starCountPicker;
@property (nonatomic, strong) UIPickerView *ratingPicker;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@end

@implementation BaseStarViewController

- (void)viewDidLoad
{
    self.starView.delegate = self;
    self.starView.maximumRating = 10.0f;
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)]];
}

- (void)onTap:(id)sender
{
    [self.starCountPicker removeFromSuperview];
    [self.ratingPicker removeFromSuperview];
}

- (IBAction)starCountPressed:(id)sender
{
    [self.starCountPicker removeFromSuperview];
    [self.ratingPicker removeFromSuperview];
    self.starCountPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(.0f, self.view.frame.size.height-self.view.frame.size.width, self.view.frame.size.width, self.view.frame.size.width)];
    [self.view addSubview:self.starCountPicker];
    self.starCountPicker.delegate = self;
    self.starCountPicker.dataSource = self;
}
- (IBAction)ratingPressed:(id)sender
{
    [self.starCountPicker removeFromSuperview];
    [self.ratingPicker removeFromSuperview];
    self.ratingPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(.0f, self.view.frame.size.height-self.view.frame.size.width, self.view.frame.size.width, self.view.frame.size.width)];
    [self.view addSubview:self.ratingPicker];
    self.ratingPicker.delegate = self;
    self.ratingPicker.dataSource = self;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerView==self.starCountPicker?100:100;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == self.starCountPicker)
    {
        return [@(row+2) stringValue];
    }
    else
    {
        CGFloat value = row;
        value/=10.0f;
        return [@(value) stringValue];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [UIView animateWithDuration:.35 animations:^{
        if(pickerView == self.starCountPicker)
        {
            self.starView.ratingSize = row+2;
        }
        else
        {
            CGFloat value = row;
            value/=10.0f;
            self.starView.rating = value;
        }
    }];
    self.ratingLabel.text = [NSString stringWithFormat:@"Rating: %.1f / %.1f", self.starView.rating, self.starView.maximumRating];
}

- (void)interectableStarView:(DLBInterectableStarView *)sender selectedRating:(CGFloat)rating
{
    self.ratingLabel.text = [NSString stringWithFormat:@"Rating: %.1f / %.1f", self.starView.rating, self.starView.maximumRating];
}

@end
