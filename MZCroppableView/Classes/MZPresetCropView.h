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
 The 
 */
@interface MZPresetCropView : MZZoomingCropView

@property (strong, nonatomic, readonly) UIBezierPath *cropPath;
@property (nonatomic) BOOL showMask;

/**
 Updates the cropping reticle view with the given path object.
 
 @param path A closed bezier path that will be used as the cropping shape for 
 the Preset Crop View.
 */
- (void)updateReticleViewWithPath:(UIBezierPath *)path;

@end
