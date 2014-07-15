//
//  MZCroppingImageView.h
//  MZCroppableView
//
//  Created by Jeremy Lawrence on 6/26/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZCroppableView.h"

@class MZCroppingImageView;
@protocol MZCroppingImageViewDelegate <NSObject>

@optional
- (void)touchesBeganOnCroppingImageView:(MZCroppingImageView *)croppingImageView;
- (void)touchesEndedOnCroppingImageView:(MZCroppingImageView *)croppingImageView;

@end

@interface MZCroppingImageView : UIImageView

@property (weak, nonatomic) id<MZCroppingImageViewDelegate> delegate;
@property (weak, nonatomic) MZCroppableView *cropView;

/**
 Returns the displayed image, cropped to the path drawn by the user onto the
 embedded MZCroppableView overlaid on the imageView.
 
 @return A cropped image, defined by the user-drawn path.
 */
- (UIImage *)getImageCroppedWithDrawnPath;
/**
 Returns the displayed image, cropped to the given path.
 
 @param path   Path to crop the displayed image to.
 @param offset Offset to move the cropping path by when creating the cropped 
 image.
 
 @return A cropped image, defined by the given path and offset.
 */
- (UIImage *)getImageCroppedWithPath:(UIBezierPath *)path reticleOffset:(CGPoint)offset;

- (void)clearDrawnPath;

@end
