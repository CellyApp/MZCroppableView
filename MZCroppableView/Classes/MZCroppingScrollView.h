//
//  MZCroppingScrollView.h
//  MZCroppableView
//
//  Created by Jeremy Lawrence on 6/30/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZCroppingImageView.h"

@class MZCroppingScrollView;
@protocol MZCroppingScrollViewDelegate <NSObject>

@optional
- (void)croppingScrollViewDidEndTouches:(MZCroppingScrollView *)scrollView;

@end

@interface MZCroppingScrollView : UIScrollView

/**
 A delegate that handles messages from the cropping scrollView related to 
 cropping actions.
 
 This is not to be confused with the scrollView's delegate property.
 */
@property (weak, nonatomic) id<MZCroppingScrollViewDelegate> cropDelegate;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) UIView *imageContainer;
@property (weak, nonatomic) MZCroppingImageView *imageView;
@property (nonatomic) CGFloat cropLineWidth;

@property (nonatomic, getter = isCropEnabled) BOOL cropEnabled;

/**
 Returns the image cropped to the path defined by the user's drawing.
 */
- (UIImage *)getCroppedImage;

- (void)centerContents;

- (UIView *)viewForZooming;

@end
