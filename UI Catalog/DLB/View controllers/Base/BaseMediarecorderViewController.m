//
//  BaseMediarecorderViewController.m
//  DLB
//
//  Created by Matic Oblak on 2/9/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "BaseMediarecorderViewController.h"
#import "DLBMediaRecorder.h"

@interface BaseMediarecorderViewController ()<DLBMediaRecorderDelegate>

@property (weak, nonatomic) IBOutlet UIView *videoPannel;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;

@property (nonatomic, strong) DLBMediaRecorder *recorder;

@end

@implementation BaseMediarecorderViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.recorder = [[DLBMediaRecorder alloc] init];
    self.recorder.delegate = self;
    self.recorder.sessionAttachedView = self.videoPannel;
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
}

@end
