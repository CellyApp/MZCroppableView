//
//  MZCroppingScrollView.m
//  MZCroppableView
//
//  Created by Jeremy Lawrence on 6/30/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import "MZCroppingScrollView.h"

@interface MZCroppingScrollView()
<MZCroppingImageViewDelegate,
UIGestureRecognizerDelegate>

@end

@implementation MZCroppingScrollView

- (void)_commonInitializer
{
    self.scrollsToTop = NO;
    self.cropLineWidth = 5.0f;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _commonInitializer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _commonInitializer];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    // Reset the image
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    
    [self.imageContainer removeFromSuperview];
    self.imageContainer = nil;
    
    // Create the cropping image view with the image
    MZCroppingImageView *imageView = [[MZCroppingImageView alloc] initWithImage:image];
    [imageView setDelegate:self];
    self.imageView = imageView;
    
    UIView *container = [[UIView alloc] initWithFrame:imageView.frame];
    NSLog(@"Creating container with frame %@", NSStringFromCGRect(imageView.frame));
    self.imageContainer = container;
    [container addSubview:imageView];
    [self addSubview:container];
    
    // Add rotation gesture to imageView
    UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateImageView:)];
    [rotate setDelegate:self];
    [self addGestureRecognizer:rotate];
    
    // Set content size of scroll view to fit imageView
    self.contentSize = container.frame.size;
    
    // Set scale to fit image in bounds
    CGFloat fittingScale = MIN((self.bounds.size.width/image.size.width),
                               (self.bounds.size.height/image.size.height));
    [self setMaximumZoomScale:2];
    [self setMinimumZoomScale:fittingScale];
    [self setZoomScale:fittingScale];
    
    [self setCropEnabled:NO];
    [self centerContents];
}

- (void)setCropEnabled:(BOOL)cropEnabled
{
    _cropEnabled = cropEnabled;
    [self setScrollEnabled:!cropEnabled];
    [self.imageView setUserInteractionEnabled:cropEnabled];
}

- (void)centerContents
{
    CGSize boundsSize = self.bounds.size;
    CGRect contentsFrame = self.imageContainer.frame;
    
    CGFloat angle = [self angleOfImageInRadians];
    CGRect displayedImageRect = [self.imageContainer convertRect:self.imageView.bounds toView:self];
    CGFloat displayedWidth = ABS((displayedImageRect.size.height * sin(angle))) + ABS((displayedImageRect.size.width * cos(angle)));
    CGFloat displayedHeight = ABS((displayedImageRect.size.height * cos(angle))) + ABS((displayedImageRect.size.width * sin(angle)));
    
    // If width of image is smaller than scroll view bounds, move the image container to center
    if (contentsFrame.size.width < boundsSize.width
        || (angle != 0 && displayedWidth > boundsSize.width)) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    }
    // If image width larger than screen, leave horiz alone
    else {
        contentsFrame.origin.x = 0.0f;
    }
    // If height of image is smaller than scroll view bounds, move the image container to center
    if (contentsFrame.size.height < boundsSize.height
        || (angle != 0 && displayedHeight > boundsSize.height)) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    }
    // If image height is larger than screen, leave vert alone
    else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageContainer.frame = contentsFrame;
}

- (UIView *)viewForZooming
{
    return self.imageContainer;
}
#pragma mark - Public

- (UIImage *)getCroppedImage
{
    return [self.imageView getImageCroppedWithDrawnPath];
}

#pragma mark - Gestures

- (void)rotateImageView:(UIRotationGestureRecognizer *)sender
{
    CGFloat angle = sender.rotation;
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, angle);
    sender.rotation = 0.0;
    
    [self adjustContainerView];
    [self centerContents];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)adjustContainerView
{
    // Resize the container view to fit the image witihin it
    CGRect imageViewFrame = [self.imageContainer convertRect:self.imageView.frame toView:self];
    CGRect newFrame = self.imageContainer.frame;
    newFrame.size = imageViewFrame.size;
    [self.imageContainer setFrame:newFrame];
    
    // Center image in the container
    CGPoint containerCenter = CGPointMake(self.imageContainer.bounds.size.width/2, self.imageContainer.bounds.size.height/2);
    [self.imageView setCenter:containerCenter];
    
    // Reset content size of scroll view
    self.contentSize = self.imageContainer.frame.size;
}

- (CGFloat)angleOfImageInRadians
{
    CGFloat radians = atan2f(self.imageView.transform.b, self.imageView.transform.a);
    return radians;
}

- (CGFloat)angleOfImageInDegrees
{
    CGFloat degrees = [self angleOfImageInRadians] * (180 / M_PI);
    
    return degrees;
}

#pragma MZCroppingImageViewDelegate

- (void)touchesBeganOnCroppingImageView:(MZCroppingImageView *)croppingImageView
{
    NSLog(@"Setting line width");
    CGFloat zoomScale = self.zoomScale;
    CGFloat containerWidth = self.bounds.size.width;
    CGFloat desiredLine = self.cropLineWidth;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat newLineWidth = (containerWidth / zoomScale) * (desiredLine/screenWidth);
    NSLog(@"New line width: %f", newLineWidth);
    [self.imageView.cropView.croppingPath setLineWidth:newLineWidth];
}

- (void)touchesEndedOnCroppingImageView:(MZCroppingImageView *)croppingImageView
{
    if ([self.cropDelegate respondsToSelector:@selector(croppingScrollViewDidEndTouches:)]) {
        [self.cropDelegate croppingScrollViewDidEndTouches:self];
    }
}

@end
