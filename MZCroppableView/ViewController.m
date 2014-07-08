//
//  ViewController.m
//  MZCroppableView
//
//  Created by macbook on 30/10/2013.
//  Copyright (c) 2013 macbook. All rights reserved.
//

#import "ViewController.h"
#import "MZZoomingCropView.h"

@interface ViewController ()
<UIScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self setUpMZCroppableView];
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
    if (![self.zoomingCropView.imageView.cropView.croppingPath isEmpty]) {
        UIImage *croppedImage = [self.zoomingCropView getCroppedImage];
        [self.zoomingCropView setImage:croppedImage];
        
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/final.png"];
        [UIImagePNGRepresentation(croppedImage) writeToFile:path atomically:YES];
        
        NSLog(@"cropped image path: %@",path);
    }
}

- (IBAction)editModeButtonTapped:(id)sender
{
    [self.zoomingCropView setCropEnabled:!self.zoomingCropView.isCropEnabled];
}

@end
