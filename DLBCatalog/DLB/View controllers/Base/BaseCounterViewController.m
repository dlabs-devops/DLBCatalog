//
//  BaseCounterViewController.m
//  DLB
//
//  Created by Matic Oblak on 1/6/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "BaseCounterViewController.h"
#import "DLBNumericCounterView.h"

@interface BaseCounterViewController ()
@property (weak, nonatomic) IBOutlet DLBNumericCounterView *counterView;
@property (weak, nonatomic) IBOutlet UIButton *leftAlignmentButton;
@property (weak, nonatomic) IBOutlet UIButton *centerAlignmentButton;
@property (weak, nonatomic) IBOutlet UIButton *rightAlignmentButton;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;

@end

@implementation BaseCounterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.counterView layoutIfNeeded];
    self.counterView.componentAlignment = NSTextAlignmentRight;
}


- (IBAction)alignmentPressed:(id)sender {
    self.leftAlignmentButton.backgroundColor = [UIColor lightGrayColor];
    self.rightAlignmentButton.backgroundColor = [UIColor lightGrayColor];
    self.centerAlignmentButton.backgroundColor = [UIColor lightGrayColor];
    
    if(sender == self.leftAlignmentButton)
    {
        self.counterView.componentAlignment = NSTextAlignmentLeft;
        self.leftAlignmentButton.backgroundColor = [UIColor darkGrayColor];
    }
    if(sender == self.rightAlignmentButton)
    {
        self.counterView.componentAlignment = NSTextAlignmentRight;
        self.rightAlignmentButton.backgroundColor = [UIColor darkGrayColor];
    }
    if(sender == self.centerAlignmentButton)
    {
        self.counterView.componentAlignment = NSTextAlignmentCenter;
        self.centerAlignmentButton.backgroundColor = [UIColor darkGrayColor];
    }
}
- (IBAction)setDirect:(id)sender {
    NSNumber *number = [[NSDecimalNumber alloc] initWithString:self.amountTextField.text];
    [self.counterView setCurrentValue:number.integerValue];
}
- (IBAction)setAnimated:(id)sender {
    NSNumber *number = [[NSDecimalNumber alloc] initWithString:self.amountTextField.text];
    [self.counterView setCurrentValue:number.integerValue animated:YES];
}

@end
