//
//  DLBPieChart.m
//  DLB
//
//  Created by Urban on 11/12/14.
//  Copyright (c) 2014 Matic Oblak. All rights reserved.
//

#import "DLBPieChartView.h"
#import "DLBPieChartSector.h"
#import "DLBPieChartNode.h"
#import "DLBAnimatableFloat.h"

@interface DLBPieChartView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic) float sectorValuesSum;
@property (nonatomic, strong) NSMutableArray *chartNodes;
@property (nonatomic, strong) DLBAnimatableFloat *animatableScale;

@end

@implementation DLBPieChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame]))
    {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
    [[NSBundle mainBundle] loadNibNamed:@"DLBPieChartView" owner:self options:nil];
    
    // The following is to make sure content view, extends out all the way to fill whatever our view size is even as our view's size is changed by autolayout
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview: self.contentView];
    
    [[self class] addEdgeConstraint:NSLayoutAttributeLeft superview:self subview:self.contentView];
    [[self class] addEdgeConstraint:NSLayoutAttributeRight superview:self subview:self.contentView];
    [[self class] addEdgeConstraint:NSLayoutAttributeTop superview:self subview:self.contentView];
    [[self class] addEdgeConstraint:NSLayoutAttributeBottom superview:self subview:self.contentView];
    
    [self layoutIfNeeded];
}

+ (void)addEdgeConstraint:(NSLayoutAttribute)edge superview:(UIView *)superview subview:(UIView *)subview
{
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                          attribute:edge
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:edge
                                                         multiplier:1
                                                           constant:0]];
}

- (void)animateGraph
{
    
}

- (void)setChartSectors:(NSArray *)graphSectors animated:(BOOL)animate{

    if (!self.chartNodes)
    {
        self.chartNodes = [NSMutableArray arrayWithCapacity:5];
    }

    // create, update, insert new graph nodes
    for (int i = 0; i < graphSectors.count; i++)
    {
        DLBPieChartSector *loopSector = graphSectors[i];
        [self updateNodeAt:i withSector:loopSector];
    }
    
    // Remove marked nodes
    [self.chartNodes enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(DLBPieChartNode *obj, NSUInteger idx, BOOL *removeOnNextUpdate)
    {
        if(obj.removeOnNextUpdate)
        {
            [self.chartNodes removeObject:obj];
        }
            
    }];
    
    // If number of graph sectors is greater than number of chart nodes than
    // mark nodes at the end of array. Mark nodes will be deleted next update
    // Move them at the beginning of the array so that other nodes are drawn over
    for (NSInteger i = graphSectors.count; i < self.chartNodes.count; i++)
    {
        DLBPieChartNode *loopNode = self.chartNodes[i];
        loopNode.removeOnNextUpdate = YES;
        [self.chartNodes removeObject:loopNode];
        [self.chartNodes insertObject:loopNode atIndex:0];
    }
    
    //calcuate chart sum
    [self calculateChartSumValue];
    
    //refresh nodes with new angles
    [self refreshNodes];
    
    //start animation
    if(animate)
    {
        // TODO:
        self.animatableScale = [[DLBAnimatableFloat alloc] initWithStartValue:0];
        self.animatableScale.animationStyle = DLBAnimationStyleEaseInOut;
        [self.animatableScale animateTo:1.0f withDuration:3.0f onFrameBlock:^(BOOL willEnd) {
            self.scale = self.animatableScale.floatValue;
            if(willEnd)
            {
                self.animatableScale = nil;
            }
        }];
    }
    else
    {
        [self.animatableScale invalidateAnimation];
    }
}

-(void)setScale:(float)scale
{
    _scale = scale;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // loop through sectors and draw them
    for (DLBPieChartNode *loopNode in self.chartNodes){
        [self drawSector:loopNode inContext:context];
    }
}

#pragma mark -
#pragma mark - Private

- (void)drawSector:(DLBPieChartNode *)node inContext:(CGContextRef)context
{
    //don't animate nodes that have been marked to remove on next update
    if (node.removeOnNextUpdate) {
        [self drawSectorWithStarAngle:node.newStartAngle
                             endAngle:node.newEndAngle
                            fillColor:node.pieChartSector.sectorColor
                            inContext:context];
    }
    else
    {
        float startAngle = [self interpolationFormStartAngle:(node.currentStartAngle)
                                                  toEndAngle:node.newStartAngle
                                                   withScale:self.scale];
        
        float endAngle = [self interpolationFormStartAngle:node.currentEndAngle
                                                toEndAngle:node.newEndAngle
                                                 withScale:self.scale];
        
        [self drawSectorWithStarAngle:startAngle
                             endAngle:endAngle
                            fillColor:node.pieChartSector.sectorColor
                            inContext:context];
    }
}

