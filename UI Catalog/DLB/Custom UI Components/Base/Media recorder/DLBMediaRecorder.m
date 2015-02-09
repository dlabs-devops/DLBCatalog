//
//  DLBMediaRecorder.m
//  DLB
//
//  Created by Matic Oblak on 2/9/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBMediaRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface DLBMediaRecorder ()<AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInputDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *audioInputDevice;
@property (nonatomic) BOOL recorderInitialized;
@property (nonatomic) BOOL isRecording;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation DLBMediaRecorder

#pragma mark - initialization

- (instancetype)init
{
    if((self = [super init]))
    {
        self.allowSoundRecording = YES;
        self.outputVideoOrientation = AVCaptureVideoOrientationLandscapeRight;
        self.previewVideoOrientation = AVCaptureVideoOrientationPortrait;
    }
    return self;
}

- (void)dealloc
{
    [self tearDown];
}

#pragma mark - internal getters

- (NSString *)outputPath
{
    if(_outputPath == nil)
    {
        return [NSTemporaryDirectory() stringByAppendingPathComponent:@"output.mov"];
    }
    else
    {
        return _outputPath;
    }
}

- (NSString *)videoCaptureQualityPreset
{
    if(_videoCaptureQualityPreset == nil)
    {
        return AVCaptureSessionPresetMedium;
    }
    else
    {
        return self.videoCaptureQualityPreset;
    }
}

- (AVCaptureSession *)captureSession
{
    if(_captureSession == nil)
    {
        _captureSession = [[AVCaptureSession alloc] init];
        [_captureSession setSessionPreset:self.videoCaptureQualityPreset];
    }
    return _captureSession;
}

- (AVCaptureMovieFileOutput *)movieFileOutput
{
    if(_movieFileOutput == nil)
    {
        _movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        if(self.maximumDuration > .0)
        {
            _movieFileOutput.maxRecordedDuration = CMTimeMakeWithSeconds(self.maximumDuration, 30);
        }
    }
    return _movieFileOutput;
}

#pragma mark - recorder setup

- (BOOL)attachVideoDevice
{
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *videoError;
    self.videoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&videoError];
    if([self.captureSession canAddInput:self.videoInputDevice])
    {
        [self.captureSession addInput:self.videoInputDevice];
        return YES;
    }
    else
    {
        [self.delegate DLBMediaRecorder:self encounteredIssue:[[DLBInternalError alloc] initAsWarning:@"Unable to attach video device" additionalInfo:videoError.localizedDescription]];
        return NO;
    }
}

- (BOOL)attachAudioDevice
{
    if(self.allowSoundRecording == NO)
    {
        return YES;
    }
    
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *audioError;
    self.audioInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&audioError];
    if([self.captureSession canAddInput:self.audioInputDevice])
    {
        [self.captureSession addInput:self.audioInputDevice];
        return YES;
    }
    else
    {
        [self.delegate DLBMediaRecorder:self encounteredIssue:[[DLBInternalError alloc] initAsWarning:@"Unable to attach audio device" additionalInfo:audioError.localizedDescription]];
        return NO;
    }
}

- (BOOL)attachOutput
{
    if([self.captureSession canAddOutput:self.movieFileOutput])
    {
        [self.captureSession addOutput:self.movieFileOutput];
        
        //
        // Find the video connection to set the output orientation
        //
        for(AVCaptureConnection *connection in self.movieFileOutput.connections)
        {
            for(AVCaptureInputPort *port in [connection inputPorts])
            {
                if ([[port mediaType] isEqual:AVMediaTypeVideo] && [connection isVideoOrientationSupported])
                {
                    connection.videoOrientation = self.outputVideoOrientation;
                }
            }
        }
        return YES;
    }
    else
    {
        [self.delegate DLBMediaRecorder:self encounteredIssue:[[DLBInternalError alloc] initAsError:@"Unable to attach file output" additionalInfo:@"Session is unable to add the movie output"]];
        return NO;
    }
}

- (void)tearDown
{
    [self.movieFileOutput stopRecording];
    [self.captureSession stopRunning];
    self.captureSession = nil;
    
    self.movieFileOutput = nil;
    
    self.videoInputDevice = nil;
    self.audioInputDevice = nil;
    
    self.recorderInitialized = NO;
    self.isRecording = NO;
}

