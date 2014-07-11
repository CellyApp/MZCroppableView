//
//  MZCroppableView.m
//  MZCroppableView
//
//  Created by macbook on 30/10/2013.
//  Copyright (c) 2013 macbook. All rights reserved.
//

#import "MZCroppableView.h"
#import "UIBezierPath-Points.h"
#import "UIBezierPath-Smoothing.h"

@interface MZCroppableView()

@property (nonatomic, getter=isDrawing) BOOL drawing;

@end

@implementation MZCroppableView

- (void)_commonInitializer
{
    [self.croppingPath setLineWidth:2.0f];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setClipsToBounds:YES];
    [self setUserInteractionEnabled:YES];
    self.croppingPath = [[UIBezierPath alloc] init];
    self.lineColor = [UIColor redColor];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInitializer];
    }
    return self;
}
- (id)initWithImageView:(UIImageView *)imageView
{
    self = [super initWithFrame:imageView.frame];
    if (self) {
        [self _commonInitializer];
    }
    return self;
}

#pragma mark - My Methods -
+ (CGRect)scaleRespectAspectFromRect1:(CGRect)rect1 toRect2:(CGRect)rect2
{
    CGSize scaledSize = rect2.size;
    
    float scaleFactor = 1.0;
    
    CGFloat widthFactor  = rect2.size.width / rect1.size.width;
    CGFloat heightFactor = rect2.size.height / rect1.size.width;
    
    if (widthFactor < heightFactor)
        scaleFactor = widthFactor;
    else
        scaleFactor = heightFactor;
    
    scaledSize.height = rect1.size.height *scaleFactor;
    scaledSize.width  = rect1.size.width  *scaleFactor;
    
    float y = (rect2.size.height - scaledSize.height)/2;
    
    return CGRectMake(0, y, scaledSize.width, scaledSize.height);
}
+ (CGPoint)convertCGPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2
{
    point1.y = rect1.height - point1.y; // Flips mask
    CGFloat scaleFactor = rect1.width / rect2.width;
    CGPoint result = CGPointMake(point1.x/scaleFactor,
                                 point1.y/scaleFactor);
    return result;
}
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self.lineColor setStroke];
    if (self.smoothedPath && !self.isDrawing) {
        [self.smoothedPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0f];
    }
    else {
        [self.croppingPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0f];
    }
}

- (UIBezierPath *)transformPath:(UIBezierPath *)path intoImageView:(UIImageView *)imageView
{
    /*
     The coordinate system between the path and the imageView are flipped
     
     When cropping, a path that defines a box with the origin (0,0) and size (1,1) will result in an image of the bottom-left pixel of the original image. The path needs to be flipped vertically and then set at the top of the image in order for the affine transformations to operate properly (i.e. moving in the positive y direction results in the crop path moving downward).
     */
    
    UIBezierPath *newPath = [path copy];
//    UIBezierPath *newPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 5, 5)];
    
    CGFloat imageScale = sqrt(pow(imageView.transform.a,2) + pow(imageView.transform.c,2));
    CGAffineTransform copyImageView = CGAffineTransformScale(CGAffineTransformIdentity, 1/imageScale, 1/imageScale);
    copyImageView = CGAffineTransformTranslate(copyImageView, imageView.transform.tx, imageView.transform.ty);
    
    // Path is actually flipped with respect to image, so flip it (only necessary for non-regular shapes
    CGAffineTransform flipVert = CGAffineTransformScale(CGAffineTransformIdentity, 1, -1);
    [newPath applyTransform:flipVert];
    
    // Move the path to 'origin' of image
    CGAffineTransform moveToTop = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, imageView.frame.size.height);
    [newPath applyTransform:moveToTop];
    
    // Trying to crop bottom left corner
    CGAffineTransform move = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -(imageView.frame.size.height - newPath.bounds.size.height));
    [newPath applyTransform:move];
    
