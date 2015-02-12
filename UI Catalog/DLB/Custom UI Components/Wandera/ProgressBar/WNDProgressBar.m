//
// Created by Urban Puhar on 09/02/15.
// Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "WNDProgressBar.h"
#import "DLBAnimatableFloat.h"
#import "WNDUsageDataFormatter.h"

#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)

@interface WNDProgressBar ()

@property (retain, nonatomic) NSMutableDictionary *labelFontAttributes;
@property (retain, nonatomic) NSMutableDictionary *progressFontAttributes;
@property (nonatomic, strong) DLBAnimatableFloat *animatableFadeInScale;
@property (retain, nonatomic) NSString *leftLabel;
@property (retain, nonatomic) NSString *rightLabel;
@property (retain, nonatomic) NSString *progressValueLabel;
@property (nonatomic) BOOL fadeInProgressText;
@property (nonatomic) CGRect progressRect;

@end

@implementation WNDProgressBar

- (NSMutableDictionary *)labelFontAttributes
{
    if (!_labelFontAttributes)
    {
        _labelFontAttributes = [NSMutableDictionary dictionary];
        _labelFontAttributes[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.37f green:0.4f blue:0.48f alpha:1.0f];
        _labelFontAttributes[NSFontAttributeName] = [UIFont fontWithName:@"Helvetica-Bold" size:10.0f];
    }

    return _labelFontAttributes;
}

- (NSMutableDictionary *)progressFontAttributes
{
    if (!_progressFontAttributes)
    {
        _progressFontAttributes = [NSMutableDictionary dictionary];
        _progressFontAttributes[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.87f green:0.87f blue:0.87f alpha:1.0f];
        _progressFontAttributes[NSFontAttributeName] = [UIFont fontWithName:@"Helvetica-Bold" size:10.0f];
    }

    return _progressFontAttributes;
}

- (CGRect)progressRect
{
    if (CGRectEqualToRect(_progressRect, CGRectZero))
    {
        _progressRect = CGRectMake(0, 0, self.frame.size.width, 30.0f);
    }

    return _progressRect;
}

- (void)setLabelsFont:(UIFont *)labelsFont
{
    _labelsFont = labelsFont;
    self.labelFontAttributes[NSFontAttributeName] = labelsFont;
}

- (void)setLabelsFontColor:(UIColor *)labelsFontColor
{
    _labelsFontColor = labelsFontColor;
    self.labelFontAttributes[NSForegroundColorAttributeName] = labelsFontColor;
}

- (void)setProgressLabelFont:(UIFont *)progressLabelFont
{
    _progressLabelFont = progressLabelFont;
    self.progressFontAttributes[NSFontAttributeName] = progressLabelFont;
}

- (void)setProgressLabelFontColor:(UIColor *)progressLabelFontColor
{
    _progressLabelFontColor = progressLabelFontColor;
    self.progressFontAttributes[NSForegroundColorAttributeName] = progressLabelFontColor;
}

- (void)fadeInProgressLabelWithCompletion:(void (^)(void))block
{
    // start animation
    self.animatableFadeInScale = [[DLBAnimatableFloat alloc] initWithStartValue:0];
    self.animatableFadeInScale.animationStyle = DLBAnimationStyleEaseInOut;

    [self.animatableFadeInScale animateTo:1.0f withDuration:0.3f onFrameBlock:^(BOOL willEnd)
    {
        self.fadeInProgressText = YES;
        // set color alpha
        UIColor *textColor = self.progressFontAttributes[NSForegroundColorAttributeName];
        self.progressFontAttributes[NSForegroundColorAttributeName] = [textColor colorWithAlphaComponent:(float)self.animatableFadeInScale.floatValue];

        if(willEnd)
        {
            self.animatableFadeInScale = nil;
            if (block)
            {
                block();
            }

            // set color alpha
            self.progressFontAttributes[NSForegroundColorAttributeName] = [textColor colorWithAlphaComponent:1.0f];
        }

        [self setNeedsDisplay];
    }];
}

