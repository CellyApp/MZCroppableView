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

- (UIImage *)getCroppedImage;

- (void)clearDrawnPath;

@end
