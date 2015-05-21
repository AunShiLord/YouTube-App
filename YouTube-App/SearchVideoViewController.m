//
//  SearchVideoViewController.m
//  YouTube-App
//
//  Created by Admin on 19.05.15.
//  Copyright (c) 2015 AShi. All rights reserved.
//

#import "SearchVideoViewController.h"
#import "CustomVideoCell.h"
#import "UIImageView+AFNetworking.h"
#import "VideoViewController.h"

#import "YouTubeVideo.h"
#import "YouTubeTools.h"

@interface SearchVideoViewController () <UITableViewDelegate,
                                        UITableViewDataSource,
                                        UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (retain, nonatomic) NSDictionary *videoListJSON;
@property (retain, nonatomic) NSMutableArray *videoList;

@end

@implementation SearchVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoViewController = [[VideoViewController alloc] init];
    self.videoNavigationController = [[UINavigationController alloc] initWithRootViewController:self.videoViewController];
    
    self.videoList = [[NSMutableArray alloc] init];
    
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self getVideoList];
    [self.view endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

- (void)getVideoList
{
    self.videoList = [YouTubeTools findVideoArrayWithString:self.searchBar.text
                                                 maxResults:@"50"
                                      withCompletitionBlock:^
                      {
                          [self.tableView reloadData];
                      }
                      ];
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
     CustomVideoCell *cell = (CustomVideoCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
     cell.title.text = youTubeVideo.title;
     cell.likeCount.text = youTubeVideo.likesCount;
     cell.dislikeCount.text = youTubeVideo.dislikesCount;
     //cell.viewCount.text = [NSString stringWithFormat:@"Просмотров: %@", youTubeVideo.viewsCount];
     cell.chanelTitle.text = [NSString stringWithFormat:@"%@  -  Просмотров: %@", youTubeVideo.channelTitle, youTubeVideo.viewsCount];
     //NSString *duration = youTubeVideo.duration;
     NSMutableString *duration = [NSMutableString stringWithString:youTubeVideo.duration];
     //[duration repla]
     NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!");
     NSLog(@"%@", duration);
     NSString *temp = [duration substringFromIndex:2];
     NSLog(@"%@", temp);
     temp = [temp substringToIndex:[temp length] - 1];
     NSLog(@"%@", temp);
     
     duration = [NSMutableString stringWithString: temp];
     for (int i; i<[duration length]; i++)
     {
         char c = [duration characterAtIndex:i];
         if(c>='0' && c<='9')
         {
             continue;
         }
         else
         {
             NSRange range = {i,i};
             [duration replaceCharactersInRange:range withString:@":"];
         }
     }
     cell.time.text = duration;
 
 
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
