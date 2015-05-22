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

#import "YTPlayerView.h"

@interface PopularVideoViewController ()<UITableViewDelegate,
                                        UITableViewDataSource,
                                        UISearchBarDelegate,
                                        UISearchControllerDelegate>

@property (retain, nonatomic) NSDictionary          *videoListJSON;
@property (strong, nonatomic) NSMutableArray        *popularVideoList;
@property (strong, nonatomic) NSMutableArray        *videoList;
@property (weak, nonatomic)   IBOutlet UITableView  *videoTableView;
@property (strong, nonatomic) UIRefreshControl      *refreshControl;
@property (strong, nonatomic) UISearchController    *searchController;
@property (nonatomic)         int                   rowCount;
@property (nonatomic)         BOOL                  isSearch;

@property (strong, nonatomic) IBOutlet YTPlayerView *playerView;
@property (strong, nonatomic) IBOutlet UIView *detailsView;

@property (strong, nonatomic) IBOutlet UILabel *videoTitle;
@property (strong, nonatomic) IBOutlet UILabel *channelID;
@property (strong, nonatomic) IBOutlet UILabel *likeCount;
@property (strong, nonatomic) IBOutlet UILabel *dislikeCount;
@property (strong, nonatomic) IBOutlet UITextView *videoDescription;

@end

@implementation PopularVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                                                               style:UIBarButtonItemStyleDone
                                                                              target:self
                                                                              action:@selector(backToPopular)];
        
        leftBarButtonItem.tintColor = [UIColor blackColor];
        [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
        self.navigationItem.leftBarButtonItem.enabled = NO;

        /*
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Поиск"
                                                                               style:UIBarButtonItemStyleDone
                                                                              target:self
                                                                              action:@selector(searchIconButtonClicked)];
        
        rightBarButtonItem.tintColor = [UIColor blackColor];
        [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
         */
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    self.videoViewController = [[VideoViewController alloc] init];
    self.videoNavigationController = [[UINavigationController alloc] initWithRootViewController:self.videoViewController];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    //self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    [self.searchController setHidesNavigationBarDuringPresentation:NO];
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.placeholder = @"Ищи самое интересное!";
    
    //self.searchController.active = NO;
    
    self.videoTableView.delegate = self;
    self.videoTableView.dataSource = self;
    
    self.videoTableView.tableHeaderView = self.searchController.searchBar;
    
    self.videoList = [[NSMutableArray alloc] init];
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"Популярное";
    //self.navigationController.navigationBar.translucent = NO;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getPopularVideoList) forControlEvents:UIControlEventValueChanged];
    [self.videoTableView addSubview:self.refreshControl];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.playerView addGestureRecognizer:swipeDown];
    [self.playerView addGestureRecognizer:swipeDown];
    
    
    [self getPopularVideoList];
    
    }

-(void)viewWillLayoutSubviews
{
    //self.playerView.hidden = YES;
    //self.detailsView.hidden = YES;
    
    
    CGRect playerViewRect = CGRectMake(self.view.frame.size.width+10,
                                       20,
                                       self.view.frame.size.width,
                                       self.view.frame.size.width / 16 * 9 + 20);
    CGRect detailsViewRect = CGRectMake(playerViewRect.origin.x,
                                        playerViewRect.size.height,
                                        playerViewRect.size.width,
                                        self.view.frame.size.height - playerViewRect.size.height);
    
    
    /*
    CGRect playerViewRect = CGRectMake(500,
                                       0,
                                       200,
                                       300);
    CGRect detailsViewRect = CGRectMake(500,
                                        400,
                                        200,
                                        500);
    */
    
    self.playerView.frame = playerViewRect;
    
    self.detailsView.frame = detailsViewRect;
}

- (void)getPopularVideoList
{
    self.popularVideoList = [YouTubeTools popularVideoArrayWithMaxResults:@"25"
                                             withCompletitionBlock:^()
                      {
                          self.isSearch = NO;
                          [self.videoTableView reloadData];
                          [self.refreshControl endRefreshing];
                          self.navigationItem.title = @"Популярное";
                      }
                      ];
    self.isSearch = NO;
    self.rowCount = [self.popularVideoList count];
}

