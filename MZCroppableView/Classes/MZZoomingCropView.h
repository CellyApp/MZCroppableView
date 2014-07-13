//
//  MZZoomingCropView.h
//  MZCroppableView
//
//  Created by Jeremy Lawrence on 7/3/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZCroppingImageView.h"

@class MZZoomingCropView;
@protocol MZZoomingCropViewDelegate <NSObject>

@optional
- (void)touchesBeganOnZoomingCropView:(MZZoomingCropView *)cropView;
- (void)touchesEndedOnZoomingCropView:(MZZoomingCropView *)cropView;

@end

@interface MZZoomingCropView : UIView

@property (weak, nonatomic) id<MZZoomingCropViewDelegate> delegate;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) MZCroppingImageView *imageView;

@property (nonatomic) CGFloat cropLineWidth;

/**
 Returns the image cropped to the path defined by the user's drawing.
 */
- (UIImage *)getCroppedImage;

- (CGFloat)currentScaleFactor;
- (CGFloat)currentRotationAngle;

@end
