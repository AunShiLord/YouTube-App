//
//  SearchVideoViewController.h
//  YouTube-App
//
//  Created by Admin on 19.05.15.
//  Copyright (c) 2015 AShi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoViewController;

@interface SearchVideoViewController : UIViewController

@property (retain, nonatomic) NSString *DEV_KEY;
@property (strong, nonatomic) VideoViewController *videoViewController;
@property (strong, nonatomic) UINavigationController *videoNavigationController;

@end
