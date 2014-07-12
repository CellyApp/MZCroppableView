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

@end
