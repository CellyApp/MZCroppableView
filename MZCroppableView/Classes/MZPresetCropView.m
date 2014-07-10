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
    
    CGRect pathRect = CGRectMake(0, 0, 150, 150);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:pathRect];
    self.cropPath = path;
    
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
    UIBezierPath *path = [self pathForCropping];
    UIImage *image = [self.imageView getImageCroppedWithGeneratedPath:path];
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
