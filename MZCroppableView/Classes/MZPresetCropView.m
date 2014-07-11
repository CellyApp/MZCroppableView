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

@interface MZPresetCropView()

@property (strong, nonatomic, readwrite) UIBezierPath *cropPath;
@property (weak, nonatomic) MZCropReticleView *reticle;

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
    
    // Default the cropping path to a large square
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(200, 0)];
    [path addLineToPoint:CGPointMake(200, 200)];
    [path addLineToPoint:CGPointMake(0, 200)];
    [path closePath];
    self.cropPath = path;
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

- (void)updateReticleView
{
    if (self.reticle) {
        [self.reticle removeFromSuperview];
    }
    
    MZCropReticleView *reticle = [[MZCropReticleView alloc] initWithPath:self.cropPath];
    CGRect reticleFrame = reticle.frame;
    CGFloat xNudge = (self.bounds.size.width - reticleFrame.size.width)/2;
    CGFloat yNudge = (self.bounds.size.height - reticleFrame.size.height)/2;
    reticleFrame.origin = CGPointMake(xNudge, yNudge);
    [reticle setFrame:reticleFrame];
    [self addSubview:reticle];
    self.reticle = reticle;
    
    [self setNeedsDisplay];
}

#pragma mark - Cropping

- (UIImage *)getCroppedImage
{
//    UIBezierPath *path = [self pathForCropping];
//    UIImage *image = [self.imageView getImageCroppedWithGeneratedPath:path];
    UIImage *image = [self.imageView getImageCroppedWithGeneratedPath:self.cropPath];
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
