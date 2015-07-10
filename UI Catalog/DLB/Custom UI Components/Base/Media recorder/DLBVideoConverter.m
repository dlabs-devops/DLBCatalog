//
//  DLBVideoConverter.m
//  DLB
//
//  Created by Matic Oblak on 4/28/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBVideoConverter.h"
@import AVFoundation;

#define M_WAIT_INTERVAL(X) (.01*X)

@interface DLBVideoConverter()

@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, strong) AVURLAsset *inputAsset;
@property (nonatomic, strong) NSArray *inputTracks;
@property (nonatomic, strong) NSArray *inputVideoTracks;
@property (nonatomic, strong) NSArray *inputAudioTracks;
@property (nonatomic) CGAffineTransform inputTransform;
@property (nonatomic) CGSize inputSize;
@property (nonatomic) NSTimeInterval inputDuration;

@property (nonatomic, strong) AVAssetReaderTrackOutput *videoTrackOutput;
@property (nonatomic, strong) AVAssetReader *videoTrackReader;
@property (nonatomic, strong) AVAssetReaderTrackOutput *audioTrackOutput;
@property (nonatomic, strong) AVAssetReader *audioTrackReader;


@property (nonatomic, strong) AVAssetWriter *assetWriter;
@property (nonatomic, strong) AVAssetWriterInput *videoAssetWriter;
@property (nonatomic, strong) AVAssetWriterInput *audioAssetWriter;
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *inputAdaptor;

@property (nonatomic, readonly) CGFloat outputWidth;
@property (nonatomic, readonly) CGFloat outputHeight;

@property (nonatomic) NSInteger currentSampleSkipCount;

@end


@implementation DLBVideoConverter

- (void)setInputURL:(NSURL *)inputURL
{
    if([inputURL isKindOfClass:[NSString class]])
    {
        inputURL = [NSURL URLWithString:(NSString *)inputURL];
    }
    _inputURL = inputURL;
}
- (void)setOutputURL:(NSURL *)outputURL
{
    if([outputURL isKindOfClass:[NSString class]])
    {
        outputURL = [NSURL URLWithString:(NSString *)outputURL];
    }
    _outputURL = outputURL;
}

- (void)clearOutputPath
{
    NSError *error = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:[self.outputURL path]])
    {
        [[NSFileManager defaultManager] removeItemAtURL:self.outputURL error:&error];
        [self reportError:error withMessage:@"Clearing output path error"];
    }
}
- (void)loadTrackValuesOnAsset:(AVAsset *)asset callback:(void (^)(void))callback
{
    NSArray *keys = @[@"playable", @"tracks", @"duration"];
    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        self.inputDuration = (NSTimeInterval)CMTimeGetSeconds(asset.duration);
        if(callback)
        {
            callback();
        }
    }];
}

- (void)loadInputData:(void (^)(AVAsset *asset))callback
{
    self.inputAsset = [AVURLAsset URLAssetWithURL:self.inputURL options:nil];
    [self loadTrackValuesOnAsset:self.inputAsset callback:^{
        self.inputTracks = self.inputAsset.tracks;
        NSMutableArray *videoTracks = [[NSMutableArray alloc] init];
        NSMutableArray *audioTracks = [[NSMutableArray alloc] init];
        for(AVAssetTrack *track in self.inputTracks)
        {
            if([track.mediaType isEqualToString:AVMediaTypeVideo])
            {
                [videoTracks addObject:track];
                self.inputTransform = [track preferredTransform];
            }
            else if([track.mediaType isEqualToString:AVMediaTypeAudio])
            {
                [audioTracks addObject:track];
            }
            
        }
        self.inputVideoTracks = videoTracks;
        self.inputAudioTracks = audioTracks;
        CGSize size = CGSizeZero;
        for(AVAssetTrack *track in self.inputVideoTracks)
        {
            CGSize targetSize = track.naturalSize;
            if(targetSize.width > size.width)
            {
                size = targetSize;
            }
        }
        self.inputSize = size;
        
        if(callback)
        {
            callback(self.inputAsset);
        }
    }];
}