- (void) handleRefresh
{
    if (!self.isSearch)
        [self getPopularVideoList];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.videoList = [YouTubeTools findVideoArrayWithString:self.searchController.searchBar.text
                                                 maxResults:@"50"
                                      withCompletitionBlock:^
                      {
                          self.isSearch = YES;
                          self.navigationItem.leftBarButtonItem.enabled = YES;
                          [self.videoTableView reloadData];
                          self.navigationItem.title = @"Поиск";
                      }
                      ];
    [self.view endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

// Number of sections in tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Number of rows in sections
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearch)
        return [self.videoList count];
    else
        return [self.popularVideoList count];
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
    
    //[cell.playerView loadWithVideoId:@"M7lc1UVf-VE" playerVars:playerVars];
    YouTubeVideo *youTubeVideo;
    if (self.isSearch)
        youTubeVideo = self.videoList[indexPath.row];
    else
        youTubeVideo = self.popularVideoList[indexPath.row];

    
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
    /*
    if (self.isSearch)
        self.videoViewController.selectedVideo = self.videoList[indexPath.row];
    else
        self.videoViewController.selectedVideo = self.popularVideoList[indexPath.row];

    [self presentViewController:self.videoNavigationController animated:YES completion:nil];
     */
    
    YouTubeVideo *youTubeVideo;
    if (self.isSearch)
        youTubeVideo = self.videoList[indexPath.row];
    else
        youTubeVideo = self.popularVideoList[indexPath.row];
    
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 //@"showinfo" :@0,
                                 //@"controls" :@2,
                                 
                                 };
    
    [self.playerView loadWithVideoId:youTubeVideo.videoID playerVars:playerVars];
    [self.playerView playVideo];
    
    self.videoTitle.text = youTubeVideo.title;
    self.videoDescription.text = youTubeVideo.videoDescription;
    self.likeCount.text = youTubeVideo.likesCount;
    self.dislikeCount.text = youTubeVideo.dislikesCount;
    self.channelID.text = youTubeVideo.channelTitle;
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [UIView animateWithDuration:1.0 animations:^
    {
        CGRect playerViewRect = self.playerView.frame;
        CGRect detailsViewRect = self.detailsView.frame;
        
        playerViewRect.origin.x=0;
        self.playerView.frame = playerViewRect;
        
        detailsViewRect.origin.x=0;
        self.detailsView.frame = detailsViewRect;
        self.detailsView.alpha = 1.0;
    }];
    
}

- (void)swipeDown:(UIGestureRecognizer *)gr {
    [self minimizeMp:YES animated:YES];
}

- (void)swipeUp:(UIGestureRecognizer *)gr {
    [self minimizeMp:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)mpIsMinimized {
    return self.playerView.frame.origin.y > 50;
}


- (void)minimizeMp:(BOOL)minimized animated:(BOOL)animated {
    
    NSLog(@"X: %f Y: %f", self.playerView.frame.origin.x, self.playerView.frame.origin.y);
    if ([self mpIsMinimized] == minimized) return;
    
    CGRect tallContainerFrame, containerFrame;
    CGFloat tallContainerAlpha;
    
    if (minimized)
    {
        CGFloat mpWidth = 160;
        CGFloat mpHeight = 90; // 160:90 == 16:9
        
        CGFloat x = self.view.bounds.size.width-mpWidth-50;
        CGFloat y = self.view.bounds.size.height-mpHeight-50;
        
        NSLog(@"X: Bound:%f, Frame: %f, Position: %f", self.view.bounds.size.width, self.view.frame.size.width, x);
        NSLog(@"Y: Bound:%f, Frame: %f, Position: %f", self.view.bounds.size.height, self.view.frame.size.height, y);
        
        tallContainerFrame = CGRectMake(x, y, 320, self.view.bounds.size.height);
        containerFrame = CGRectMake(x, y, mpWidth, mpHeight);
        tallContainerAlpha = 0.0;
        
    }
    else
    {
        tallContainerFrame = self.view.bounds;
        containerFrame = CGRectMake(0, 0, 320, 180);
        tallContainerAlpha = 1.0;
    }
    NSLog(@"W: %f H: %f", self.playerView.frame.size.width, self.playerView.frame.size.height);
    containerFrame = CGRectMake(200, 350, self.playerView.frame.size.width, self.playerView.frame.size.height);
    
    NSTimeInterval duration = (animated)? 0.3 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        self.playerView.frame = containerFrame;
        //self.mpContainer.frame = containerFrame;
        self.detailsView.alpha = tallContainerAlpha;
        NSLog(@"W: %f H: %f", self.playerView.frame.size.width, self.playerView.frame.size.height);
        NSLog(@"X: %f Y: %f", self.playerView.frame.origin.x, self.playerView.frame.origin.y);
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 320;
}

- (IBAction)searchIconButtonClicked {
    if (self.searchController.active || (self.videoTableView.contentOffset.y < 44))
    {
        if (self.searchController.active)
        {
            self.searchController.searchBar.text = nil;
            [self.searchController setActive:YES];
           // [self.videoTableView reloadData];
        }
        [self hideSearchBar];
    }
    else
    {
        [self.videoTableView scrollRectToVisible:CGRectMake(100, 0, 1, 1) animated:YES];
        //CGRect searchBarFrame = self.searchController.searchBar.frame;
        //[self.tableView scrollRectToVisible:searchBarFrame animated:NO];
    }
    
}

- (void)hideSearchBar {
    //NSLog(@"Hiding SearchBar");
    //[self.videoTableView setContentOffset:CGPointMake(0,44)];
    [UIView animateWithDuration:0.5 animations:^{
        /*
        CGRect rect = self.searchController.searchBar.frame;
        rect.size.height = 0;
        self.searchController.searchBar.frame = rect;
        self.searchController.searchBar.alpha = 0.0;
         */
        
        CGRect rect2 = self.videoTableView.frame;
        rect2.origin.y = -44;
        self.videoTableView.frame = rect2;
    }];
}

-(void)backToPopular
{
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.isSearch = NO;
    self.navigationItem.title = @"Популярное";
    [self.videoTableView reloadData];
}
@end
