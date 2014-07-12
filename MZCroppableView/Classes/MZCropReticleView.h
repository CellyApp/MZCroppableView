//
//  MZCropReticleView.h
//  MZCroppableView
//
//  Created by Jeremy Lawrence on 7/9/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZCropReticleView : UIView

@property (strong, nonatomic) UIBezierPath *cropPath;
@property (nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) UIColor *reticleColor;

- (instancetype)initWithPath:(UIBezierPath *)path;

@end