- (dispatch_queue_t)queue
{
    if(_queue == nil)
    {
        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return _queue;
}

- (CGFloat)outputWidth
{
    CGSize targetSize = self.inputSize;
    if(self.outputVideoSize.width > .0f && self.outputVideoSize.height > .0f)
    {
        targetSize = self.outputVideoSize;
    }
    targetSize = CGSizeApplyAffineTransform(targetSize, self.inputTransform);
    return (CGFloat)fabs(targetSize.width);
}
- (CGFloat)outputHeight
{
    CGSize targetSize = self.inputSize;
    if(self.outputVideoSize.width > .0f && self.outputVideoSize.height > .0f)
    {
        targetSize = self.outputVideoSize;
    }
    targetSize = CGSizeApplyAffineTransform(targetSize, self.inputTransform);
    return (CGFloat)fabs(targetSize.height);
}

- (CGFloat)bitRateScale
{
    if(_bitRateScale > .0f)
    {
        return _bitRateScale;
    }
    return 1.0f;
}

- (NSInteger)keyFrameSkipCount
{
    if(_keyFrameSkipCount > 0)
    {
        return _keyFrameSkipCount;
    }
    return 15*30*10000;
}

- (CGFloat)JPEGCodecQuality
{
    if(_JPEGCodecQuality > 0)
    {
        return _JPEGCodecQuality;
    }
    else
    {
        return .5f;
    }
}

- (NSDictionary *)downsampledVideoOutputSettings
{
    NSMutableDictionary *videoSettings = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *codecSettings = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *apertureSettings = [[NSMutableDictionary alloc] init];
    
    [apertureSettings setObject:@(self.outputWidth) forKey:AVVideoCleanApertureWidthKey];
    [apertureSettings setObject:@(self.outputHeight) forKey:AVVideoCleanApertureHeightKey];
    [apertureSettings setObject:@(0) forKey:AVVideoCleanApertureHorizontalOffsetKey];
    [apertureSettings setObject:@(0) forKey:AVVideoCleanApertureVerticalOffsetKey];
    
    [codecSettings setObject:apertureSettings forKey:AVVideoCleanApertureKey];
    if(self.useJPEGCodec)
    {
        [codecSettings setObject:@(self.JPEGCodecQuality) forKey:AVVideoQualityKey];
    }
    else
    {
        [codecSettings setObject:@(self.keyFrameSkipCount) forKey:AVVideoMaxKeyFrameIntervalKey];
        [codecSettings setObject:@(((int)self.bitRateScale*960000)) forKey:AVVideoAverageBitRateKey];
        [codecSettings setObject:AVVideoProfileLevelH264High40 forKey:AVVideoProfileLevelKey];
    }

    [videoSettings setObject:self.useJPEGCodec?AVVideoCodecJPEG:AVVideoCodecH264 forKey:AVVideoCodecKey];
    [videoSettings setObject:codecSettings forKey:AVVideoCompressionPropertiesKey];
    [videoSettings setObject:@(self.outputWidth) forKey:AVVideoWidthKey];
    [videoSettings setObject:@(self.outputHeight) forKey:AVVideoHeightKey];
    [videoSettings setObject:AVVideoScalingModeResizeAspectFill forKey:AVVideoScalingModeKey];
    
    return videoSettings;
}
- (NSDictionary *)createVideoOutputSettings
{
    return [self downsampledVideoOutputSettings];
}

- (NSDictionary *)createAudioInputSettings
{
    AudioChannelLayout acl;
    bzero( &acl, sizeof(acl));
    acl.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
    
    return @{
             AVFormatIDKey : @(kAudioFormatLinearPCM),
             AVSampleRateKey : @(44100.0),
             AVNumberOfChannelsKey : @(2),
             AVChannelLayoutKey : [NSData dataWithBytes:&acl length:sizeof(acl)],
             AVLinearPCMBitDepthKey : @(16),
             AVLinearPCMIsNonInterleaved : @(NO),
             AVLinearPCMIsFloatKey : @(NO),
             AVLinearPCMIsBigEndianKey : @(NO)
             };
}
- (NSDictionary *)createAudioOutputSettings
{
    AudioChannelLayout acl;
    bzero( &acl, sizeof(acl));
    acl.mChannelLayoutTag = kAudioChannelLayoutTag_Mono;
    
    return @{
             AVFormatIDKey : @(kAudioFormatMPEG4AAC),
             AVNumberOfChannelsKey : @(1),
             AVSampleRateKey : @(44100.0),
             AVEncoderBitRateKey : @(64000),
             AVChannelLayoutKey : [NSData dataWithBytes:&acl length:sizeof(acl)]
             };
}

- (void)prepareInputComponents
{
    self.videoTrackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:self.inputVideoTracks.firstObject outputSettings:@{(NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA)}];
    NSError *error = nil;
    self.videoTrackReader = [AVAssetReader assetReaderWithAsset:self.inputAsset error:&error];
    [self reportError:error withMessage:@"Error setting up video asset reader"];
    if([self.videoTrackReader canAddOutput:self.videoTrackOutput])
    {
        [self.videoTrackReader addOutput:self.videoTrackOutput];
    }
    else
    {
        [self reportError:[NSError errorWithDomain:@"internal" code:500 userInfo:nil] withMessage:@"Can not add video reader output"];
    }
    
    self.audioTrackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:self.inputAudioTracks.firstObject outputSettings:[self createAudioInputSettings]];
    error = nil;
    self.audioTrackReader = [AVAssetReader assetReaderWithAsset:self.inputAsset error:&error];
    [self reportError:error withMessage:@"Error setting up audio asset reader"];
    if([self.audioTrackReader canAddOutput:self.audioTrackOutput])
    {
        [self.audioTrackReader addOutput:self.audioTrackOutput];
    }
    else
    {
        [self reportError:[NSError errorWithDomain:@"internal" code:500 userInfo:nil] withMessage:@"Can not add audio reader output"];
    }
}
- (void)prepareOutputComponents
{
    [self clearOutputPath];
    
    NSError *error = nil;
    self.assetWriter = [[AVAssetWriter alloc] initWithURL:self.outputURL fileType:AVFileTypeMPEG4 error:&error];
    [self reportError:error withMessage:@"Asset writer error"];
    
    self.videoAssetWriter = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:[self createVideoOutputSettings]];
    self.videoAssetWriter.transform = self.inputTransform;
    
    NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey,
                                                           @(self.outputWidth), kCVPixelBufferWidthKey,
                                                           @(self.outputHeight), kCVPixelBufferHeightKey,
                                                           nil];
    self.inputAdaptor = [AVAssetWriterInputPixelBufferAdaptor
                         assetWriterInputPixelBufferAdaptorWithAssetWriterInput:self.videoAssetWriter
                         sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    if([self.assetWriter canAddInput:self.videoAssetWriter] == NO)
    {
        [self reportError:[NSError errorWithDomain:@"internal" code:404 userInfo:nil] withMessage:@"Can not add input to the asset writer"];
    }
    self.videoAssetWriter.expectsMediaDataInRealTime = NO;
    [self.assetWriter addInput:self.videoAssetWriter];
    
    
    
    self.audioAssetWriter = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:[self createAudioOutputSettings]];
    if([self.assetWriter canAddInput:self.audioAssetWriter] == NO)
    {
        [self reportError:[NSError errorWithDomain:@"internal" code:404 userInfo:nil] withMessage:@"Can not add input to the asset writer"];
    }
    self.audioAssetWriter.expectsMediaDataInRealTime = NO;
    [self.assetWriter addInput:self.audioAssetWriter];
}

