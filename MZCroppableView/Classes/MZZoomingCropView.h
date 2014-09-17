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

/**
 Determines if the image fills the entire Zooming Crop View when it is initially
 set. Defaults to `NO`
 */
@property (nonatomic) BOOL fillView;

/* Adjustable properties */
/**
 The width of the crop path drawn onto the imageView.
 
 This property determines the width that the crop path's line _appears_ to be
 on the device. When drawing begins on the imageView, the actual line width is
 calculated so that it appears to the viewer as the value of the cropLineWidth
 property in the user coordinate space.
 
 Default value of this property is 5.
 */
@property (nonatomic) CGFloat cropLineWidth;
/**
 Maximum zoom scale that limits how large you can scale up the image size.
 
 This doesn't limit the scale of the image's true size, but rather scaling from
 the image's fitting size. So if an image is too large to be displayed at its
 natural size, and is scaled down to fit the crop view, the zooming the user is
 limited to by this property value is relative to the already-scaled-down size.
 The same is true of the `minZoomScale` property.
 
 Default value of this property is 2.
 */
@property (nonatomic) CGFloat maxZoomScale;
/**
 Minimum zoom scale that limits how small you can scale down the image size.
 
 @see minZoomScale for more details on how this property behaves.
 
 Default value of this property is 0.5.
 */
@property (nonatomic) CGFloat minZoomScale;
/**
 Minimum amount of points of the image that must still remain in view. If a
 translation is attempted by the user that would result in the image having
 fewer than this amount of points in either direction, the translation distance
 will be reduced to prevent the image from being pushed too far off-screen.
 
 Default value of this property is 44.
 */
@property (nonatomic) CGFloat translationTolerance;

/**
 Returns the image cropped to the path defined by the user's drawing.
 */
- (UIImage *)getCroppedImage;

- (CGFloat)currentScaleFactor;
- (CGFloat)currentRotationAngle;

@end
