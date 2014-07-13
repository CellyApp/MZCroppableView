//
//  MZDrawingCropView.m
//  MZCroppableView
//
//  Created by Jeremy Lawrence on 7/12/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import "MZDrawingCropView.h"
#import "UIImage+Rotation.h"

@implementation MZDrawingCropView

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
    
    self.cropEnabled = NO;
}

- (UIImage *)getCroppedImage
{
    UIImage *image = [self.imageView getImageCroppedWithDrawnPath];
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

@end
