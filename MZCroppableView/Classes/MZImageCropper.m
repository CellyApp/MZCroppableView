//
//  MZImageCropper.m
//  MZCroppableView
//
//  Created by Jeremy Lawrence on 7/11/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import "MZImageCropper.h"

@implementation MZImageCropper

/**
 Performs necessary path transformations for a cropping path displayed as a
 reticle on screen.
 
 @param path          The path tobe used for cropping.
 @param imageView     The UIImageView that contains the image to be cropped,
 which is displayed below the cropping path reticle on screen.
 
 @param reticleOffset
 An offset to adjust for the reticle path's position on screen. Preset cropping
 paths are created with a starting point that doesn't correlate directly to the
 positioning of the reticle relative to the imageView, so the reticleOffset
 allows for the proper adjustment to position the path correctly in the
 imageView's coordinate space. Generally, the reticleOffset is the reticleView's
 frame.origin in the view that has both the reticle view and imageView as 
 subviews.
 
 @return A bezier path that is transformed to propertly mask the area of the 
 image that the user wants to crop.
 */
+ (UIBezierPath *)transformPath:(UIBezierPath *)path
                  intoImageView:(UIImageView *)imageView
              withReticleOffset:(CGPoint)reticleOffset
{
    /*
     The coordinate system between the path and the imageView are flipped
     
     When cropping, a path that defines a box with the origin (0,0) and size (1,1) will result in an image of the bottom-left pixel of the original image. The path needs to be flipped vertically and then set at the top of the image in order for the affine transformations to operate properly (i.e. moving in the positive y direction results in the crop path moving downward).
     */
    UIBezierPath *newPath = [path copy];
    
    // Path is actually flipped with respect to image, so flip it (only necessary for non-regular shapes
    CGAffineTransform flipVert = CGAffineTransformScale(CGAffineTransformIdentity, 1, -1);
    [newPath applyTransform:flipVert];
    
    // Get the scale of the imageView so we can interpret the path. scaleX and scaleY are the same so we can just use scaleX
    CGFloat imageScale = sqrt(pow(imageView.transform.a,2) + pow(imageView.transform.c,2));
    
    // Scale the path to match the image from the imageView
    CGAffineTransform matchImageScale = CGAffineTransformScale(CGAffineTransformIdentity, 1/imageScale, 1/imageScale);
    [newPath applyTransform:matchImageScale];
    
    /*
     Now we need to figure out where to translate the path with respect to the unscaled image.
     We start by figuring out the scaled translation offsets, then we remove the scale from them.
     */
    // We have to incorporate the origin/tx diff because scaling changes the origin AND the tx by the same amount - then if you pan, you need the diff of the tx and the origin.
    CGFloat scaleOffsetX = imageView.transform.tx-imageView.frame.origin.x;
    CGFloat scaleOffsetY = imageView.transform.ty-imageView.frame.origin.y;
    
    // The xOffset is how much to move to the right, so if the imageView has been panned left, the path needs to be moved to the right, so the X has to be inverted. Then we add the scaleOffsetX.
    CGFloat xOffset = (-imageView.transform.tx)+scaleOffsetX;
    
    // The yOffset is how much to move up from the bottom, so the imageView frame height is the max. We then add the ty (whcih we don't have to invert because the coordinate system for Y is already inverted). Likewise, we subtract the scaleOffsetY instead of adding it for the same reason.
    CGFloat yOffset = (imageView.frame.size.height)+imageView.transform.ty-scaleOffsetY;
    
    // Now calculate the real offsets with the scale removed
    xOffset = (xOffset + reticleOffset.x)/imageScale;
    yOffset = (yOffset - reticleOffset.y)/imageScale;
    
    // Now transform using the offsets
    CGAffineTransform followTranslation = CGAffineTransformTranslate(CGAffineTransformIdentity, xOffset,yOffset);
    [newPath applyTransform:followTranslation];
    
    // Return the transformed path for cropping
    return newPath;
}

/**
 Performs necessary path transformations for a user-drawn cropping path.
 
 @note
 This method assumes that the path was drawn on a view that is colocated with
 the associated imageView, and is of the same size. If the given imageView and
 path do not follow this criteria, output is not guaranteed to be correct.
 
 @param path      The user-drawn path that defines the mask for image crop.
 @param imageView The imageView that contains the image to be cropped.
 
 @return A bezier path that is transformed to properly mask the area of the
 image that the user wants to crop.
 */
+ (UIBezierPath *)transformDrawnPath:(UIBezierPath *)path
                       intoImageView:(UIImageView *)imageView
{
    UIBezierPath *newPath = [path copy];
    
    // Path is actually flipped with respect to image, so flip vertically
    // Then move back to proper position
    CGAffineTransform flipItAndReverseIt = CGAffineTransformScale(CGAffineTransformIdentity, 1, -1);
    flipItAndReverseIt = CGAffineTransformTranslate(flipItAndReverseIt, 0, -imageView.bounds.size.height);
    [newPath applyTransform:flipItAndReverseIt];
    
    return newPath;
}

+ (UIImage *)croppedImageFromImageView:(UIImageView *)imageView
                          withCropPath:(UIBezierPath *)path
                         reticleOffset:(CGPoint)reticleOffset
                           pathIsDrawn:(BOOL)drawnPath
{
    CGRect rect = CGRectZero;
    rect.size = imageView.image.size;
    
    UIBezierPath *croppingPath;
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
    {
        [[UIColor blackColor] setFill];
        UIRectFill(rect);
        
        [[UIColor whiteColor] setFill];
        if (drawnPath) {
            croppingPath = [MZImageCropper transformDrawnPath:path intoImageView:imageView];
        }
        else {
            croppingPath = [MZImageCropper transformPath:path intoImageView:imageView withReticleOffset:reticleOffset];
        }
        NSLog(@"\n\nPre-path %@\n\nPost-path %@", path, croppingPath);
        [croppingPath closePath];
        [croppingPath fill];
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
        
        CGRect croppedRect = croppingPath.bounds;
        croppedRect.origin.y = rect.size.height - CGRectGetMaxY(croppingPath.bounds);//This because mask become inverse of the actual image;
        
#warning Probably a fix for retina display. Might result in issues for non-retina devices
        croppedRect.origin.x = croppedRect.origin.x*2;
        croppedRect.origin.y = croppedRect.origin.y*2;
        croppedRect.size.width = croppedRect.size.width*2;
        croppedRect.size.height = croppedRect.size.height*2;
        
        CGImageRef imageRef = CGImageCreateWithImageInRect(maskedImage.CGImage, croppedRect);
        returnedImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        imageRef = NULL;
    }
    
    // todo: This image returned is going to be affected by scale due to the zoom,
    // so we need to resize this image (which will lose quality)
    return returnedImage;
}

@end
