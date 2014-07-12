//
//  MZCropReticleView.m
//  MZCroppableView
//
//  Created by Jeremy Lawrence on 7/9/14.
//  Copyright (c) 2014 macbook. All rights reserved.
//

#import "MZCropReticleView.h"

@interface MZReticleView : UIView

@property (nonatomic) UIBezierPath *cropPath;
@property (strong, nonatomic) UIColor *color;
@property (nonatomic) CGFloat lineWidth;

@end

@implementation MZReticleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setOpaque:NO];
        [self setUserInteractionEnabled:NO];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (self.cropPath) {
        NSLog(@"Drawing");
        [self.color setStroke];
        [self.cropPath setLineWidth:self.lineWidth];
        [self.cropPath stroke];
    }
}

@end

@interface MZCropReticleView()

@property (weak, nonatomic) MZReticleView *reticle;

@end

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
        [self setClipsToBounds:NO];
        self.lineWidth = 5.0f;
        self.reticleColor = [UIColor redColor];
        
        [self updateReticle];
    }
    return self;
}

- (void)updateReticle
{
    NSLog(@"updating reticle");
    if (self.reticle) {
        [self.reticle removeFromSuperview];
    }
    
    // Create frame for the reticle that is just large enough to fully encompass the crop path's stroke
    CGFloat compensation = (self.lineWidth*2);
    CGRect largerFrame = CGRectInset(self.bounds, -compensation, -compensation);
    MZReticleView *reticle = [[MZReticleView alloc] initWithFrame:largerFrame];
    [reticle setColor:self.reticleColor];
    [reticle setLineWidth:self.lineWidth];
    
    // Move the path to have the stroke be fully displayed/return path to proper area
    UIBezierPath *adjustedPath = [self.cropPath copy];
    [adjustedPath applyTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, compensation, compensation)];
    [reticle setCropPath:adjustedPath];
    
    [self addSubview:reticle];
    self.reticle = reticle;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    
    [self updateReticle];
}

@end
