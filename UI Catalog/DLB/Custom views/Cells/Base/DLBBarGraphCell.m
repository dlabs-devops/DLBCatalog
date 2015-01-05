//
//  DLBBarGraphCell.m
//  DLB
//
//  Created by Matic Oblak on 12/18/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "DLBBarGraphCell.h"
#import "DLBBarGraphView.h"
#import "DLBBarGraphNode.h"

@interface DLBBarGraphCell()<DLBBarGraphDataSource, DLBBarGraphNodeDrawing>
@property (weak, nonatomic) IBOutlet DLBBarGraphView *barGraph;
@property (nonatomic) BOOL animate;
@end


@implementation DLBBarGraphCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self layoutIfNeeded];
    
    self.barGraph.dataSource = self;
    self.barGraph.nodeDrawDelegate = self;
//    self.barGraph.nodeBackgroundColor = [[UIColor blueColor] colorWithAlphaComponent:.2f];
    self.barGraph.nodeColor = [UIColor blueColor];
    self.barGraph.barWidth = self.barGraph.frame.size.width/20.0f;
    
    self.animate = YES;
    [self performSelector:@selector(scramble) withObject:nil afterDelay:1.0];
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    self.animate = NO;
}

- (NSInteger)DLBBarGraphViewNumberOfComponents:(DLBBarGraphView *)sender
{
    NSInteger toRetunr = 5 + rand()%30;
//    self.barGraph.barWidth = self.barGraph.frame.size.width/toRetunr;
    return toRetunr;
}

- (NSNumber *)DLBBarGraphView:(DLBBarGraphView *)sender valueAtIndex:(NSInteger)index
{
    CGFloat value = (CGFloat)(rand()%100)/100.0f;
    return @(value);
}

- (void)scramble
{
    CGFloat redScale = (CGFloat)(rand()%100)/100.0f;
    self.barGraph.nodeColor = [UIColor colorWithRed:redScale green:.0f blue:1.0f-redScale alpha:1.0f];
    [self.barGraph reloadGraphAnimated:YES];
    if(self.animate)
    {
        [self performSelector:@selector(scramble) withObject:nil afterDelay:3.0];
    }
}

- (void)DLBBarGraphNode:(DLBBarGraphNode *)node drawIncontext:(CGContextRef)context withRect:(CGRect)rect
{
//    if(node.index < 10)
//    {
        // Draw background
        CGContextSaveGState(context);
        
        CGContextSetFillColorWithColor(context, node.backgroundColor.CGColor);
        CGContextFillRect(context, rect);
        
        CGContextSetFillColorWithColor(context, node.foregroundColor.CGColor);
        
        CGContextAddRect(context, CGRectMake(rect.origin.x, rect.size.height*(1.0-node.scale), rect.size.width, rect.size.height*node.scale));
        
        // generate gradient
        CGFloat colors [] = {
            1.0, .0f, .0f, 1.0,
            .0, .0f, 1.0f, 1.0,
        };
        CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
        CGColorSpaceRelease(baseSpace), baseSpace = NULL;
        CGContextClip(context);
        CGContextDrawLinearGradient(context,
                                    gradient,
                                    CGPointZero,
                                    CGPointMake(.0f, rect.size.height), 0);
        CGContextRestoreGState(context);
//    }
//    else
//    {
//        [node drawDefaultInContext:context];
//    }
}

@end
