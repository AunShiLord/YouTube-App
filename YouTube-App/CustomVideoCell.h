//
//  CustomVideoCell.h
//  YouTube-App
//
//  Created by Admin on 18.05.15.
//  Copyright (c) 2015 AShi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YTPlayerView.h>

@interface CustomVideoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *previewImage;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *option1;
@property (strong, nonatomic) IBOutlet UILabel *option2;

@end
