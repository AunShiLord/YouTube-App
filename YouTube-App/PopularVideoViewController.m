//
//  PopularVideoViewController.m
//  YouTube-App
//
//  Created by Admin on 18.05.15.
//  Copyright (c) 2015 AShi. All rights reserved.
//

#import "PopularVideoViewController.h"
#import "CustomVideoCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "YouTubeVideo.h"
#import "VideoViewController.h"

@interface PopularVideoViewController ()<UITableViewDelegate,
                                        UITableViewDataSource>

@property (retain, nonatomic) NSDictionary *videoListJSON;
@property (strong, nonatomic) NSMutableArray *videoList;
@property (weak, nonatomic) IBOutlet UITableView *videoTableView;

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
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(getVideoList) forControlEvents:UIControlEventValueChanged];
    [self.videoTableView addSubview:refreshControl];
    
    [self getVideoList];
    
    }

- (void)getVideoList
{
    // getting json from YouTube API
    NSString *playlistID = @"PLgMaGEI-ZiiZ0ZvUtduoDRVXcU5ELjPcI";
    NSString *maxResults = @"50";
    NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%%2CcontentDetails&maxResults=%@&playlistId=%@&fields=items%%2Fsnippet&key=%@", maxResults, playlistID, self.DEV_KEY];

    NSLog(@"URL: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         self.videoListJSON = (NSDictionary *)responseObject;
         NSLog(@"JSON Retrieved");
         //NSLog(@"%@", self.videoListJSON);
         
         // ANDREY CODE
         NSDictionary *items = [responseObject objectForKey:@"items"];
         for (NSDictionary *item in items )
         {
             YouTubeVideo *youTubeVideo = [[YouTubeVideo alloc] init];
             NSDictionary* snippet = [item objectForKey:@"snippet"];
             youTubeVideo.title = [snippet objectForKey:@"title"];
             youTubeVideo.videoID = [[snippet objectForKey:@"resourceId"]objectForKey:@"videoId"];
             youTubeVideo.previewUrl = [[[snippet objectForKey:@"thumbnails"] objectForKey:@"high"] objectForKey:@"url"];
             //youTubeVideo .videoDate =[snippet objectForKey:@"publishedAt"];
             [self.videoList addObject:youTubeVideo];
         }
         [self.videoTableView reloadData];
         

         //[self.tableView reloadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                             message:[error localizedDescription]
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
         [alertView show];
     }];
    
    // 5
    [operation start];

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
    return 240;
}


@end