- (BOOL)initializeRecorder
{
    if(self.recorderInitialized)
    {
        [self.delegate DLBMediaRecorder:self encounteredIssue:[[DLBInternalError alloc] initAsWarning:@"Recorder already initialized" additionalInfo:@"Recorder initialization called while already initialized"]];
        return YES;
    }
    //
    // Initialize and attach the video device
    //
    BOOL videoAttached = [self attachVideoDevice];
    BOOL audioAttached = [self attachAudioDevice];
    BOOL outputAttached = [self attachOutput];
    
    BOOL toReturn = YES;
    
    if(videoAttached == NO || audioAttached == NO || outputAttached == NO)
    {
        if((videoAttached || audioAttached) == NO)
        {
            [self.delegate DLBMediaRecorder:self encounteredIssue:[[DLBInternalError alloc] initAsError:@"No input device is attached"]];
            toReturn = NO;
        }
        else if(outputAttached == NO)
        {
            [self.delegate DLBMediaRecorder:self encounteredIssue:[[DLBInternalError alloc] initAsError:@"Output device is not attached"]];
            toReturn = NO;
        }
        else
        {
            [self.delegate DLBMediaRecorder:self encounteredIssue:[[DLBInternalError alloc] initAsWarning:@"Unable to attach all devices to"]];
            toReturn = YES;
        }
    }
    
    if(toReturn)
    {
        [self.captureSession startRunning];
    }
    
    self.recorderInitialized = toReturn;    
    if(self.sessionAttachedView)
    {
        // This will reinitialize the preview layer
        self.sessionAttachedView = self.sessionAttachedView;
    }
    return toReturn;
}

#pragma mark - capture delegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    BOOL recordedSuccessfully = YES;
    if([error code] != noErr)
    {
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if(value)
        {
            recordedSuccessfully = [value boolValue];
        }
    }
    
    if(error)
    {
        [self.delegate DLBMediaRecorder:self encounteredIssue:[[DLBInternalError alloc] initAsError:@"Error finalizing the video" additionalInfo:error.localizedDescription]];
        recordedSuccessfully = NO;
    }
    else if(recordedSuccessfully == NO)
    {
        [self.delegate DLBMediaRecorder:self encounteredIssue:[[DLBInternalError alloc] initAsError:@"Recording reported as unsuccessfull" additionalInfo:error.localizedDescription]];
    }
    [self.delegate DLBMediaRecorder:self finishedRecordingAt:self.outputPath asSuccessful:recordedSuccessfully];
}

#pragma mark - handles

- (void)beginRecording
{
    if(self.isRecording)
    {
        [self.delegate DLBMediaRecorder:self encounteredIssue:[[DLBInternalError alloc] initAsWarning:@"Recording already in progress" additionalInfo:@"The recording has been called before the previous recording has finished"]];
    }
    else if(self.recorderInitialized == NO)
    {
        BOOL didInitialize = [self initializeRecorder];
        if(didInitialize == NO)
        {
            // can not record so return
            return;
        }
    }
    
    NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:self.outputPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:self.outputPath])
    {
        NSError *error;
        if([fileManager removeItemAtPath:self.outputPath error:&error] == NO)
        {
            [self.delegate DLBMediaRecorder:self encounteredIssue:[[DLBInternalError alloc] initAsError:@"Unable to begin recording" additionalInfo:[NSString stringWithFormat:@"Can not remove the item at output file %@", self.outputPath]]];
            self.isRecording = NO;
            return;
        }
    }
    [self.movieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
    self.isRecording = YES;
}

- (void)stopRecording
{
    [self.movieFileOutput stopRecording];
    self.isRecording = NO;
}

- (void)setSessionAttachedView:(UIView *)sessionAttachedView
{
    [self.previewLayer removeFromSuperlayer];
    self.previewLayer = nil;
    
    _sessionAttachedView = sessionAttachedView;
    if(self.recorderInitialized && sessionAttachedView)
    {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        self.previewLayer.bounds = CGRectMake(.0f, .0f, sessionAttachedView.frame.size.width, sessionAttachedView.frame.size.height);
        self.previewLayer.connection.videoOrientation = self.previewVideoOrientation;
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.previewLayer.position = CGPointMake(sessionAttachedView.frame.size.width*.5f, sessionAttachedView.frame.size.height*.5f);
        
        [sessionAttachedView.layer addSublayer:self.previewLayer];
    }
}

- (void)stopSession
{
    [self tearDown];
}


@end
