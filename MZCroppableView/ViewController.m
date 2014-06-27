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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.croppingImageView setImage:[UIImage imageNamed:@"cropping_sample.JPG"]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - My Methods -
- (void)setUpMZCroppableView
{
    [self.croppingImageView setImage:[UIImage imageNamed:@"cropping_sample.JPG"]];
}
#pragma mark - My IBActions -
- (IBAction)resetButtonTapped:(UIBarButtonItem *)sender
{
    [self setUpMZCroppableView];
}
- (IBAction)cropButtonTapped:(UIBarButtonItem *)sender
{
    if (![self.mzCroppableView.croppingPath isEmpty]) {
        UIImage *croppedImage = [self.croppingImageView getCroppedImage];
        [self.croppingImageView setImage:croppedImage];
        
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/final.png"];
        [UIImagePNGRepresentation(croppedImage) writeToFile:path atomically:YES];
        
        NSLog(@"cropped image path: %@",path);
    }
}
@end
