//
//  WanderaVC.m
//  DLB
//
//  Created by Matic Oblak on 12/4/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "WanderaVC.h"
#import "DLBCircularProgressView.h"

@interface WanderaVC ()
@property (weak, nonatomic) IBOutlet DLBCircularProgressView *progressView;
@property BOOL animate;
@end

@implementation WanderaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)viewDidAppear:(BOOL)animated
{
    self.progressView.indicatorColor = [UIColor redColor];
    self.progressView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:.1f];
    self.animate = YES;
    [self setRandomScale];
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.animate = NO;
}

- (void)setRandomScale
{
    int rnd = rand()%100;
    CGFloat scale = ((CGFloat)rnd)/100.0f;
    [self.progressView setValue:scale animated:YES];
    if(self.animate == YES)
    {
        [self performSelector:@selector(setRandomScale) withObject:nil afterDelay:1.0];
    }
}


@end
