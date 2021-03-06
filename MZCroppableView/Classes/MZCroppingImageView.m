//
//  MZCroppingImageView.m
//  MZCroppableView
//
//  Created by Jeremy Lawrence on 6/26/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import "MZCroppingImageView.h"
#import "UIImageView+ImageFrame.h"
#import "MZImageCropper.h"
#import "UIBezierPath-Smoothing.h"

@interface MZCroppingImageView()
<MZCroppableViewDelegate>

@end

@implementation MZCroppingImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    
    if (self.cropView) {
        [self.cropView removeFromSuperview];
        self.cropView = nil;
    }
    
    [self setContentMode:UIViewContentModeScaleAspectFit];
    MZCroppableView *cropView = [[MZCroppableView alloc] initWithFrame:[self imageFrame]];
    [cropView setDelegate:self];
    [self insertSubview:cropView atIndex:0];
    self.cropView = cropView;
    [self setUserInteractionEnabled:YES]; // Required to allow touch to cropView
}

- (UIImage *)getImageCroppedWithDrawnPath
{
    // Close path and smooth for cropping
    UIBezierPath *smoothedPath = self.cropView.croppingPath;
    [smoothedPath closePath];
    smoothedPath = [smoothedPath smoothedPathByInterpolation];
    UIImage *croppedImage = [MZImageCropper croppedImageFromImageView:self
                                                         withCropPath:smoothedPath
                                                        reticleOffset:CGPointZero
                                                          pathIsDrawn:YES];
    return croppedImage;
}

- (UIImage *)getImageCroppedWithPath:(UIBezierPath *)path reticleOffset:(CGPoint)offset
{
    self.cropView.croppingPath = path;
    UIImage *croppedImage = [MZImageCropper croppedImageFromImageView:self
                                                        withCropPath:path
                                                       reticleOffset:offset
                                                          pathIsDrawn:NO];
    return croppedImage;
}

- (void)clearDrawnPath
{
    self.cropView = nil;
    [self.cropView setNeedsDisplay];
}

#pragma MZCroppableViewDelegate

- (void)touchesBeganOnCroppableView:(MZCroppableView *)croppableView
{
    if ([self.delegate respondsToSelector:@selector(touchesBeganOnCroppingImageView:)]) {
        [self.delegate touchesBeganOnCroppingImageView:self];
    }
}

- (void)touchesEndedOnCroppableView:(MZCroppableView *)view
{
    if ([self.delegate respondsToSelector:@selector(touchesEndedOnCroppingImageView:)]) {
        [self.delegate touchesEndedOnCroppingImageView:self];
    }
}

@end
