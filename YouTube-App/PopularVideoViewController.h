//
//  PopularVideoViewController.h
//  YouTube-App
//
//  Created by Admin on 18.05.15.
//  Copyright (c) 2015 AShi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoViewController;

@interface PopularVideoViewController : UIViewController

@property (strong, nonatomic) VideoViewController *videoViewController;
@property (strong, nonatomic) UINavigationController *videoNavigationController;


@end