//    CGAffineTransform moveToOrigin = CGAffineTransformTranslate(CGAffineTransformIdentity, -center.x, -center.y);
//    [newPath applyTransform:moveToOrigin];
//    [newPath applyTransform:copyImageView];
//    [newPath applyTransform:imageView.transform];
    
    NSLog(@"\n\npath: %@\n\nnewPath: %@", path, newPath);
//    NSLog(@"moveToOrigin: %@", NSStringFromCGAffineTransform(moveToOrigin));
    NSLog(@"copyImageView: %@", NSStringFromCGAffineTransform(copyImageView));
    
    return newPath;
}

- (UIImage *)grabCroppedImageFromImageView:(UIImageView *)imageView
                       displayedImageFrame:(CGRect)imageFrame
                             fromDrawnPath:(BOOL)drawnPath
{
    NSArray *points = [self.croppingPath points];
    
    CGRect rect = CGRectZero;
    rect.size = imageView.image.size;
    
    UIBezierPath *aPath;
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
    {
        [[UIColor blackColor] setFill];
        UIRectFill(rect);
        [[UIColor whiteColor] setFill];
        
        aPath = [UIBezierPath bezierPath];
        
//        // Set the starting point of the shape.
//        CGPoint p1 =
//        [MZCroppableView convertCGPoint:[[points objectAtIndex:0] CGPointValue]
//                              fromRect1:imageFrame.size
//                                toRect2:imageView.image.size];
//        [aPath moveToPoint:CGPointMake(p1.x, p1.y)];
//        
//        for (uint i=1; i<points.count; i++)
//        {
//            CGPoint p =
//            [MZCroppableView convertCGPoint:[[points objectAtIndex:i] CGPointValue]
//                                  fromRect1:imageFrame.size
//                                    toRect2:imageView.image.size];
//            [aPath addLineToPoint:CGPointMake(p.x, p.y)];
//        }
//        [aPath closePath];
//        if (drawnPath) {
//            aPath = [aPath smoothedPathByInterpolation];
//        }
//        [aPath fill];
        
        aPath = [self transformPath:self.croppingPath intoImageView:imageView];
        [aPath closePath];
        [aPath fill];
    }
    
    UIImage *returnedImage = nil;
    
    // Wrap image creation in autoreleasepoll to avoid memory leaks
    @autoreleasepool {
        UIImage *mask = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
        
        {
            CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask.CGImage);
            [imageView.image drawAtPoint:CGPointZero];
        }
        
        UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGRect croppedRect = aPath.bounds;
        croppedRect.origin.y = rect.size.height - CGRectGetMaxY(aPath.bounds);//This because mask become inverse of the actual image;
        
        croppedRect.origin.x = croppedRect.origin.x*2;
        croppedRect.origin.y = croppedRect.origin.y*2;
        croppedRect.size.width = croppedRect.size.width*2;
        croppedRect.size.height = croppedRect.size.height*2;
        
        CGImageRef imageRef = CGImageCreateWithImageInRect(maskedImage.CGImage, croppedRect);
        
        returnedImage = [UIImage imageWithCGImage:imageRef];
        
        CGImageRelease(imageRef);
        imageRef = NULL;
    }
    
    return returnedImage;
}

#pragma mark - Touch Methods -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(touchesBeganOnCroppableView:)]) {
        [self.delegate touchesBeganOnCroppableView:self];
    }
    
    self.drawing = YES;
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    [self.croppingPath moveToPoint:[mytouch locationInView:self]];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    [self.croppingPath addLineToPoint:[mytouch locationInView:self]];
    
    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.drawing = NO;
    self.smoothedPath = [self.croppingPath smoothedPathByInterpolation];
    [self setNeedsDisplay];
    
    if ([self.delegate respondsToSelector:@selector(touchesEndedOnCroppableView:)]) {
        [self.delegate touchesEndedOnCroppableView:self];
    }
}
@end
