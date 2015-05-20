//
//  SearchVideoViewController.m
//  YouTube-App
//
//  Created by Admin on 19.05.15.
//  Copyright (c) 2015 AShi. All rights reserved.
//

#import "SearchVideoViewController.h"
#import "CustomVideoCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "YouTubeVideo.h"
#import "VideoViewController.h"

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
    // getting json from YouTube API
    //NSString *playlistID = @"PLgMaGEI-ZiiZ0ZvUtduoDRVXcU5ELjPcI";
    NSString *searchString = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString: @"+"];
    
    // converting string to Percent Escapes format
    searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *maxResults = @"50";
    NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?&part=snippet&q=%@&fields=items(id%%2Csnippet)&maxResults=%@&key=%@", searchString, maxResults, self.DEV_KEY];
    
    NSLog(@"URL: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         self.videoListJSON = (NSDictionary *)responseObject;
         NSLog(@"JSON Retrieved");
         NSLog(@"%@", self.videoListJSON);
         
         // cleaning current array with videos
         [self.videoList removeAllObjects];
         
         NSDictionary *items = [responseObject objectForKey:@"items"];
         for (NSDictionary *item in items )
         {
             YouTubeVideo *youTubeVideo = [[YouTubeVideo alloc] init];
             NSDictionary* snippet = [item objectForKey:@"snippet"];
             youTubeVideo.title = [snippet objectForKey:@"title"];
             youTubeVideo.videoID = [[item objectForKey:@"id"] objectForKey:@"videoId"];
            // if (!youTubeVideo.videoID)
             //    continue;
             youTubeVideo.previewUrl = [[[snippet objectForKey:@"thumbnails"] objectForKey:@"high"] objectForKey:@"url"];
             //youTubeVideo .videoDate =[snippet objectForKey:@"publishedAt"];
             [self.videoList addObject:youTubeVideo];
         }
         [self.tableView reloadData];
         
         
         //[self.tableView reloadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:[error localizedDescription]
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
         [alertView show];
     }];
    
    // 5
    [operation start];
    
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
     return 300;
 }

@end
