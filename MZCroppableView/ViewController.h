//
//  ViewController.h
//  MZCroppableView
//
//  Created by macbook on 30/10/2013.
//  Copyright (c) 2013 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MZPresetCropView;
@interface ViewController : UIViewController

//@property (weak, nonatomic) IBOutlet MZCroppingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet MZPresetCropView *zoomingCropView;
@property (weak, nonatomic) IBOutlet UIToolbar *editModeButton;
@end
