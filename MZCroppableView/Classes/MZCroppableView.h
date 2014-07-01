//
//  MZCroppableView.h
//  MZCroppableView
//
//  Created by macbook on 30/10/2013.
//  Copyright (c) 2013 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZCroppableView;
@protocol MZCroppableViewDelegate <NSObject>

@optional
- (void)touchesBeganOnCroppableView:(MZCroppableView *)croppableView;
- (void)touchesEndedOnCroppableView:(MZCroppableView *)croppableView;

@end

@interface MZCroppableView : UIView

@property (weak, nonatomic) id<MZCroppableViewDelegate> delegate;

@property(nonatomic, strong) UIBezierPath *croppingPath;
@property(nonatomic, strong) UIBezierPath *smoothedPath;
@property(nonatomic, strong) UIColor *lineColor;

- (id)initWithImageView:(UIImageView *)imageView;

+ (CGRect)scaleRespectAspectFromRect1:(CGRect)rect1 toRect2:(CGRect)rect2;

/**
 Creates an image from the given imageView's image and the path drawn in the
 MZCroppableView.
 
 @param imageView  The UIImageView from which the new, cropped image is to be
 generated
 @param imageFrame The frame in which the image is actually displayed, relative
 to the imageView's bounds.
 
 @return An image cropped to the path drawn in the MZCroppableView.
 */
- (UIImage *)grabCroppedImageFromImageView:(UIImageView *)imageView
                       displayedImageFrame:(CGRect)imageFrame;

@end
