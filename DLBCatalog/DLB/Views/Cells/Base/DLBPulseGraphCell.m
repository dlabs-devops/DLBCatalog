//
//  DLBPulseGraphCell.m
//  DLB
//
//  Created by Matic Oblak on 12/17/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "DLBPulseGraphCell.h"
#import "DLBPulseGraphView.h"

@interface DLBPulseGraphCell()
@property (weak, nonatomic) IBOutlet DLBPulseGraphView *pulseGraph;

@end


@implementation DLBPulseGraphCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.pulseGraph.lineDimmedColor = [UIColor blueColor];
    self.pulseGraph.lineColor = [UIColor blueColor];
    
    self.pulseGraph.linePoints = @[
                        [NSNumber valueWithCGPoint:CGPointMake(0 / 320.0, ((85.11 / 70.0) - 1.0) * -1.0)],
                        [NSNumber valueWithCGPoint:CGPointMake(74.36 / 320.0, ((85.11 / 70.0) - 1.0) * -1.0)],
                        [NSNumber valueWithCGPoint:CGPointMake(79.43 / 320.0, ((74.66 / 70.0) - 1.0) * -1.0)],
                        [NSNumber valueWithCGPoint:CGPointMake(82.92 / 320.0, ((85.11 / 70.0) - 1.0) * -1.0)],
                        [NSNumber valueWithCGPoint:CGPointMake(86.42 / 320.0, ((85.11 / 70.0) - 1.0) * -1.0)],
                        [NSNumber valueWithCGPoint:CGPointMake(87.82 / 320.0, ((90.34 / 70.0) - 1.0) * -1.0)],
                        [NSNumber valueWithCGPoint:CGPointMake(91.31 / 320.0, ((37.33 / 70.0) - 1.0) * -1.0)],
                        [NSNumber valueWithCGPoint:CGPointMake(96.91 / 320.0, ((110 / 70.0) - 1.0) * -1.0)],
                        [NSNumber valueWithCGPoint:CGPointMake(100.41 / 320.0, ((85.11 / 70.0) - 1.0) * -1.0)],
                        [NSNumber valueWithCGPoint:CGPointMake(109.15 / 320.0, ((85.11 / 70.0) - 1.0) * -1.0)],
                        [NSNumber valueWithCGPoint:CGPointMake(117.89 / 320.0, ((80.06 / 70.0) - 1.0) * -1.0)],
                        [NSNumber valueWithCGPoint:CGPointMake(124.88 / 320.0, ((85.11 / 70.0) - 1.0) * -1.0)],
                        [NSNumber valueWithCGPoint:CGPointMake(320 / 320.0, ((85.36 / 70.0) - 1.0) * -1.0)]
                        ];
    [self.pulseGraph layoutIfNeeded];
    [self performSelector:@selector(scramble) withObject:nil afterDelay:5.0];
}

- (void)scramble
{
    NSMutableArray *points = [[NSMutableArray alloc] init];
    
    CGFloat x = .2f;
    [points addObject:[NSNumber valueWithCGPoint:CGPointMake(.0f, .0f)]];
    [points addObject:[NSNumber valueWithCGPoint:CGPointMake(.18f, .0f)]];
    for(NSInteger i=0; i<10; i++)
    {
        CGFloat y = ((CGFloat)(rand()%1000))/500.0f - 1.0f;
        [points addObject:[NSNumber valueWithCGPoint:CGPointMake(x, y)]];
        
        CGFloat dx = .6f/11.0f;
        x += dx;
    }
    [points addObject:[NSNumber valueWithCGPoint:CGPointMake(.85f, .0f)]];
    [points addObject:[NSNumber valueWithCGPoint:CGPointMake(1.0f, .0f)]];
    
    self.pulseGraph.linePoints = points;
    [self.pulseGraph setNeedsDisplay];
    
    [self performSelector:@selector(scramble) withObject:nil afterDelay:3.0];
}

@end