- (void)setUsageInMB:(NSNumber *)usage withCapInMB:(NSNumber *)cap animate:(BOOL)animate
{
    if(usage && cap)
    {
        self.maxValue = [cap floatValue];
        self.progressValue = [usage floatValue];

        // format usage data
        NSString *usageString = [WNDUsageDataFormatter numberStringForUsageAmount:usage];
        usageString = [NSString stringWithFormat:@"%@%@", usageString, [WNDUsageDataFormatter unitStringForUsageAmount:usage]];

        // format usage data zero (0)
        NSString *usageStringZero = [WNDUsageDataFormatter numberStringForUsageAmount:@(0)];
        usageStringZero = [NSString stringWithFormat:@"%@%@", usageStringZero, [WNDUsageDataFormatter unitStringForUsageAmount:usage]];

        // format usage data cap
        NSString *dataCapString = [WNDUsageDataFormatter numberStringForUsageAmount:cap];
        dataCapString = [NSString stringWithFormat:@"%@%@", dataCapString, [WNDUsageDataFormatter unitStringForUsageAmount:cap]];

        self.leftLabel = usageStringZero;
        self.rightLabel = dataCapString;
        self.progressValueLabel = usageString;

        [self showProgressAnimated:YES withCompletion:nil];
    }
}

- (void)setUsage:(NSNumber *)usage withCap:(NSNumber *)cap witCurrency:(NSString *)symbol animate:(BOOL)animate
{
    if(usage && cap)
    {
        self.maxValue = [cap floatValue];
        self.progressValue = [usage floatValue];

        NSNumberFormatter *currencyFormatter = [WNDUsageDataFormatter currencyFormatter];
        [currencyFormatter setCurrencySymbol:symbol];

        NSString *usageString = [currencyFormatter stringFromNumber:usage];
        NSString *capString = [currencyFormatter stringFromNumber:cap];

        self.leftLabel = [currencyFormatter stringFromNumber:@(0)];
        self.rightLabel = capString;
        self.progressValueLabel = usageString;

        [self showProgressAnimated:YES withCompletion:nil];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    [super drawRect:self.progressRect];

    // draw lines under progress bar
    CGPoint progressPoint;

    if (fequal(super.currentProgressFrame.origin.x, self.progressRect.origin.x))
    {
        progressPoint.x = self.progressRect.origin.x + self.progressRect.size.width;
        progressPoint.y = super.currentProgressFrame.origin.y + super.currentProgressFrame.size.height;
    }
    else
    {
        progressPoint.x = super.currentProgressFrame.origin.x;
        progressPoint.y = super.currentProgressFrame.origin.y + super.currentProgressFrame.size.height;
    }

    CGRect rightLine = [self lineForProgressWithX:progressPoint.x];
    CGRect leftLine = [self lineForProgressWithX:self.progressRect.origin.x];

    // draw labels under progress bar
    CGRect rightLabelRect = [self rectForLabel:self.rightLabel withX:rightLine.origin.x withAttributes:self.labelFontAttributes horizontalAlligment:NSTextAlignmentLeft];

    CGRect leftLabelRect = [self rectForLabel:self.leftLabel withX:leftLine.origin.x withAttributes:self.labelFontAttributes horizontalAlligment:NSTextAlignmentRight];

    if (rightLabelRect.origin.x < (leftLabelRect.origin.x + leftLabelRect.size.width))
    {
        rightLabelRect.origin.x = leftLabelRect.origin.x + leftLabelRect.size.width + 3;
        rightLine.size.height = rightLine.size.height - leftLabelRect.size.height;
    }

    // line colors
    [[UIColor grayColor] setFill];
    CGContextFillRect(context, leftLine);
    CGContextFillRect(context, rightLine);

    [self.rightLabel drawInRect:rightLabelRect withAttributes:self.labelFontAttributes];
    [self.leftLabel drawInRect:leftLabelRect withAttributes:self.labelFontAttributes];

    if (self.fadeInProgressText)
    {
        [self drawProgressLabels];
    }
}

#pragma mark -
#pragma mark - private

- (void)showProgressAnimated:(BOOL)animate withCompletion:(void (^)(void))block
{
    self.fadeInProgressText = NO;
    __weak typeof(self) weakSelf = self;
    [super setProgressValue:self.progressValue animate:animate withCompletion:^{
        [weakSelf fadeInProgressLabelWithCompletion:^void {
            if (block)
            {
                block();
            }
        }];
    }];
}

- (CGRect)lineForProgressWithX:(CGFloat)x
{
    CGRect returnValue;

    returnValue.size.width = 1.0f; //line width
    returnValue.size.height = self.frame.size.height; //line height
    returnValue.origin.x = x - 0.5f;
    returnValue.origin.y = 0.0f;

    return returnValue;
}

- (CGRect)rectForLabel:(NSString *)text withX:(CGFloat)x withAttributes:(NSDictionary *)attributes horizontalAlligment:(NSTextAlignment)alignment
{
    CGRect returnRect;
    CGSize textSize = [text sizeWithAttributes:attributes];

    if (alignment == NSTextAlignmentRight)
    {
        returnRect.origin.x = x + 5.0f;
    }
    else if (alignment == NSTextAlignmentLeft)
    {
        returnRect.origin.x = x - textSize.width - 5.0f;
    }
    else if (alignment == NSTextAlignmentCenter)
    {
        returnRect.origin.x = x - textSize.width / 2.0f;
    }

    returnRect.origin.y = self.frame.size.height - textSize.height;
    returnRect.size = textSize;

    returnRect.size.width = returnRect.size.width + 2.0f;
    returnRect.size.height = returnRect.size.height + 2.0f;

    return returnRect;
}

- (void)drawProgressLabels
{

    // check if progress is higher than max value.
    if (self.progressValue < self.maxValue)
    {
        // if it is not higher than concatenate texts and draw text in progress rect
        // or empty progress rect. Empty progress rect is right (empty) side of progress
        NSString *progressLabel = [NSString stringWithFormat:@"%@ %@", self.progressValueLabel, self.progressLabel];
        CGSize progressLabelSize = [progressLabel sizeWithAttributes:self.progressFontAttributes];
        CGFloat emptyProgressWidth = self.progressRect.size.width - self.currentProgressFrame.size.width;
        CGRect progressLabelRect;

        if (self.currentProgressFrame.size.width > progressLabelSize.width)
        {
            progressLabelRect.size = progressLabelSize;
            progressLabelRect.origin = CGPointMake((self.currentProgressFrame.size.width - progressLabelSize.width)/2.0f,
                    (self.progressRect.size.height - progressLabelSize.height)/2.0f);

            [progressLabel drawInRect:progressLabelRect withAttributes:self.progressFontAttributes];
        }
        else if (emptyProgressWidth > progressLabelSize.width)
        {
            progressLabelRect.size = progressLabelSize;
            progressLabelRect.origin = CGPointMake(self.currentProgressFrame.size.width + (emptyProgressWidth - progressLabelSize.width)/2.0f,
                    (self.progressRect.size.height - progressLabelSize.height)/2.0f);

            [progressLabel drawInRect:progressLabelRect withAttributes:self.progressFontAttributes];
        }
    }
    else
    {
        CGSize progressTextValueSize = [self.progressLabeloverMax sizeWithAttributes:self.progressFontAttributes];
        CGSize progressTextSize = [self.progressLabeloverMax sizeWithAttributes:self.progressFontAttributes];
        CGFloat emptyProgressWidth = self.progressRect.size.width - self.currentProgressFrame.size.width;

        // check if self.progressLabel width is smaller than left side of progress bar and
        // if self.progressValueLabel width is smaller than progress rect
        if (progressTextSize.width < emptyProgressWidth &&
                (progressTextValueSize.width < self.currentProgressFrame.size.width))
        {
            CGRect progressTextRect;
            progressTextRect.origin.x = (emptyProgressWidth - progressTextSize.width) - 6.0f;
            progressTextRect.origin.y = (self.progressRect.size.height - progressTextValueSize.height)/2.0f;
            progressTextRect.size = progressTextSize;

            CGRect progressValueText;
            progressValueText.origin.x = self.currentProgressFrame.origin.x + 6.0f;
            progressValueText.origin.y = (self.progressRect.size.height - progressTextSize.height)/2.0f;
            progressValueText.size = progressTextValueSize;

            [self.progressLabeloverMax drawInRect:progressTextRect withAttributes:self.progressFontAttributes];
            [self.progressValueLabel drawInRect:progressValueText withAttributes:self.progressFontAttributes];
        }
        else // else concatenate labels and draw them in the middle of progress bar rect
        {
            NSString *progressLabel = [NSString stringWithFormat:@"%@ %@", self.progressLabeloverMax, self.progressValueLabel];
            CGRect progressLabelRect;
            CGSize progressLabelSize = [progressLabel sizeWithAttributes:self.progressFontAttributes];

            progressLabelRect.size = progressLabelSize;
            progressLabelRect.origin = CGPointMake((self.progressRect.size.width - progressLabelSize.width)/2.0f,
                    (self.progressRect.size.height - progressLabelSize.height)/2.0f);

            [progressLabel drawInRect:progressLabelRect withAttributes:self.progressFontAttributes];
        }
    }
}

@end