- (void)drawSectorWithStarAngle:(float)startAngle endAngle:(float)endAngle fillColor:(UIColor *)color inContext:(CGContextRef)context
{
    float viewWidth = self.frame.size.width;
    float viewHeight = self.frame.size.height;
    CGPoint center = CGPointMake(viewWidth/2.0f, viewHeight/2.0f);
    float lineWidth = 0;

    UIBezierPath *sectorPath = [UIBezierPath bezierPath];
    [sectorPath moveToPoint:center];    
    [sectorPath addArcWithCenter:center
                             radius:self.radious - lineWidth/2.0f
                         startAngle:startAngle
                           endAngle:endAngle
                          clockwise:YES];
    sectorPath.lineWidth = lineWidth;

    [sectorPath closePath];
    
    [color setFill];
    [sectorPath fill];
}

- (void)updateNodeAt:(int)index withSector:(DLBPieChartSector *)sector
{
    //check if exists
    DLBPieChartNode *matchingNode = nil;
    int matchingNodeIndex = -1;
    
    //check if node with given sector already exists
    for (int i = 0; i < self.chartNodes.count; i++)
    {
        DLBPieChartNode *loopNode = self.chartNodes[i];
        
        if (loopNode.pieChartSector == sector)
        {
            matchingNode = loopNode;
            matchingNodeIndex = i;
        }
    }
    
    //update node's position if it exists and is has new position
    if (matchingNode && (matchingNodeIndex != index))
    {
        [self.chartNodes removeObjectAtIndex:matchingNodeIndex];
        [self.chartNodes insertObject:matchingNode atIndex:index];
    }
    else
    {
        //create new node
        DLBPieChartNode *newNode = [[DLBPieChartNode alloc] initWithSector:sector];
        newNode.newThisUpdate = YES;
        if (index >= self.chartNodes.count)
        {
            [self.chartNodes addObject:newNode];
        }
        else
        {
            [self.chartNodes insertObject:newNode atIndex:index];
        }
    }
}

- (void)calculateChartSumValue
{
    self.sectorValuesSum = 0;
    for (DLBPieChartNode *loopNode in self.chartNodes)
    {
        if (!loopNode.removeOnNextUpdate)//skip node's value if it has to be removed
        {
            self.sectorValuesSum = self.sectorValuesSum + loopNode.pieChartSector.sectorValue;
        }
    }
}

-(float)interpolationFormStartAngle:(float)startAngle toEndAngle:(float)endAngle withScale:(float)scale
{
    return startAngle + (endAngle - startAngle)*scale;
}

- (void)refreshNodes
{
    float loopAngle = 0;
    for (int i = 0; i < self.chartNodes.count; i++)
    {
        DLBPieChartNode *loopNode = self.chartNodes[i];
        DLBPieChartNode *precedingNode = nil;
        
        //find preceding node
        if (i == 0)
        {
            precedingNode = nil;
        }
        else
        {
            precedingNode = self.chartNodes[i-1];
        }
        
        if (!loopNode.removeOnNextUpdate)
        {
            // calculate chart relatove node angle
            float nodeAngle = (loopNode.pieChartSector.sectorValue / self.sectorValuesSum)*(2.0 * M_PI);
        
            // update current node's angles
            if (loopNode.newThisUpdate)
            {
                if (precedingNode)
                {
                    loopNode.currentStartAngle = precedingNode.currentEndAngle;
                    loopNode.currentEndAngle = precedingNode.currentEndAngle;
                }
                else
                {
                    loopNode.currentStartAngle = 0;
                    loopNode.currentEndAngle = 0;
                }
            }else
            {
                loopNode.currentStartAngle = loopNode.newStartAngle;
                loopNode.currentEndAngle = loopNode.newEndAngle;
            }
            
            loopNode.newThisUpdate = NO;
            
            //update new angles
            loopNode.newStartAngle = loopAngle;
            loopNode.newEndAngle = loopAngle + nodeAngle;
            loopAngle = loopAngle + nodeAngle;
        }
    }
}

@end
