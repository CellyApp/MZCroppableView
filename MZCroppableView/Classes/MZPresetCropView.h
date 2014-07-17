//
//  MZPresetCropView.h
//  MZCroppableView
//
//  Created by Jeremy Lawrence on 7/9/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import "MZZoomingCropView.h"

/**
 Special subclass of the MZZoomingCropView that gives the user the ability to
 crop an image with a given pre-set crop shape.
 
 The crop shape is determined by the the bezier path object property `cropPath`.
 The crop path is drawn on screen above the image view to show the user how the
 cropped image would look.
 */
@interface MZPresetCropView : MZZoomingCropView

/**
 The path that the crop view uses to crop the image. This path is displayed in a
 reticle view laid out above the imageView.
 */
@property (strong, nonatomic, readonly) UIBezierPath *cropPath;

/**
 Determines whether or not a mask view will be displayed in the area outside of 
 the crop path. By default the value of this property is `YES`. Setting this
 property to `NO` will remove the mask view.
 */
@property (nonatomic) BOOL showMask;

@property (strong, nonatomic) UIColor *reticleColor;

/**
 Updates the cropping reticle view with the given path object.
 
 @param path A closed bezier path that will be used as the cropping shape for 
 the Preset Crop View.
 */
- (void)updateReticleViewWithPath:(UIBezierPath *)path;

@end
