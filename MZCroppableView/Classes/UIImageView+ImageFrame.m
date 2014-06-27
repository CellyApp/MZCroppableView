//
//  UIImageView+ImageFrame.m
//  MZCroppableView
//
//  Created by Jeremy Lawrence on 6/26/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import "UIImageView+ImageFrame.h"

@implementation UIImageView (ImageFrame)

- (CGRect)imageFrame
{
    CGSize imageSize = self.image.size;
    CGFloat imageScale = fminf(CGRectGetWidth(self.bounds)/imageSize.width, CGRectGetHeight(self.bounds)/imageSize.height);
    CGSize scaledImageSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale);
    CGRect imageFrame = CGRectMake(roundf(0.5f*(CGRectGetWidth(self.bounds)-scaledImageSize.width)), roundf(0.5f*(CGRectGetHeight(self.bounds)-scaledImageSize.height)), roundf(scaledImageSize.width), roundf(scaledImageSize.height));
    return imageFrame;
}
@end
