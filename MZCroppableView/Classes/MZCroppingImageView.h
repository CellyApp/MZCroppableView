//
//  MZCroppingImageView.h
//  MZCroppableView
//
//  Created by Jeremy Lawrence on 6/26/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZCroppingImageView : UIImageView

- (UIImage *)getCroppedImage;

- (void)clearDrawnPath;

@end
