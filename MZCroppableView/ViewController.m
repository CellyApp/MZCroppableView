//
//  ViewController.m
//  MZCroppableView
//
//  Created by macbook on 30/10/2013.
//  Copyright (c) 2013 macbook. All rights reserved.
//

#import "ViewController.h"
#import "MZPresetCropView.h"

@interface ViewController ()
<UIScrollViewDelegate>

@property (nonatomic) BOOL token;
@property (strong, nonatomic) NSArray *paths;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self setUpPaths];
    [self setUpMZCroppableView];
}

- (void)setUpPaths
{
    CGRect rect = CGRectMake(0, 0, 150, 150);
    UIBezierPath *square = [UIBezierPath bezierPathWithRect:rect];
    UIBezierPath *oval = [UIBezierPath bezierPathWithOvalInRect:rect];
    self.paths = @[square, oval];
}

#pragma mark - My Methods -

- (void)setUpMZCroppableView
{
    [self.zoomingCropView setImage:[UIImage imageNamed:@"cropping_sample.JPG"]];
}

#pragma mark - My IBActions -
- (IBAction)resetButtonTapped:(UIBarButtonItem *)sender
{
    [self setUpMZCroppableView];
}
- (IBAction)cropButtonTapped:(UIBarButtonItem *)sender
{
//    if (![self.zoomingCropView.imageView.cropView.croppingPath isEmpty]) {
        UIImage *croppedImage = [self.zoomingCropView getCroppedImage];
        [self.zoomingCropView setImage:croppedImage];
        
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/final.png"];
        [UIImagePNGRepresentation(croppedImage) writeToFile:path atomically:YES];
        
        NSLog(@"cropped image path: %@",path);
//    }
}

- (IBAction)editModeButtonTapped:(id)sender
{
//    [self.zoomingCropView setCropEnabled:!self.zoomingCropView.isCropEnabled];
    self.token = !self.token;
    UIBezierPath *path = [self.paths objectAtIndex:[@(self.token)intValue]];
    [self.zoomingCropView updateReticleViewWithPath:path];
}

@end
