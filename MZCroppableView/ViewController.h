//
//  ViewController.h
//  MZCroppableView
//
//  Created by macbook on 30/10/2013.
//  Copyright (c) 2013 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZCroppableView;
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *croppingImageView;
@property (weak, nonatomic) MZCroppableView *mzCroppableView;
@end
