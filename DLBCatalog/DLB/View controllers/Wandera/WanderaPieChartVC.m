//
//  WanderaPieChartVC.m
//  DLB
//
//  Created by Matic Oblak on 12/17/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "WanderaPieChartVC.h"
#import "WNDPieChart.h"
#import "DLBPieChartSector.h"

@interface WanderaPieChartVC ()
@property (weak, nonatomic) IBOutlet WNDPieChart *pieChart;
@property (weak, nonatomic) IBOutlet UISwitch *randomSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *removeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *removeRandomSwitch;

@property (nonatomic, strong) NSArray *sectors;

@end

@implementation WanderaPieChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addFewPressed:(id)sender {
    
    NSMutableArray *newSectors = [self.sectors mutableCopy];
    if(newSectors == nil)
    {
        newSectors = [[NSMutableArray alloc] init];
    }
    
    NSInteger count = rand()%4+1;
    
    for(int i=0; i<count; i++)
    {
        UIColor *rndColor = [UIColor colorWithRed:((CGFloat)(rand()%1000))/1000.0f green:((CGFloat)(rand()%1000))/1000.0f blue:((CGFloat)(rand()%1000))/1000.0f alpha:1.0f];
        DLBPieChartSector *sector = [[DLBPieChartSector alloc] initWithSectorValue:((CGFloat)(rand()%1000)) + 10.0f sectorColor:rndColor];
        if(newSectors.count > 1)
        {
            [newSectors insertObject:sector atIndex:rand()%newSectors.count];
        }
        else
        {
            [newSectors addObject:sector];
        }
    }
    
    self.sectors = [newSectors copy];
    
    [self.pieChart setChartSectors:self.sectors animated:self.randomSwitch.on];
}
- (IBAction)removeAllPressed:(id)sender {
    self.sectors = nil;
    [self.pieChart setChartSectors:self.sectors animated:self.removeSwitch.on];
    [self.pieChart setNeedsDisplay];
}
- (IBAction)removeRandomPressed:(id)sender {
    if(self.sectors.count > 0)
    {
        NSInteger index = rand()%self.sectors.count;
        NSMutableArray *newSectors = [self.sectors mutableCopy];
        [newSectors removeObjectAtIndex:index];
        self.sectors = [newSectors copy];
        [self.pieChart setChartSectors:newSectors animated:self.removeRandomSwitch.on];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
