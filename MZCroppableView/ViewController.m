//
//  ViewController.m
//  MZCroppableView
//
//  Created by macbook on 30/10/2013.
//  Copyright (c) 2013 macbook. All rights reserved.
//

#import "ViewController.h"
#import "MZCroppableView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.croppingImageView setImage:[UIImage imageNamed:@"cropping_sample.JPG"]];
    CGRect rect1 = CGRectMake(0, 0, self.croppingImageView.image.size.width, self.croppingImageView.image.size.height);
    CGRect rect2 = self.croppingImageView.frame;
    [self.croppingImageView setFrame:[MZCroppableView scaleRespectAspectFromRect1:rect1 toRect2:rect2]];
    
    [self setUpMZCroppableView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - My Methods -
- (void)setUpMZCroppableView
{
    [self.mzCroppableView removeFromSuperview];
    [self.croppingImageView setImage:[UIImage imageNamed:@"cropping_sample.JPG"]];
    MZCroppableView *mzCroppableView = [[MZCroppableView alloc] initWithImageView:self.croppingImageView];
    [self.view addSubview:mzCroppableView];
    self.mzCroppableView = mzCroppableView;
}
#pragma mark - My IBActions -
- (IBAction)resetButtonTapped:(UIBarButtonItem *)sender
{
    [self setUpMZCroppableView];
}
- (IBAction)cropButtonTapped:(UIBarButtonItem *)sender
{
    if (![self.mzCroppableView.croppingPath isEmpty]) {
        UIImage *croppedImage = [self.mzCroppableView deleteBackgroundOfImage:self.croppingImageView];
        [self.croppingImageView setImage:croppedImage];
        self.mzCroppableView.croppingPath = nil;
        self.mzCroppableView.smoothedPath = nil;
        [self.mzCroppableView setNeedsDisplay];
        
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/final.png"];
        [UIImagePNGRepresentation(croppedImage) writeToFile:path atomically:YES];
        
        NSLog(@"cropped image path: %@",path);
    }
}
@end
