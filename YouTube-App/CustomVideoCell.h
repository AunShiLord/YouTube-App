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
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *likeCount;
@property (strong, nonatomic) IBOutlet UILabel *dislikeCount;
@property (strong, nonatomic) IBOutlet UILabel *chanelTitle;
@property (strong, nonatomic) IBOutlet UILabel *viewCount;

@end
