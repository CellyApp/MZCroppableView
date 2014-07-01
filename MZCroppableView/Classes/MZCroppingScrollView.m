//
//  MZCroppingScrollView.m
//  MZCroppableView
//
//  Created by Jeremy Lawrence on 6/30/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import "MZCroppingScrollView.h"

@interface MZCroppingScrollView()
<MZCroppingImageViewDelegate>

@end

@implementation MZCroppingScrollView

- (void)_commonInitializer
{
    self.scrollsToTop = NO;
    self.cropLineWidth = 5.0f;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _commonInitializer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _commonInitializer];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    // Reset the image
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    [self.imageView setImage:image];
    
    // Create the cropping image view with the image
    MZCroppingImageView *imageView = [[MZCroppingImageView alloc] initWithImage:image];
    [imageView setDelegate:self];
    [self addSubview:imageView];
    self.imageView = imageView;
    
    // Set content size of scroll view to fit imageView
    self.contentSize = imageView.frame.size;
    
    // Set scale to fit image in bounds
    CGFloat fittingScale = MIN((self.bounds.size.width/image.size.width),
                               (self.bounds.size.height/image.size.height));
    [self setMaximumZoomScale:2];
    [self setMinimumZoomScale:fittingScale];
    [self setZoomScale:fittingScale];
    
    [self setCropEnabled:NO];
    [self centerContents];
}

- (void)setCropEnabled:(BOOL)cropEnabled
{
    _cropEnabled = cropEnabled;
    [self setScrollEnabled:!cropEnabled];
    [self.imageView setUserInteractionEnabled:cropEnabled];
}

- (void)centerContents
{
    CGSize boundsSize = self.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    }
    else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    }
    else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}

#pragma mark - Public

- (UIImage *)getCroppedImage
{
    return [self.imageView getCroppedImage];
}

#pragma MZCroppingImageViewDelegate

- (void)touchesBeganOnCroppingImageView:(MZCroppingImageView *)croppingImageView
{
    NSLog(@"Setting line width");
    CGFloat zoomScale = self.zoomScale;
    CGFloat containerWidth = self.bounds.size.width;
    CGFloat desiredLine = self.cropLineWidth;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat newLineWidth = (containerWidth / zoomScale) * (desiredLine/screenWidth);
    NSLog(@"New line width: %f", newLineWidth);
    [self.imageView.cropView.croppingPath setLineWidth:newLineWidth];
}

- (void)touchesEndedOnCroppingImageView:(MZCroppingImageView *)croppingImageView
{
    if ([self.cropDelegate respondsToSelector:@selector(croppingScrollViewDidEndTouches:)]) {
        [self.cropDelegate croppingScrollViewDidEndTouches:self];
    }
}

@end
