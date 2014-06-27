//
//  MZCroppingImageView.h
//  MZCroppableView
//
//  Created by Jeremy Lawrence on 6/26/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZCroppingImageView;
@protocol MZCroppingImageViewDelegate <NSObject>

@optional
- (void)croppingImageViewDidEndTouches:(MZCroppingImageView *)croppingImageView;

@end

@interface MZCroppingImageView : UIImageView

@property (weak, nonatomic) id<MZCroppingImageViewDelegate> delegate;

- (UIImage *)getCroppedImage;

- (void)clearDrawnPath;

@end
