//
//  MZImageCropper.h
//  MZCroppableView
//
//  Created by Jeremy Lawrence on 7/11/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZImageCropper : NSObject

/**
 Creates a cropped image with the given image and path. The returned image is
 determined by the space filled within the path.
 
 @param imageView     The imageView that is displaying the image to be cropped.
 @param path          The path that defines the crop shape. This path must be 
 closed.
 @param reticleOffset Offset to move the cropping path by when creating the
 cropped image.
 @param drawnPath     Whether or not the path was drawn by the user, or if it
 is a pre-generated path.
 
 @return An image, cropped to the shape determined by the given path.
 */
+ (UIImage *)croppedImageFromImageView:(UIImageView *)imageView withCropPath:(UIBezierPath *)path reticleOffset:(CGPoint)reticleOffset pathIsDrawn:(BOOL)drawnPath;

@end
