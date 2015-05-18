//
//  PopularVideoViewController.m
//  YouTube-App
//
//  Created by Admin on 18.05.15.
//  Copyright (c) 2015 AShi. All rights reserved.
//

#import "PopularVideoViewController.h"
#import "CustomVideoCell.h"

@interface PopularVideoViewController ()<UITableViewDelegate,
                                        UITableViewDataSource>

@property (retain, nonatomic) NSDictionary *videoListJSON;
@property (weak, nonatomic) IBOutlet UITableView *videoTableView;

@end

@implementation PopularVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    self.videoTableView.delegate = self;
    self.videoTableView.dataSource = self;
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"Популярные видео";
    //self.navigationController.navigationBar.translucent = NO;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(getVideoList) forControlEvents:UIControlEventValueChanged];
    [self.videoTableView addSubview:refreshControl];
    
    //[self getVideoList];
    
    }
/*
- (void)getVideoList
{
    // getting json from YouTube API
    NSString *feedType = @"most_popular?";
    NSString *urlString = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/standardfeeds/%@&time=today&key=%@&alt=json", feedType, self.DEV_KEY];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         self.videoListJSON = (NSDictionary *)responseObject;
         NSLog(@"JSON Retrieved");
         NSLog(@"%@", self.videoListJSON);
         /*
         for(NSString *key in [self.videoListJSON allKeys])
         {
             NSLog(@"key: %@ | value: %@",key, [self.videoListJSON objectForKey:key]);
         }
          */
/*
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
*/
/*
- (void) handleRefresh
{
    [self getVideoList];
}
 */

// Number of sections in tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Number of rows in sections
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

// Performing actions to update the cell in tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    CustomVideoCell *cell = (CustomVideoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomVideoCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 };
    [cell.playerView loadWithVideoId:@"M7lc1UVf-VE" playerVars:playerVars];
    
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240;
}


@end
