//
//  DLBImageCropViewController.h
//  DLB
//
//  Created by Matic Oblak on 4/20/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

@import UIKit;

@class DLBImageCropViewController;

@protocol DLBImageCropViewControllerDelegate <NSObject>

- (void)imageCropViewController:(DLBImageCropViewController *)sender finishedWithImage:(UIImage *)outputImage;
- (void)imageCropViewControllerCanceled:(DLBImageCropViewController *)sender;
@end

@interface DLBImageCropViewController : UIViewController

@property (nonatomic, strong) UIImage *inputImage;
@property (nonatomic, weak) id<DLBImageCropViewControllerDelegate> delegate;
@property (nonatomic, strong) UIImage *overlayImage;

@end
