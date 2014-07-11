//
//  MZZoomingCropView.m
//  MZCroppableView
//
//  Created by Jeremy Lawrence on 7/3/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import "MZZoomingCropView.h"
#import "UIImage+Rotation.h"

@interface MZZoomingCropView()
<MZCroppingImageViewDelegate,
UIGestureRecognizerDelegate>

@property CGFloat scale;
@end

@implementation MZZoomingCropView

- (void)_commonInitializer

{
    self.scale = 1;
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImageView:)];
    [pinch setDelegate:self];
    [self addGestureRecognizer:pinch];
    
    UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateImageView:)];
    [rotate setDelegate:self];
    [self addGestureRecognizer:rotate];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(translateImageView:)];
    [rotate setDelegate:self];
    [self addGestureRecognizer:pan];
    
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

- (instancetype)initWithImage:(UIImage *)image
{
    CGRect frame = { CGPointMake(0, 0), image.size };
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInitializer];
        [self setImage:image];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    // Clean up previous imageView
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    
    MZCroppingImageView *imageView = [[MZCroppingImageView alloc] initWithImage:image];
    [imageView setDelegate:self];
    [self addSubview:imageView];
    self.imageView = imageView;
    
    self.cropEnabled = NO;
    [self initialImageCentering];
}

- (void)initialImageCentering
{
    // Scale imageview to fit the cropping view
    CGFloat fittingScale = MIN((self.bounds.size.width/self.imageView.image.size.width),
                               (self.bounds.size.height/self.imageView.image.size.height));
    if (fittingScale < 1) {
//        self.imageView.transform = CGAffineTransformScale(self.imageView.transform, fittingScale, fittingScale);
    }
    
    // Move the image to the center of the view with affine transform to log transformation
    [self.imageView setFrame:(CGRect){CGPointZero, self.imageView.frame.size}];
    CGFloat centeredX = (self.bounds.size.width - self.imageView.frame.size.width)/2;
    CGFloat centeredY = (self.bounds.size.height - self.imageView.frame.size.height)/2;
//    self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, centeredX/fittingScale, centeredY/fittingScale);
//    NSLog(@"imageview transform %@", NSStringFromCGAffineTransform(self.imageView.transform));
}

- (CGFloat)currentScaleFactor
{
    CGFloat scaleFactor = sqrt(pow(self.imageView.transform.a,2) + pow(self.imageView.transform.c,2));
    return scaleFactor;
}

- (CGFloat)currentRotationAngle
{
    CGFloat angle = atan2(self.imageView.transform.b, self.imageView.transform.a);
    return angle;
}

#pragma mark - Gestures

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)scaleImageView:(UIPinchGestureRecognizer *)gesture
{
    CGFloat scale = gesture.scale;
//    self.scale = self.scale*scale;
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, scale, scale);

    gesture.scale = 1.0;
}

- (void)rotateImageView:(UIRotationGestureRecognizer *)gesture
{
    CGFloat angle = gesture.rotation;
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, angle);
    gesture.rotation = 0.0;
}

- (void)translateImageView:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:self];
    
    translation.x *= 1/[self currentScaleFactor];
    translation.y *= 1/[self currentScaleFactor];
    self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, translation.x, translation.y);

    [gesture setTranslation:CGPointZero inView:self];
    
    NSLog(@"Image: %@", NSStringFromCGAffineTransform(self.imageView.transform));
}

#pragma mark - Image cropping

- (UIImage *)getCroppedImage
{
    UIImage *image = [self.imageView getCroppedImage];
    UIImage *rotated = [image imageRotatedByRadians:[self currentRotationAngle]];
    return rotated;
}

- (void)setCropEnabled:(BOOL)cropEnabled
{
    _cropEnabled = cropEnabled;
    NSArray *gestures = self.gestureRecognizers;
    for (UIGestureRecognizer *gesture in gestures) {
        [gesture setEnabled:!cropEnabled];
    }
    [self.imageView setUserInteractionEnabled:cropEnabled];
}

#pragma mark - MZCroppingImageViewDelegate

- (void)touchesBeganOnCroppingImageView:(MZCroppingImageView *)croppingImageView
{
    NSLog(@"Setting line width");
    CGFloat zoomScale = [self currentScaleFactor];
    CGFloat containerWidth = self.bounds.size.width;
    CGFloat desiredLine = self.cropLineWidth;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat newLineWidth = (containerWidth / zoomScale) * (desiredLine/screenWidth);
    NSLog(@"New line width: %f", newLineWidth);
    [self.imageView.cropView.croppingPath setLineWidth:newLineWidth];

    if ([self.delegate respondsToSelector:@selector(touchesBeganOnZoomingCropView:)]) {
        [self.delegate touchesBeganOnZoomingCropView:self];
    }
}

- (void)touchesEndedOnCroppingImageView:(MZCroppingImageView *)croppingImageView
{
    if ([self.delegate respondsToSelector:@selector(touchesEndedOnZoomingCropView:)]) {
        [self.delegate touchesEndedOnZoomingCropView:self];
    }
}

@end
