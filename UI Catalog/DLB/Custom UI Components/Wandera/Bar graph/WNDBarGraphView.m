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

@interface WNDBarGraphView()<DLBBarGraphDataSource, DLBBarGraphNodeDrawing, DLBBarGraphDelegate>

@property (nonatomic, strong) DLBBarGraphView *barGraph;
@property (nonatomic, strong) WNDBarGraphDataObject *currentDataObject;
@property (nonatomic, strong) WNDBarGraphDataObject *previousDataObject;
@property (nonatomic) eBarGraphTransitionStyle currentTransitionStyle;
@property (nonatomic) BOOL blockRefresh;

@end


@implementation WNDBarGraphView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.barGraph.frame = [self graphFrame];
}


#pragma mark - Transitions

- (BOOL)refreshWithStyle:(eBarGraphTransitionStyle)style animated:(BOOL)animated
{
    if(self.blockRefresh)
    {
        // refresh is blocked
        return NO;
    }
    
    if(animated == NO)
    {
        self.previousDataObject = self.currentDataObject;
        self.currentDataObject = [self generateNewDataObject];
        
        self.currentTransitionStyle = barGraphTransitionStyleRefresh;
        self.barGraph.graphScale = self.currentDataObject.scale;
        [self.barGraph reloadGraphAnimated:NO];
    }
    else
    {
        self.currentTransitionStyle = style;
        switch (style) {
            case barGraphTransitionStyleRefresh:
                self.previousDataObject = self.currentDataObject;
                self.currentDataObject = [self generateNewDataObject];
                self.barGraph.graphScale = self.currentDataObject.scale;
                [self.barGraph reloadGraphAnimated:YES];
                break;
            case barGraphTransitionStyleFromLeft:
            {
                // create another graph view and animate the current one
                self.previousDataObject = self.currentDataObject;
                self.currentDataObject = [self generateNewDataObject];
                DLBBarGraphView *previousGraph = self.barGraph;
                
                previousGraph.dataSource = nil;
                previousGraph.delegate = nil;
                previousGraph.nodeDrawDelegate = nil;
                
                self.barGraph = nil;
                CGRect normalFrame = [self graphFrame];
                
                self.barGraph.frame = CGRectMake(normalFrame.origin.x-normalFrame.size.width,
                                                 normalFrame.origin.y,
                                                 normalFrame.size.width,
                                                 normalFrame.size.height);
                self.barGraph.graphScale = self.currentDataObject.scale;
                [self.barGraph reloadGraphAnimated:NO];
                
                [UIView animateWithDuration:.35 delay:.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
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
                self.previousDataObject = self.currentDataObject;
                self.currentDataObject = [self generateNewDataObject];
                DLBBarGraphView *previousGraph = self.barGraph;
                
                previousGraph.dataSource = nil;
                previousGraph.delegate = nil;
                previousGraph.nodeDrawDelegate = nil;
                
                self.barGraph = nil;
                CGRect normalFrame = [self graphFrame];
                
                self.barGraph.frame = CGRectMake(normalFrame.origin.x+normalFrame.size.width,
                                                 normalFrame.origin.y,
                                                 normalFrame.size.width,
                                                 normalFrame.size.height);
                self.barGraph.graphScale = self.currentDataObject.scale;
                [self.barGraph reloadGraphAnimated:NO];
                
                [UIView animateWithDuration:.35 delay:.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
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
                self.blockRefresh = YES;
                self.barGraph.graphScale = self.currentDataObject.scale;
                // reverse first and second and refresh the data
                
                self.previousDataObject = self.currentDataObject;
                self.currentDataObject = nil;
                
                [self.barGraph reloadGraphAnimated:YES];
                break;
            default:
                break;
        }
    }
    return YES;
}

- (void)DLBBarGraphDelegateEndedAnimation:(DLBBarGraphView *)sender
{
    if(self.currentTransitionStyle == barGraphTransitionStyleCloseAndOpen)
    {
        self.blockRefresh = NO;
        self.previousDataObject = self.currentDataObject;
        self.currentDataObject = [self generateNewDataObject];
        [self refreshWithStyle:barGraphTransitionStyleRefresh animated:YES];
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
    NSMutableArray *secondaryValues = [[NSMutableArray alloc] init];
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
            NSNumber *secondaryAmount = [self.dataSource WNDBarGraphView:self secondaryValueFrom:lastDate to:date];
            if(secondaryAmount == nil)
            {
                secondaryAmount = @(.0f);
            }
            [secondaryValues addObject:secondaryAmount];
        }
        lastDate = date;
    }
    object.componentValues = values;
    object.componentSecondaryValues = secondaryValues;
    
    object.scale = object.scale; // is a small optimization
    
    return object;
}

#pragma mark - Graph

- (CGFloat)barWidth
{
    if(_barWidth <= .0f)
    {
        return 5.0f;
    }
    return _barWidth;
}

- (CGRect)graphFrame
{
    return CGRectMake(.0f, .0f, self.frame.size.width, self.frame.size.height);
}

- (DLBBarGraphView *)barGraph
{
    if(_barGraph == nil)
    {
        _barGraph = [[DLBBarGraphView alloc] initWithFrame:[self graphFrame]];
        _barGraph.barWidth = self.barWidth;
        _barGraph.backgroundColor = [UIColor clearColor];
        [self addSubview:_barGraph];
        _barGraph.dataSource = self;
        _barGraph.delegate = self;
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
    NSNumber *toReturn = [self.currentDataObject overallValueAtIndex:index];
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

- (UIColor *)primaryBarColor
{
    if(_primaryBarColor == nil)
    {
        _primaryBarColor = [UIColor colorWithRed:98.0f/255.0f green:164.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    }
    return _primaryBarColor;
}
- (UIColor *)secondaryBarColor
{
    if(_secondaryBarColor == nil)
    {
        _secondaryBarColor = [UIColor colorWithRed:217.0f/255.0f green:115.0f/255.0f blue:40.0f/255.0f alpha:1.0f];
    }
    return _secondaryBarColor;
}

- (void)DLBBarGraphNode:(DLBBarGraphNode *)node drawInContext:(CGContextRef)context withRect:(CGRect)rect
{
    CGContextSaveGState(context);
    
    CGContextSetFillColorWithColor(context, node.backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
    WNDBarGraphDataObject *targetObject = self.currentDataObject;
    if(node.scale > .0f && targetObject == nil)
    {
        targetObject = self.previousDataObject;
    }
    CGFloat minScale = [targetObject secondaryValueAtIndex:node.index].floatValue;
    CGFloat maxScale = [targetObject overallValueAtIndex:node.index].floatValue;
    CGFloat secondaryScale = .0f;
    if(maxScale >= .0f)
    {
        secondaryScale = minScale/maxScale * node.scale;
    }
    CGRect maximumRect = CGRectMake(rect.origin.x, rect.size.height*(1.0-node.scale), rect.size.width, rect.size.height*node.scale);
    CGRect minimumRect = CGRectMake(rect.origin.x, rect.size.height*(1.0-secondaryScale), rect.size.width, rect.size.height*node.scale);
    
    
    CGContextSetFillColorWithColor(context, self.primaryBarColor.CGColor);
    CGContextFillRect(context, maximumRect);
    CGContextSetFillColorWithColor(context, self.secondaryBarColor.CGColor);
    CGContextFillRect(context, minimumRect);
    

    CGContextRestoreGState(context);
}

@end
