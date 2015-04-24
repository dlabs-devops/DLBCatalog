//
//  DLBImageCropViewController.m
//  DLB
//
//  Created by Matic Oblak on 4/20/15.
//  Copyright (c) 2015 Matic Oblak. All rights reserved.
//

#import "DLBImageCropViewController.h"

@interface DLBImageCropViewController ()<UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *overlay;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *overlayImageView;

@end

@implementation DLBImageCropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.overlay.exclusiveTouch = NO;
    self.overlay.userInteractionEnabled = NO;
    
    if(self.inputImage)
    {
        [self setupScrollView];
    }
    else
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
    
    self.overlay.layer.borderColor = [UIColor whiteColor].CGColor;
    self.overlay.layer.borderWidth = 1.0f;
    self.overlayImage = self.overlayImage;
    [self.overlay addSubview:self.overlayImageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self view];
    [UIView animateWithDuration:.2 animations:^{
        [self resetScrollView];
    }];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:.2 animations:^{
        [self resetScrollView];
    }];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.overlayImageView.frame = CGRectMake(.0f, .0f, self.overlay.frame.size.width, self.overlay.frame.size.height);
}

- (void)setupScrollView
{
    [self.imageView removeFromSuperview];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.inputImage];
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    
    [self resetScrollView];
}

- (void)resetScrollView
{
    self.scrollView.contentSize = self.inputImage.size;
    
    self.scrollView.maximumZoomScale = 3.0;
    double ratioX = self.scrollView.frame.size.width;
    ratioX /= self.inputImage.size.width;
    double ratioY = self.scrollView.frame.size.height;
    ratioY /= self.inputImage.size.height;
    self.scrollView.minimumZoomScale = (CGFloat)(ratioX>ratioY?ratioX:ratioY);
    
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
    [self.scrollView setContentOffset:CGPointMake((self.scrollView.contentSize.width/2) - (self.scrollView.bounds.size.width/2), (self.scrollView.contentSize.height/2) - (self.scrollView.bounds.size.height/2)) animated:NO];
}

- (IBAction)cancelPressed:(id)sender
{
    [self.delegate imageCropViewControllerCanceled:self];
}
- (IBAction)donePressed:(id)sender
{
    UIImage *image = [self generateCurrentCroppedImage];
    [self.delegate imageCropViewController:self finishedWithImage:image];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (UIImage *)generateCurrentCroppedImage
{
    CGRect visibleRect = [self currentVisibleRect];
    CGRect imageVisibleRect = CGRectMake(visibleRect.origin.x / (self.scrollView.contentSize.width/self.scrollView.zoomScale) * self.inputImage.size.width,
                                         visibleRect.origin.y / (self.scrollView.contentSize.height/self.scrollView.zoomScale) * self.inputImage.size.height,
                                         visibleRect.size.width / (self.scrollView.contentSize.width/self.scrollView.zoomScale) * self.inputImage.size.width,
                                         visibleRect.size.height / (self.scrollView.contentSize.height/self.scrollView.zoomScale) * self.inputImage.size.height);
    UIImage *image = [self croppedImage:self.inputImage inFrame:imageVisibleRect];
    return image;
}

- (UIImage *)croppedImage:(UIImage *)image inFrame:(CGRect)frame {
    
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //    CGRect drawRect = CGRectMake(-frame.origin.x, -frame.origin.y, image.size.width, image.size.height);
    CGRect drawRect = CGRectMake(-frame.origin.x-1.0f, -frame.origin.y-1.0f, image.size.width+1.0f, image.size.height+1.0f);
    CGContextClipToRect(context, CGRectMake(0, 0, frame.size.width, frame.size.height));
    
    [image drawInRect:drawRect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (CGRect)currentVisibleRect
{
    CGRect visibleRect;
    visibleRect.origin = self.scrollView.contentOffset;
    visibleRect.size = self.scrollView.bounds.size;
    
    CGFloat scale = 1.0f / self.scrollView.zoomScale;
    visibleRect.origin.x *= scale;
    visibleRect.origin.y *= scale;
    visibleRect.size.width *= scale;
    visibleRect.size.height *= scale;
    
    return visibleRect;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"point");
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.inputImage = info[UIImagePickerControllerOriginalImage];
    [self setupScrollView];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if(self.inputImage == nil)
    {
        [self.delegate imageCropViewControllerCanceled:self];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)setOverlayImage:(UIImage *)overlayImage
{
    if(overlayImage == nil && self.overlayImageView)
    {
        [self.overlayImageView removeFromSuperview];
        self.overlayImageView = nil;
    }
    else if(overlayImage && self.overlayImageView == nil)
    {
        self.overlayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(.0f, .0f, self.overlay.frame.size.width, self.overlay.frame.size.height)];
        [self.overlay addSubview:self.overlayImageView];
    }
    self.overlayImageView.image = overlayImage;
    _overlayImage = overlayImage;
}

@end
