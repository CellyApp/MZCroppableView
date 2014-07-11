//
//  MZImageCropper.h
//  MZCroppableView
//
//  Created by Jeremy Lawrence on 7/11/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZImageCropper : NSObject

+ (UIImage *)croppedImageFromImageView:(UIImageView *)imageView withCropPath:(UIBezierPath *)path reticleOffset:(CGPoint)reticleOffset;

@end
