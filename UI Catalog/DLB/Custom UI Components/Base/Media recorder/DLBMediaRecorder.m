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
@property (nonatomic, strong) AVCaptureDeviceInput *frontVideoInputDevice; // cache
@property (nonatomic, strong) AVCaptureDeviceInput *backVideoInputDevice; // cache
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

- (void)preinitializeVideoInput
{
    NSError *error;
    
    self.backVideoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:&error];
    if(error)
    {
        [self.delegate DLBMediaRecorder:self encounteredIssue:[[DLBInternalError alloc] initAsWarning:@"Unable to generate back video device" additionalInfo:error.localizedDescription]];
        self.backVideoInputDevice = nil;
    }
    
    error = nil;
    AVCaptureDevice *frontDevice = [self frontCameraDevice];
    if(frontDevice)
    {
        self.frontVideoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:frontDevice error:&error];
    }
    if(error)
    {
        [self.delegate DLBMediaRecorder:self encounteredIssue:[[DLBInternalError alloc] initAsWarning:@"Unable to generate front video device" additionalInfo:error.localizedDescription]];
        self.frontVideoInputDevice = nil;
    }
}

- (AVCaptureDeviceInput *)currentVideoInput
{
    if(self.frontCamera && self.frontVideoInputDevice)
    {
        return self.frontVideoInputDevice;
    }
    else
    {
        return self.backVideoInputDevice;
    }
}

- (BOOL)attachVideoDevice
{
    self.videoInputDevice = [self currentVideoInput];
    
    NSError *videoError;
    if(self.videoInputDevice == nil)
    {
        AVCaptureDevice *videoDevice = nil;
        if(self.frontCamera && self.frontCameraAvailable)
        {
            videoDevice = [self frontCameraDevice];
        }
        else
        {
            videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        }
        self.videoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&videoError];
    }
    
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

- (void)setOutputVideoOrientation:(AVCaptureVideoOrientation)outputVideoOrientation
{
    _outputVideoOrientation = outputVideoOrientation;
    if(self.recorderInitialized)
    {
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
    }
}

- (void)tearDown
{
    [self.movieFileOutput stopRecording];
    [self.captureSession stopRunning];
    self.captureSession = nil;
    
    self.movieFileOutput = nil;
    
    self.frontVideoInputDevice = nil;
    self.backVideoInputDevice = nil;
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
    [self refreshTorchState];
    return toReturn;
}

#pragma mark front camera

- (AVCaptureDevice *)frontCameraDevice {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}

- (BOOL)frontCameraAvailable
{
    return [self frontCameraDevice] != nil;
}

- (void)setFrontCamera:(BOOL)frontCamera
{
    if(frontCamera != _frontCamera)
    {
        if(frontCamera)
        {
            if([self frontCameraAvailable])
            {
                if(self.recorderInitialized)
                {
                    [self.captureSession beginConfiguration];
                    [self.captureSession removeInput:self.videoInputDevice];
                    [self setTorchEnabled:NO onDevice:self.videoInputDevice.device];
                    _frontCamera = YES;
                    [self attachVideoDevice];
                    [self.captureSession commitConfiguration];
                    [self refreshTorchState];
                }
                else
                {
                    _frontCamera = YES;
                }
            }
            else
            {
                [self.delegate DLBMediaRecorder:self encounteredIssue:[[DLBInternalError alloc] initAsWarning:@"Front camera is not available"]];
                _frontCamera = NO;
            }
        }
        else
        {
            if(self.recorderInitialized)
            {
                [self.captureSession beginConfiguration];
                [self.captureSession removeInput:self.videoInputDevice];
                [self setTorchEnabled:NO onDevice:self.videoInputDevice.device];
                _frontCamera = NO;
                [self attachVideoDevice];
                [self.captureSession commitConfiguration];
                [self refreshTorchState];
            }
            else
            {
                _frontCamera = NO;
            }
        }
    }
}

#pragma mark torch

- (BOOL)isTorchAvailabel
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    NSMutableArray *torchDevices = [[NSMutableArray alloc] init];
    
    for (AVCaptureDevice *device in devices) {
        if ([device hasTorch]) {
            [torchDevices addObject:device];
        }
    }
    
    return ([torchDevices count] > 0);
}

- (void)setTorchEnabled:(BOOL)torchEnabled
{
    _torchEnabled = torchEnabled;
    [self setTorchEnabled:torchEnabled onDevice:self.videoInputDevice.device];
}

- (void)refreshTorchState
{
    [self setTorchEnabled:self.torchEnabled onDevice:self.videoInputDevice.device];
    if(self.frontVideoInputDevice != self.videoInputDevice)
    {
        [self setTorchEnabled:NO onDevice:self.frontVideoInputDevice.device];
    }
    if(self.backVideoInputDevice != self.videoInputDevice)
    {
        [self setTorchEnabled:NO onDevice:self.backVideoInputDevice.device];
    }
    
}

- (void)setTorchEnabled:(BOOL)torchEnabled onDevice:(AVCaptureDevice *)device
{
    if([device hasTorch])
    {
        NSError *configError;
        BOOL didLock = [device lockForConfiguration:&configError];
        if(didLock)
        {
            [device setTorchMode:torchEnabled?AVCaptureTorchModeOn:AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
        else
        {
            [self.delegate DLBMediaRecorder:self encounteredIssue:[[DLBInternalError alloc] initAsError:@"Failed to lock video device to enable torch" additionalInfo:configError.localizedDescription]];
        }
    }
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

- (void)stopSession
{
    [self tearDown];
}

#pragma mark preview

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

- (void)refreshPreviewLayer
{
    self.previewLayer.connection.videoOrientation = self.previewVideoOrientation;
    self.previewLayer.bounds = CGRectMake(.0f, .0f, self.sessionAttachedView.frame.size.width, self.sessionAttachedView.frame.size.height);
    self.previewLayer.position = CGPointMake(self.sessionAttachedView.frame.size.width*.5f, self.sessionAttachedView.frame.size.height*.5f);
}


#pragma mark - convenience

+ (AVCaptureVideoOrientation)videoOrientationFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            return AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        case UIInterfaceOrientationUnknown:
            return AVCaptureVideoOrientationPortrait;
            break;
    }
}

@end
