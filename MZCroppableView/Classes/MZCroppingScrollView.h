//
//  MZCroppingScrollView.h
//  MZCroppableView
//
//  Created by Jeremy Lawrence on 6/30/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZCroppingImageView.h"

@interface MZCroppingScrollView : UIScrollView

@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) MZCroppingImageView *imageView;

@property (nonatomic, getter = isCropEnabled) BOOL cropEnabled;

- (void)centerContents;
@end
