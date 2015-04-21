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
}

- (void)setupScrollView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.inputImage];
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    
    self.scrollView.contentSize = imageView.frame.size;
    
    self.scrollView.maximumZoomScale = 3.0;
    CGSize ratio = CGSizeMake(self.scrollView.frame.size.width/self.scrollView.contentSize.width, self.scrollView.frame.size.height/self.scrollView.contentSize.height);
    self.scrollView.minimumZoomScale = ratio.width>ratio.height?ratio.width:ratio.height;
    
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
    
    CGRect drawRect = CGRectMake(-frame.origin.x, -frame.origin.y, image.size.width, image.size.height);
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
    
    float theScale = 1.0 / self.scrollView.zoomScale;
    visibleRect.origin.x *= theScale;
    visibleRect.origin.y *= theScale;
    visibleRect.size.width *= theScale;
    visibleRect.size.height *= theScale;
    
    return visibleRect;
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

@end