- (void)insertInputBuffersCallback:(void (^)(void))callback
{
    BOOL audioDone = NO;
    BOOL videoDone = NO;
    NSTimeInterval currentAudioProgress = .0;
    NSTimeInterval currentVideoProgress = .0;
    for(;;)
    {
        BOOL audioReady = self.audioAssetWriter.readyForMoreMediaData;
        BOOL videoReady = self.videoAssetWriter.readyForMoreMediaData;
        
        BOOL didInsert = NO;
        if(audioReady && audioDone == NO)
        {
            CMSampleBufferRef audioBuffer = [self.audioTrackOutput copyNextSampleBuffer];
            if(audioBuffer)
            {
                CMSampleTimingInfo timing;
                CMItemCount returnCount = 0;
                CMSampleBufferGetOutputSampleTimingInfoArray(audioBuffer, 1, &timing, &returnCount);
                CMTime time = timing.presentationTimeStamp;
                
                NSTimeInterval timeInterval = CMTimeGetSeconds(time);
                if(timeInterval > currentAudioProgress)
                {
                    currentAudioProgress = timeInterval;
                    [self reportProgress:(currentAudioProgress+currentVideoProgress)*.5f];
                }
                
                BOOL didAppend = [self.audioAssetWriter appendSampleBuffer:audioBuffer];
                if(!didAppend)
                {
                    [self reportError:[NSError errorWithDomain:@"internal" code:500 userInfo:nil] withMessage:@"Failed appending the audio buffer"];
                }
                CFRelease(audioBuffer);
            }
            else
            {
                [self.audioAssetWriter markAsFinished];
                audioDone = YES;
            }
            
            didInsert = YES;
        }
        if(videoReady && videoDone == NO)
        {
            CMSampleBufferRef videoBuffer = [self.videoTrackOutput copyNextSampleBuffer];
            if(videoBuffer)
            {
                CMSampleTimingInfo timing;
                CMItemCount returnCount = 0;
                CMSampleBufferGetOutputSampleTimingInfoArray(videoBuffer, 1, &timing, &returnCount);
                CMTime time = timing.presentationTimeStamp;
                
                NSTimeInterval timeInterval = CMTimeGetSeconds(time);
                if(timeInterval > currentVideoProgress)
                {
                    currentVideoProgress = timeInterval;
                    [self reportProgress:(currentAudioProgress+currentVideoProgress)*.5f];
                }
                
                CVPixelBufferRef pBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(videoBuffer);
                if(pBuffer)
                {
                    BOOL didAppend = [self.inputAdaptor appendPixelBuffer:pBuffer withPresentationTime:time];
                    if(!didAppend)
                    {
                        [self reportError:[NSError errorWithDomain:@"internal" code:500 userInfo:nil] withMessage:@"Failed appending the video buffer"];
                    }
                }
                else
                {
                    [self reportError:[NSError errorWithDomain:@"internal" code:500 userInfo:nil] withMessage:@"Could not get the pixel buffer"];
                }
                
                CFRelease(videoBuffer);
            }
            else
            {
                [self.videoAssetWriter markAsFinished];
                videoDone = YES;
            }
            
            didInsert = YES;
        }
        
        if(audioDone && videoDone)
        {
            if(callback)
            {
                callback();
            }
            break;
        }
        
        if(didInsert == NO)
        {
            self.currentSampleSkipCount++;
            NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:M_WAIT_INTERVAL(self.currentSampleSkipCount)];
            [[NSRunLoop currentRunLoop] runUntilDate:maxDate];
            continue;
        }
        else if(self.currentSampleSkipCount)
        {
            [self reportSkipCountIncreased:self.currentSampleSkipCount];
        }
    }
}
- (void)beginConversion:(void (^)(void))finishedBlock
{
    dispatch_async(self.queue, ^{
        [self.assetWriter startWriting];
        [self.assetWriter startSessionAtSourceTime:kCMTimeZero];
        
        [self.audioTrackReader startReading];
        [self.videoTrackReader startReading];
        
        [self insertInputBuffersCallback:^{
            [self.assetWriter finishWritingWithCompletionHandler:^{
                if(finishedBlock)
                {
                    finishedBlock();
                }
            }];
        }];
    });
}

