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
