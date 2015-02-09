//
//  DLBMediaRecorder.h
//  DLB
//
//  Created by Matic Oblak on 2/9/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

@import AVFoundation;
#import "DLBInternalError.h"

@class DLBMediaRecorder;

@protocol DLBMediaRecorderDelegate <NSObject>

- (void)DLBMediaRecorder:(DLBMediaRecorder *)sender encounteredIssue:(DLBInternalError *)issue;
- (void)DLBMediaRecorder:(DLBMediaRecorder *)sender finishedRecordingAt:(NSString *)path asSuccessful:(BOOL)didSucceed;

@end

@interface DLBMediaRecorder : NSObject

@property (nonatomic, weak) id<DLBMediaRecorderDelegate> delegate;

@property (nonatomic, readonly) BOOL isRecording;

#pragma mark settings
//
// File output path
// Note the output file will always be of type of .mov
//
@property (nonatomic, strong) NSString *outputPath;

//
// maximum video duration
// use .0 for unlimited
//
@property (nonatomic) NSTimeInterval maximumDuration;

//
// video quality
// defaults to AVCaptureSessionPresetMedium
//
@property (nonatomic, strong) NSString *videoCaptureQualityPreset;

//
// includes sound recording
// defaults to YES
//
@property (nonatomic) BOOL allowSoundRecording;

//
// output orientation
// defaults to AVCaptureVideoOrientationLandscapeRight
//
@property (nonatomic) AVCaptureVideoOrientation outputVideoOrientation;

//
// A view that is attached to the session to see the preview
//
@property (nonatomic, strong) UIView *sessionAttachedView;
//
// preview orientation
// defaults to AVCaptureVideoOrientationPortrait
//
@property (nonatomic) AVCaptureVideoOrientation previewVideoOrientation;

//
// Swaps to either front or back camera
// Defaults to back camera (NO)
//
@property (nonatomic) BOOL frontCamera;
@property (nonatomic, readonly) BOOL frontCameraAvailable;
@property (nonatomic, readonly) BOOL backCameraAvailable;

//
// Enable torch
// Defaults to NO
//
@property (nonatomic) BOOL torchEnabled;
@property (nonatomic, readonly) BOOL torchAvailabel;

#pragma mark recording controlls
//
// Initializes the recorder
// beginRecording will call this method if not previously called
//
- (BOOL)initializeRecorder;
//
// Begins recording
//
- (void)beginRecording;
//
// Stops recording
//
- (void)stopRecording;
//
// Stops session
//
- (void)stopSession;

#pragma mark extra
//
// Use this method to refresh the preview layer size
// For instance when the views are layout
//
- (void)refreshPreviewLayer;
//
// Will preinitialize the camera input for faster swapping from front to back
//
- (void)preinitializeVideoInput;

#pragma mark convenience

+ (AVCaptureVideoOrientation)videoOrientationFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

+ (BOOL)userAllowsVideoRecording;
+ (BOOL)userAllowsAudioRecording;

@end
