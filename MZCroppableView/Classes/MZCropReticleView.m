//
//  MZCropReticleView.m
//  MZCroppableView
//
//  Created by Jeremy Lawrence on 7/9/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import "MZCropReticleView.h"

@implementation MZCropReticleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithPath:(UIBezierPath *)path
{
    CGRect pathBounds = CGPathGetBoundingBox(path.CGPath);
    self = [super initWithFrame:pathBounds];
    if (self) {
        self.cropPath = path;
        [self setOpaque:NO];
        [self setUserInteractionEnabled:NO];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (self.cropPath) {
        [[UIColor blackColor] setStroke];
        [self.cropPath setLineWidth:5.0f];
        [self.cropPath stroke];
        NSLog(@"orign=%f,%f",self.frame.origin.x,self.frame.origin.y);
    }
}

@end
