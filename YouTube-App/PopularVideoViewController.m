//
//  PopularVideoViewController.m
//  YouTube-App
//
//  Created by Admin on 18.05.15.
//  Copyright (c) 2015 AShi. All rights reserved.
//

#import "PopularVideoViewController.h"
#import "CustomVideoCell.h"
// #import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "YouTubeVideo.h"
#import "VideoViewController.h"
#import "YouTubeTools.h"

@interface PopularVideoViewController ()<UITableViewDelegate,
                                        UITableViewDataSource>

@property (retain, nonatomic) NSDictionary *videoListJSON;
@property (strong, nonatomic) NSMutableArray *videoList;
@property (weak, nonatomic) IBOutlet UITableView *videoTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation PopularVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    self.videoViewController = [[VideoViewController alloc] init];
    self.videoNavigationController = [[UINavigationController alloc] initWithRootViewController:self.videoViewController];
    
    self.videoTableView.delegate = self;
    self.videoTableView.dataSource = self;
    
    self.videoList = [[NSMutableArray alloc] init];
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"Популярные видео";
    //self.navigationController.navigationBar.translucent = NO;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getVideoList) forControlEvents:UIControlEventValueChanged];
    [self.videoTableView addSubview:self.refreshControl];
    
    [self getVideoList];
    
    }

- (void)getVideoList
{
    self.videoList = [YouTubeTools popularVideoArrayWithMaxResults:@"10"
                                             withCompletitionBlock:^()
                      {
                          [self.videoTableView reloadData];
                          [self.refreshControl endRefreshing];
                      }
                      ];
}

- (void) handleRefresh
{
    [self getVideoList];
}


// Number of sections in tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Number of rows in sections
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.videoList count];
}

// Performing actions to update the cell in tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    CustomVideoCell *cell = (CustomVideoCell *)[self.videoTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomVideoCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
     
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 };
    //[cell.playerView loadWithVideoId:@"M7lc1UVf-VE" playerVars:playerVars];
    YouTubeVideo *youTubeVideo = self.videoList[indexPath.row];
    
    [cell.previewImage setImageWithURL: [NSURL URLWithString: youTubeVideo.previewUrl]];
    [cell.previewImage setImageWithURL: [NSURL URLWithString: youTubeVideo.previewUrl]];
    cell.title.text = youTubeVideo.title;
    cell.likeCount.text = youTubeVideo.likesCount;
    cell.dislikeCount.text = youTubeVideo.dislikesCount;
    //cell.likeCount.text = [NSString stringWithFormat:@"Просмотров: %@", youTubeVideo.viewsCount];
    cell.chanelTitle.text = [NSString stringWithFormat:@"%@  -  Просмотров: %@", youTubeVideo.channelTitle, youTubeVideo.viewsCount];
    cell.time.text = youTubeVideo.duration;
    
    return cell;

}

// Action performed after tapping on the cell
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // setting link to full post
    self.videoViewController.selectedVideo = self.videoList[indexPath.row];
    [self presentViewController:self.videoNavigationController animated:YES completion:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 320;
}

@end
