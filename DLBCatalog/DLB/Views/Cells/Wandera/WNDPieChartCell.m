//
//  DLBPieChartCell.m
//  DLB
//
//  Created by Matic Oblak on 12/17/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "WNDPieChartCell.h"
#import "WNDPieChart.h"
#import "DLBPieChartSector.h"

@interface WNDPieChartCell ()
@property (weak, nonatomic) IBOutlet WNDPieChart *pieChart;
@property (nonatomic, strong) NSArray *sectors;

@end

@implementation WNDPieChartCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self animate];
}

- (void)animate
{
    [self scrambleSectors];
    [self.pieChart setChartSectors:self.sectors animated:YES];
    [self performSelector:@selector(animate) withObject:nil afterDelay:3.0];
}

- (void)scrambleSectors
{
    NSInteger toRemoveCount = (NSInteger)(rand()%5);
    NSInteger toAddCount = (NSInteger)(rand()%5);
    
    NSMutableArray *newSectors = [self.sectors mutableCopy];
    if(newSectors == nil)
    {
        newSectors = [[NSMutableArray alloc] init];
    }
    
    for(DLBPieChartSector *sector in newSectors)
    {
        sector.sectorValue = ((CGFloat)(rand()%1000)) + 10.0f;
    }
    
    while(newSectors.count > 0 && toRemoveCount > 0)
    {
        NSInteger randomItem = (NSInteger)(rand()%newSectors.count);
        toRemoveCount--;
        [newSectors removeObjectAtIndex:randomItem];
    }
    
    while(toAddCount > 0)
    {
        UIColor *rndColor = [UIColor colorWithRed:((CGFloat)(rand()%1000))/1000.0f green:((CGFloat)(rand()%1000))/1000.0f blue:((CGFloat)(rand()%1000))/1000.0f alpha:1.0f];
        DLBPieChartSector *sector = [[DLBPieChartSector alloc] initWithSectorValue:((CGFloat)(rand()%1000)) + 10.0f sectorColor:rndColor];
        [newSectors addObject:sector];
        toAddCount--;
    }
    
    self.sectors = [newSectors copy];
}

@end

