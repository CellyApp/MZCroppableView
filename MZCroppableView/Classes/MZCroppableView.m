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
    self.lineWidth = 2.0f;
    [self setBackgroundColor:[UIColor clearColor]];
    [self setClipsToBounds:YES];
    [self setUserInteractionEnabled:YES];
    self.croppingPath = [[UIBezierPath alloc] init];
    [self.croppingPath setLineWidth:self.lineWidth];
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

- (UIImage *)grabCroppedImageFromImageView:(UIImageView *)imageView
                       displayedImageFrame:(CGRect)imageFrame
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
        
        // Set the starting point of the shape.
        CGPoint p1 =
        [MZCroppableView convertCGPoint:[[points objectAtIndex:0] CGPointValue]
                              fromRect1:imageFrame.size
                                toRect2:imageView.image.size];
        [aPath moveToPoint:CGPointMake(p1.x, p1.y)];
        
        for (uint i=1; i<points.count; i++)
        {
            CGPoint p =
            [MZCroppableView convertCGPoint:[[points objectAtIndex:i] CGPointValue]
                                  fromRect1:imageFrame.size
                                    toRect2:imageView.image.size];
            [aPath addLineToPoint:CGPointMake(p.x, p.y)];
        }
        [aPath closePath];
        aPath = [aPath smoothedPathByInterpolation];
        [aPath fill];
    }
    
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
    
    maskedImage = [UIImage imageWithCGImage:imageRef];
    
    return maskedImage;
}

#pragma mark - Touch Methods -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
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
    
    if ([self.delegate respondsToSelector:@selector(croppableViewDidEndTouches:)]) {
        [self.delegate croppableViewDidEndTouches:self];
    }
}
@end
