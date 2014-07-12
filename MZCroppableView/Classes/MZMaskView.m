//
//  MZMaskView.m
//  MZCroppableView
//
//  Created by Greg Passmore on 7/11/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import "MZMaskView.h"

@interface MZMaskView()

@property UIBezierPath *path;
@property CGRect reticleFrame;

@end

@implementation MZMaskView

- (id)initWithFrame:(CGRect)frame andPath:(UIBezierPath*)path andReticleFrame:(CGRect)reticleFrame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.path = path;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.reticleFrame = reticleFrame;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Get the current graphics context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor( context, [UIColor blueColor].CGColor );
    CGContextFillRect( context, rect );
    
    
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] setFill];
    UIRectFill(rect);
    
    CGRect bounds = self.path.bounds;
    if( CGRectIntersectsRect( bounds, rect ) )
    {
        CGContextSetFillColorWithColor( context, [UIColor clearColor].CGColor );
        
        UIBezierPath *path = [self.path copy];
        CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(self.reticleFrame.origin.x, self.reticleFrame.origin.y);
        [path applyTransform:translateTransform];
        [[UIColor yellowColor] setFill];
        
        CGContextSetBlendMode(context, kCGBlendModeDestinationOut);
        [path fill];
    }
}

@end
