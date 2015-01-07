//
//  WNDBarGraphView.m
//  DLB
//
//  Created by Matic Oblak on 1/7/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "WNDBarGraphView.h"
#import "DLBBarGraphView.h"
#import "WNDBarGraphDataObject.h"
#import "DLBBarGraphNode.h"

@interface WNDBarGraphView()<DLBBarGraphDataSource, DLBBarGraphNodeDrawing>

@property (nonatomic, strong) DLBBarGraphView *barGraph;
@property (nonatomic, strong) WNDBarGraphDataObject *currentDataObject;
@property (nonatomic, strong) WNDBarGraphDataObject *previousDataObject;

@end


@implementation WNDBarGraphView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.barGraph.frame = [self graphFrame];
    [self.barGraph layoutIfNeeded];
}


#pragma mark - Transitions

- (void)refreshWithStyle:(eBarGraphTransitionStyle)style animated:(BOOL)animated
{
    self.previousDataObject = self.currentDataObject;
    self.currentDataObject = [self generateNewDataObject];
    
    if(animated == NO)
    {
        self.barGraph.graphScale = self.currentDataObject.scale;
        [self.barGraph reloadGraphAnimated:NO];
    }
    else
    {
        // TODO: handle all styles
        switch (style) {
            case barGraphTransitionStyleRefresh:
                self.barGraph.graphScale = self.currentDataObject.scale;
                [self.barGraph reloadGraphAnimated:YES];
                break;
            case barGraphTransitionStyleFromLeft:
            {
                // create another graph view and animate the current one
                DLBBarGraphView *previousGraph = self.barGraph;
                
                previousGraph.dataSource = nil;
                previousGraph.nodeDrawDelegate = nil;
                
                self.barGraph = nil;
                CGRect normalFrame = [self graphFrame];
                
                self.barGraph.frame = CGRectMake(normalFrame.origin.x-normalFrame.size.width,
                                                 normalFrame.origin.y,
                                                 normalFrame.size.width,
                                                 normalFrame.size.height);
                self.barGraph.graphScale = self.currentDataObject.scale;
                [self.barGraph reloadGraphAnimated:NO];
                
                [UIView animateWithDuration:.3 animations:^{
                    previousGraph.frame = CGRectMake(normalFrame.origin.x+normalFrame.size.width,
                                                     normalFrame.origin.y,
                                                     normalFrame.size.width,
                                                     normalFrame.size.height);
                    self.barGraph.frame = normalFrame;
                } completion:^(BOOL finished) {
                    [previousGraph removeFromSuperview];
                }];
                
                break;
            }
            case barGraphTransitionStyleFromRight:
            {
                // create another graph view and animate the current one
                DLBBarGraphView *previousGraph = self.barGraph;
                
                previousGraph.dataSource = nil;
                previousGraph.nodeDrawDelegate = nil;
                
                self.barGraph = nil;
                CGRect normalFrame = [self graphFrame];
                
                self.barGraph.frame = CGRectMake(normalFrame.origin.x+normalFrame.size.width,
                                                 normalFrame.origin.y,
                                                 normalFrame.size.width,
                                                 normalFrame.size.height);
                self.barGraph.graphScale = self.currentDataObject.scale;
                [self.barGraph reloadGraphAnimated:NO];
                
                [UIView animateWithDuration:.3 animations:^{
                    previousGraph.frame = CGRectMake(normalFrame.origin.x-normalFrame.size.width,
                                                     normalFrame.origin.y,
                                                     normalFrame.size.width,
                                                     normalFrame.size.height);
                    self.barGraph.frame = normalFrame;
                } completion:^(BOOL finished) {
                    [previousGraph removeFromSuperview];
                }];
                
                break;
            }
            case barGraphTransitionStyleCloseAndOpen:
                self.barGraph.graphScale = self.currentDataObject.scale;
                [self.barGraph reloadGraphAnimated:YES];
                break;
            default:
                break;
        }
    }
}

#pragma mark - Data

- (WNDBarGraphDataObject *)generateNewDataObject
{
    // generate object to return
    WNDBarGraphDataObject *object = [[WNDBarGraphDataObject alloc] init];
    
    // fill basic data
    object.startDate = [self.dataSource WNDBarGraphViewDisplayStartDate:self];
    object.endDate = [self.dataSource WNDBarGraphViewDisplayEndDate:self];
    object.componentPeriod = [self.dataSource WNDBarGraphViewDisplayComponentPeriod:self];
    object.scale = [self.dataSource WNDBarGraphViewGraphScale:self].floatValue;
    [object commitData];
    
    // fill value data
    NSMutableArray *values = [[NSMutableArray alloc] init];
    NSDate *lastDate = nil;
    for(NSDate *date in object.componentStartDates)
    {
        if(lastDate)
        {
            NSNumber *amount = [self.dataSource WNDBarGraphView:self valueFrom:lastDate to:date];
            if(amount == nil)
            {
                amount = @(.0f);
            }
            [values addObject:amount];
        }
        lastDate = date;
    }
    object.componentValues = values;
    
    object.scale = object.scale; // is a small optimization
    
    return object;
}

#pragma mark - Graph

- (CGRect)graphFrame
{
    return CGRectMake(.0f, .0f, self.frame.size.width, self.frame.size.height);
}

- (DLBBarGraphView *)barGraph
{
    if(_barGraph == nil)
    {
        _barGraph = [[DLBBarGraphView alloc] initWithFrame:[self graphFrame]];
        [self addSubview:_barGraph];
        _barGraph.dataSource = self;
        _barGraph.nodeDrawDelegate = self;
    }
    return _barGraph;
}

#pragma mark Data source

- (NSInteger)DLBBarGraphViewNumberOfComponents:(DLBBarGraphView *)sender
{
    return self.currentDataObject.componentCount;
}

- (NSNumber *)DLBBarGraphView:(DLBBarGraphView *)sender valueAtIndex:(NSInteger)index
{
    NSNumber *toReturn = [self.currentDataObject valueAtIndex:index];
    if(toReturn == nil)
    {
        return @(.0f);
    }
    else
    {
        return toReturn;
    }
}

#pragma mark Bar drawing

- (void)DLBBarGraphNode:(DLBBarGraphNode *)node drawInContext:(CGContextRef)context withRect:(CGRect)rect
{
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
}

@end
