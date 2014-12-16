//
//  WanderaVC.m
//  DLB
//
//  Created by Matic Oblak on 12/4/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "WanderaVC.h"
#import "DLBCircularProgressView.h"
#import "WNDProgressView.h"
#import "WNDPieChart.h"
#import "DLBPieChartSector.h"

@interface WanderaVC ()
@property (weak, nonatomic) IBOutlet WNDProgressView *progressView;
@property (weak, nonatomic) IBOutlet WNDPieChart *pieChartView;
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
    self.progressView.indicatorLineWidth = 10.0f;
    self.progressView.backgroundCircleLineColor = [UIColor colorWithRed:35.0f/255.0f green:37.0f/255.0f blue:37.0f/255.0f alpha:1];
    self.progressView.backgroundCircleLineWidth = 14;
    self.animate = YES;
    
    //NSArray *pieChartSectors =
    //self.pieChartView
    
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
    
    __block NSMutableArray *sectors = [NSMutableArray arrayWithCapacity:5];
    [sectors addObject:[[DLBPieChartSector alloc] initWithSectorValue:10 sectorColor:[UIColor redColor]]];
    [sectors addObject:[[DLBPieChartSector alloc] initWithSectorValue:6 sectorColor:[UIColor blueColor]]];
    [sectors addObject:[[DLBPieChartSector alloc] initWithSectorValue:8 sectorColor:[UIColor greenColor]]];
    [sectors addObject:[[DLBPieChartSector alloc] initWithSectorValue:4 sectorColor:[UIColor yellowColor]]];
    
    /*
    [self performSelector:@selector(testChart1:) withObject:nil afterDelay:2.0];
    [self performSelector:@selector(testChart2:) withObject:nil afterDelay:5.0];
    [self performSelector:@selector(testChart3:) withObject:nil afterDelay:8.0];
    [self performSelector:@selector(testChart4:) withObject:nil afterDelay:11.0];
    */
    
    /* tests */
    self.pieChartView.radious = 50;
    NSLog(@"*** [initial insert]:");
    [self.pieChartView setChartSectors:sectors animated:YES];
    
    
    // Delay execution of my block for 10 seconds.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"*** [remove sector]:");
        [sectors removeObjectAtIndex:0];
        [sectors removeObjectAtIndex:0];
        [sectors insertObject:[[DLBPieChartSector alloc] initWithSectorValue:6 sectorColor:[UIColor blueColor]] atIndex:2];
        [sectors insertObject:[[DLBPieChartSector alloc] initWithSectorValue:6 sectorColor:[UIColor redColor]] atIndex:2];
        [self.pieChartView setChartSectors:sectors animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"*** [sector moved to diferent index]:");
        DLBPieChartSector *sectorChanged = sectors[1];
        [sectors removeObject:sectorChanged];
        [sectors insertObject:sectorChanged atIndex:0];
        
        DLBPieChartSector *sectorChanged2 = sectors[2];
        [sectors removeObject:sectorChanged2];
        [sectors insertObject:sectorChanged2 atIndex:1];
        
        [self.pieChartView setChartSectors:sectors animated:YES];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"*** [sector value changed]:");
        DLBPieChartSector *sectorChanged = sectors[2];
        sectorChanged.sectorValue = 15;
        
        sectorChanged = sectors[3];
        sectorChanged.sectorValue = 10;
        
        [self.pieChartView setChartSectors:sectors animated:YES];

    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"*** [add new sector]:");
        [sectors insertObject:[[DLBPieChartSector alloc] initWithSectorValue:6 sectorColor:[UIColor purpleColor]] atIndex:2];
        [sectors addObject:[[DLBPieChartSector alloc] initWithSectorValue:6 sectorColor:[UIColor orangeColor]]];
        [self.pieChartView setChartSectors:sectors animated:YES];
    });
    
    

    //sectors.sectorValue = 4;
    
    /*
    if(self.animate == YES)
    {
        [self performSelector:@selector(setRandomScale) withObject:nil afterDelay:1.0];
    }
    */
}


- (void)testChart1:(NSArray *)array
{
    
}

- (void)testChart2:(NSArray *)array
{
    
}

- (void)testChart3:(NSArray *)array
{
    
}

- (void)testChart4:(NSArray *)array
{
    
}

@end
