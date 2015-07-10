//
//  BaseMediarecorderViewController.m
//  DLB
//
//  Created by Matic Oblak on 2/9/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "BaseMediarecorderViewController.h"
#import "DLBMediaRecorder.h"
#import "DLBVideoConverter.h"
@import MediaPlayer;

@interface BaseMediarecorderViewController ()<DLBMediaRecorderDelegate, DLBVideoConverterDelegate>

@property (weak, nonatomic) IBOutlet UIView *videoPannel;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *frontBackButton;
@property (weak, nonatomic) IBOutlet UIButton *torchOnButton;

@property (nonatomic, strong) DLBVideoConverter *converter;

@property (nonatomic) BOOL convertVideo;

@property (nonatomic, strong) DLBMediaRecorder *recorder;

@end

@implementation BaseMediarecorderViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.recorder = [[DLBMediaRecorder alloc] init];
    self.recorder.delegate = self;
    [self.recorder preinitializeVideoInput];
    self.recorder.sessionAttachedView = self.videoPannel;
    [self.recorder initializeRecorder];
    [self refreshButtons];
    
    self.convertVideo = YES;
}

- (void)refreshButtons
{
    NSFileManager *manager = [NSFileManager defaultManager];
    self.playButton.hidden = [manager fileExistsAtPath:self.recorder.outputPath]==NO;
    
    self.frontBackButton.enabled = self.recorder.frontCameraAvailable;
    [self.frontBackButton setTitle:self.recorder.frontCamera?@"Front camera":@"Back camera" forState:UIControlStateNormal];
    
    [self.torchOnButton setTitle:self.recorder.torchEnabled?@"Torch on":@"Torch off" forState:UIControlStateNormal];
}

- (IBAction)playVideoPressed:(id)sender
{
    MPMoviePlayerViewController *controller = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:self.recorder.outputPath]];
    [self presentMoviePlayerViewControllerAnimated:controller];
    [controller.moviePlayer play];
}

- (IBAction)startStopPressed:(id)sender
{
    if(self.recorder.isRecording)
    {
        [self.recorder stopRecording];
        [self.startStopButton setTitle:@"Start recording" forState:UIControlStateNormal];
    }
    else
    {
        self.recorder.outputVideoOrientation = [DLBMediaRecorder videoOrientationFromInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
        [self.recorder beginRecording];
        [self.startStopButton setTitle:@"Stop recording" forState:UIControlStateNormal];
    }
}

- (void)DLBMediaRecorder:(DLBMediaRecorder *)sender encounteredIssue:(DLBInternalError *)issue
{
    NSLog(@"Error occured: %@", issue.internalDescription);
}


- (void)DLBMediaRecorder:(DLBMediaRecorder *)sender finishedRecordingAt:(NSString *)path asSuccessful:(BOOL)didSucceed
{
    NSLog(@"Finished recording %@", didSucceed?@"successfully":@"failed");
    [self refreshButtons];
    
    
    if(self.convertVideo)
    {
        NSLog(@"Starting to resample");
        DLBVideoConverter *converter = [[DLBVideoConverter alloc] init];
        converter.inputURL = [NSURL fileURLWithPath:path];
        converter.outputURL = [NSURL fileURLWithPath:[[path stringByDeletingPathExtension] stringByAppendingPathExtension:@"mp4"]];
        converter.outputVideoSize = CGSizeMake(360.0f, 640.0f); // 360,640
        self.converter = converter;
        converter.delegate = self;
        [converter resampleVideo];
    }
}

- (void)videoConverter:(DLBVideoConverter *)sender finishedConversionTo:(NSURL *)outputPath
{
    MPMoviePlayerViewController *controller = [[MPMoviePlayerViewController alloc] initWithContentURL:outputPath];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.recorder refreshPreviewLayer];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {
         self.recorder.previewVideoOrientation = [DLBMediaRecorder videoOrientationFromInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
         [self.recorder refreshPreviewLayer];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {
         
    }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (IBAction)torchPressed:(id)sender
{
    self.recorder.torchEnabled = !self.recorder.torchEnabled;
    [self refreshButtons];
}
- (IBAction)frontBackPressed:(id)sender
{
    self.recorder.frontCamera = !self.recorder.frontCamera;
    [self refreshButtons];
}

@end
