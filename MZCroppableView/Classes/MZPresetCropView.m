//
//  MZPresetCropView.m
//  MZCroppableView
//
//  Created by Jeremy Lawrence on 7/9/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import "MZPresetCropView.h"
#import "UIImage+Rotation.h"
#import "MZCropReticleView.h"
#import "MZMaskView.h"


@interface MZPresetCropView()

@property (strong, nonatomic, readwrite) UIBezierPath *cropPath;
@property (weak, nonatomic) MZCropReticleView *reticle;
@property (weak, nonatomic) MZMaskView *maskView;

@end

@implementation MZPresetCropView

- (void)__commonInitializer
{
    // Remove the rotation gesture because it's problematic right now JYL 6/9/14
    NSMutableArray *removedGestures = [NSMutableArray new];
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        if ([gesture isKindOfClass:[UIRotationGestureRecognizer class]]) {
            [removedGestures addObject:gesture];
        }
    }
    for (UIGestureRecognizer *rotate in removedGestures) {
        [self removeGestureRecognizer:rotate];
    }
    
    self.opaque = NO;
    self.showMask = YES;
    self.reticleColor = [UIColor redColor];
//    self.backgroundColor = [UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self __commonInitializer];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self __commonInitializer];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    
    [self updateReticleView];
}

#pragma mark - Reticle management

- (void)updateReticleViewWithPath:(UIBezierPath *)path
{
    self.cropPath = path;
    [self updateReticleView];
}

- (void)setReticleColor:(UIColor *)reticleColor
{
    _reticleColor = reticleColor;
    [self updateReticleView];
}

- (void)updateReticleView
{
    if (self.reticle) {
        [self.reticle removeFromSuperview];
    }
    if (self.maskView) {
        [self.maskView removeFromSuperview];
    }
    
    MZCropReticleView *reticle = [[MZCropReticleView alloc] initWithPath:self.cropPath];
    CGRect reticleFrame = reticle.frame;
    reticleFrame.size.width = reticleFrame.size.width;
    reticleFrame.size.height = reticleFrame.size.height;
    CGFloat xNudge = (self.bounds.size.width - reticleFrame.size.width)/2;
    CGFloat yNudge = (self.bounds.size.height - reticleFrame.size.height)/2;
    reticleFrame.origin = CGPointMake(xNudge, yNudge);

    [reticle setFrame:reticleFrame];
    reticle.reticleColor = self.reticleColor;
    
    if (self.showMask) {
        MZMaskView *maskView = [[MZMaskView alloc] initWithFrame:self.bounds andPath:self.cropPath andReticleFrame:reticleFrame];
        [self addSubview:maskView];
        self.maskView = maskView;
    }
    
    [self addSubview:reticle];
    self.reticle = reticle;
    
    [self setNeedsDisplay];
}

- (void)setShowMask:(BOOL)showMask
{
    _showMask = showMask;
    if (!showMask) {
        [self.maskView removeFromSuperview];
    }
}

#pragma mark - Cropping

- (UIImage *)getCroppedImage
{
    UIImage *image = [UIImage new];
    if (!self.cropPath) {
        // If there is no crop path chosen, use the bounds of the crop view
        UIBezierPath *boundsPath = [UIBezierPath bezierPathWithRect:self.bounds];
        image = [self.imageView getImageCroppedWithPath:boundsPath
                                          reticleOffset:CGPointZero];
    }
    else {
        image = [self.imageView getImageCroppedWithPath:self.cropPath
                                          reticleOffset:self.reticle.frame.origin];
    }
    return image;
}

- (UIBezierPath *)pathForCropping
{
    UIBezierPath *path = [self.cropPath copy];
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // Find where the reticle is in the
    CGPoint newOrigin = [self.imageView convertPoint:self.reticle.frame.origin fromView:self];
    
    transform = CGAffineTransformTranslate(transform, newOrigin.x, newOrigin.y);
    transform = CGAffineTransformScale(transform, 1/[self currentScaleFactor], 1/[self currentScaleFactor]);
    [path applyTransform:transform];

    return path;
}

@end