- (void)resampleVideo
{
    [self loadInputData:^(AVAsset *asset) {
        [self prepareInputComponents];
        [self prepareOutputComponents];
        [self beginConversion:^{
            [self reportConversionDone];
        }];
    }];
}

- (void)reportConversionDone
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate videoConverter:self finishedConversionTo:self.outputURL];
    });
}
- (void)reportError:(NSError *)error withMessage:(NSString *)message
{
    if(error)
    {
        if([self.delegate respondsToSelector:@selector(videoEditorController:didFailWithError:)])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate videoConverter:self encounteredIssue:error message:message];
            });
        }
        else
        {
            NSLog(@"[ERROR](Video converter) %@", message);
        }
    }
}
- (void)reportProgress:(NSTimeInterval)progress
{
    if(self.inputDuration > .0f)
    {
        if([self.delegate respondsToSelector:@selector(videoConverter:updatedProgress:)])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate videoConverter:self updatedProgress:((CGFloat)(progress/self.inputDuration))];
            });
        }
        else
        {
            NSLog(@"Conversion progress updated: %g", ((CGFloat)(progress/self.inputDuration)));
        }
    }
}
- (void)reportSkipCountIncreased:(NSInteger)count
{
    if([self.delegate respondsToSelector:@selector(videoConverter:reportsLagLevel:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate videoConverter:self reportsLagLevel:count];
        });
    }
    else
    {
        NSLog(@"Lag level: %d", (int)count);
    }
}

@end
