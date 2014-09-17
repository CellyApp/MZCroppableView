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

@property (nonatomic) CGFloat fittingScale;
@property (nonatomic) CGFloat lastScale;
@property (nonatomic) CGPoint lastPoint;
@property (nonatomic) BOOL needsCentering;

@end

@implementation MZZoomingCropView

- (void)_commonInitializer

{
    self.fillView = NO;
    
    // Set scale-related constraints to defaults
    self.fittingScale = 1.0f;
    self.maxZoomScale = 2.0f;
    self.minZoomScale = 0.5f;
    
    // Translation constraints
    self.translationTolerance = 44.f;
    
    self.lastScale = 1.0f;
    self.lastPoint = CGPointZero;
    self.needsCentering = YES;
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
    
    [self initialImageCentering];
}

- (void)initialImageCentering
{
    CGFloat fittingScale = 1;
    if (self.fillView) {
        // Scale imageView to fill the cropping view
        fittingScale = MAX((self.bounds.size.width/self.imageView.image.size.width),
                           (self.bounds.size.height/self.imageView.image.size.height));
        if (fittingScale < 1) {
            self.imageView.transform = CGAffineTransformScale(self.imageView.transform, fittingScale, fittingScale);
        }
    }
    else {
        // Scale imageview to fit the cropping view
        fittingScale = MIN((self.bounds.size.width/self.imageView.image.size.width),
                           (self.bounds.size.height/self.imageView.image.size.height));
        if (fittingScale < 1) {
            self.imageView.transform = CGAffineTransformScale(self.imageView.transform, fittingScale, fittingScale);
        }
    }
    self.fittingScale = fittingScale;
    // Move the image to the center of the view with affine transform to log transformation
    [self.imageView setFrame:(CGRect){CGPointZero, self.imageView.frame.size}];
    CGFloat centeredX = (self.bounds.size.width - self.imageView.frame.size.width)/2;
    CGFloat centeredY = (self.bounds.size.height - self.imageView.frame.size.height)/2;
    self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, centeredX/fittingScale, centeredY/fittingScale);
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

// scale and rotation transforms are applied relative to the layer's anchor point
// this method moves a gesture recognizer's view's anchor point between the user's fingers
- (void)adjustAnchorPointForGestureRecognizer:(UIPinchGestureRecognizer *)sender {
    
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.lastScale = 1.0;
        self.lastPoint = [sender locationInView:self.imageView];
    }
    self.lastScale = sender.scale;
    
    // Translate
    CGPoint point = [sender locationInView:self.imageView];
    self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, point.x-self.lastPoint.x, point.y - self.lastPoint.y);
    self.lastPoint = [sender locationInView:self.imageView];
    
    
    //    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    //        UIView *piece = self.imageView;
    //        CGPoint locationInView = [gestureRecognizer locationInView:piece];
    //        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
    //
    ////        piece.layer.anchorPoint = locationInView;//CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
    ////        piece.center = locationInSuperview;
    //    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)scaleImageView:(UIPinchGestureRecognizer *)gesture
{
    if(gesture.state==UIGestureRecognizerStateEnded) {
        self.needsCentering = YES;
    } else if(gesture.state==UIGestureRecognizerStateBegan) {
        [self adjustAnchorPointForGestureRecognizer:gesture];
    } else if(true || self.needsCentering) {
        [self adjustAnchorPointForGestureRecognizer:gesture];
        self.needsCentering = NO;
    }
    CGFloat scale = gesture.scale;
    
    CGFloat realScale = [self currentScaleFactor];
    BOOL isntTooBig = scale > 1 && (realScale < self.fittingScale * self.maxZoomScale);
    BOOL isntTooSmall = scale < 1 && (realScale > self.fittingScale * self.minZoomScale);
    if (isntTooBig || isntTooSmall) {
        self.imageView.transform = CGAffineTransformScale(self.imageView.transform, scale, scale);
    }
    
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
    
    CGRect frame = self.imageView.frame;
    BOOL isOverLeft = frame.origin.x < 0;
    BOOL isOverRight = frame.origin.x + frame.size.width > self.bounds.size.width;
    BOOL isOverTop = frame.origin.y < 0;
    BOOL isOverBottom = frame.origin.y + frame.size.height > self.bounds.size.height;
    if (isOverLeft && !isOverRight) {
        // origin.x will be negative, add to frame width to find leftover image
        CGFloat visiblePixels = frame.size.width + frame.origin.x;
        if (visiblePixels + translation.x < self.translationTolerance) {
            // translation will result in too few visible pixels to manipulate
            // Instead of actual translation from gesture, move max amount allowed by tolerance
            translation.x = -(visiblePixels - self.translationTolerance);
        }
    }
    if (isOverRight && !isOverLeft) {
        // difference between bounds width and frame.origin.x gives leftover image
        CGFloat visiblePixels = self.bounds.size.width - frame.origin.x;
        if (visiblePixels - translation.x < self.translationTolerance) {
            translation.x = visiblePixels - self.translationTolerance;
        }
    }
    if (isOverTop && !isOverBottom) {
        // origin.y negative, add to frame height to find leftover image
        CGFloat visiblePixels = frame.size.height + frame.origin.y;
        if (visiblePixels + translation.y < self.translationTolerance) {
            translation.y = -(visiblePixels - self.translationTolerance);
        }
    }
    if (isOverBottom && !isOverTop) {
        // difference between bounds height and frame.origin.y gives leftover image
        CGFloat visiblePixels = self.bounds.size.height - frame.origin.y;
        if (visiblePixels - translation.y < self.translationTolerance) {
            translation.y = visiblePixels - self.translationTolerance;
        }
    }
    
    self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, translation.x, translation.y);
    
    [gesture setTranslation:CGPointZero inView:self];
}

#pragma mark - Image cropping

- (UIImage *)getCroppedImage
{
    // Abstract, implement in subclass
    return [UIImage new];
}

#pragma mark - MZCroppingImageViewDelegate

- (void)touchesBeganOnCroppingImageView:(MZCroppingImageView *)croppingImageView
{
    CGFloat zoomScale = [self currentScaleFactor];
    CGFloat containerWidth = self.bounds.size.width;
    CGFloat desiredLine = self.cropLineWidth;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat newLineWidth = (containerWidth / zoomScale) * (desiredLine/screenWidth);
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
