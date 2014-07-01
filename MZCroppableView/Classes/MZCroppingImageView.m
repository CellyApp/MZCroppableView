//
//  MZCroppingImageView.m
//  MZCroppableView
//
//  Created by Jeremy Lawrence on 6/26/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import "MZCroppingImageView.h"
#import "UIImageView+ImageFrame.h"

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

- (UIImage *)getCroppedImage
{
    UIImage *croppedImage = [self.cropView grabCroppedImageFromImageView:self
                                                     displayedImageFrame:[self imageFrame]];
    return croppedImage;
}

- (void)clearDrawnPath
{
    self.cropView = nil;
    [self.cropView setNeedsDisplay];
}

#pragma MZCroppableViewDelegate

- (void)croppableViewDidEndTouches:(MZCroppableView *)view
{
    if ([self.delegate respondsToSelector:@selector(croppingImageViewDidEndTouches:)]) {
        [self.delegate croppingImageViewDidEndTouches:self];
    }
}

@end
