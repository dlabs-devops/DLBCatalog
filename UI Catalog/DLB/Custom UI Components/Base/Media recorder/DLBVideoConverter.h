//
//  DLBVideoConverter.h
//  DLB
//
//  Created by Matic Oblak on 4/28/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

@import UIKit;

@class DLBVideoConverter;

@protocol DLBVideoConverterDelegate<NSObject>

- (void)videoConverter:(DLBVideoConverter *)sender finishedConversionTo:(NSURL *)outputPath;
@optional
- (void)videoConverter:(DLBVideoConverter *)sender encounteredIssue:(NSError *)error message:(NSString *)message;
- (void)videoConverter:(DLBVideoConverter *)sender updatedProgress:(CGFloat)progress;
- (void)videoConverter:(DLBVideoConverter *)sender reportsLagLevel:(NSInteger)level;

@end

@interface DLBVideoConverter : NSObject

@property (nonatomic, weak) id<DLBVideoConverterDelegate> delegate;

@property (nonatomic, strong) NSURL *inputURL;
@property (nonatomic, strong) NSURL *outputURL;
@property (nonatomic) CGSize outputVideoSize;
@property (nonatomic) CGFloat bitRateScale;
@property (nonatomic) BOOL useJPEGCodec;
@property (nonatomic) CGFloat JPEGCodecQuality;
@property (nonatomic) NSInteger keyFrameSkipCount;

- (void)resampleVideo;

@end
