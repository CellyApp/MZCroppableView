//
//  ViewController.m
//  MZCroppableView
//
//  Created by macbook on 30/10/2013.
//  Copyright (c) 2013 macbook. All rights reserved.
//

#import "ViewController.h"
#import "MZCroppableView.h"
#import "MZCroppingImageView.h"
#import "MZCroppingScrollView.h"

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
    [self.scrollView setImage:[UIImage imageNamed:@"cropping_sample.JPG"]];
}
#pragma mark - My IBActions -
- (IBAction)resetButtonTapped:(UIBarButtonItem *)sender
{
    [self setUpMZCroppableView];
}
- (IBAction)cropButtonTapped:(UIBarButtonItem *)sender
{
    if (![self.scrollView.imageView.cropView.croppingPath isEmpty]) {
        UIImage *croppedImage = [self.scrollView getCroppedImage];
        [self.scrollView setImage:croppedImage];
        
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/final.png"];
        [UIImagePNGRepresentation(croppedImage) writeToFile:path atomically:YES];
        
        NSLog(@"cropped image path: %@",path);
    }
}

- (IBAction)editModeButtonTapped:(id)sender
{
    [self.scrollView setCropEnabled:!self.scrollView.isCropEnabled];
}

#pragma mark - Scroll View
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.scrollView.imageView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"Frame: %@\nContent: %@", NSStringFromCGRect(scrollView.frame), NSStringFromCGSize(scrollView.contentSize));
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self.scrollView centerContents];
}

@end
