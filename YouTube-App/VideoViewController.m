//
//  VideoViewController.m
//  YouTube-App
//
//  Created by Admin on 19.05.15.
//  Copyright (c) 2015 AShi. All rights reserved.
//

#import "VideoViewController.h"
#import "YTPlayerView.h"
#import "YouTubeVideo.h"

@interface VideoViewController ()
@property (strong, nonatomic) IBOutlet YTPlayerView *youTubePlayer;

@end

@implementation VideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(back)];
        
        leftBarButtonItem.tintColor = [UIColor blackColor];
        [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    CGRect youTubePlayerFrame = CGRectMake(self.youTubePlayer.frame.origin.x,
                                           self.youTubePlayer.frame.origin.y,
                                           self.view.frame.size.width,
                                           self.view.frame.size.width);
    self.youTubePlayer.frame = youTubePlayerFrame;
    
    [super viewWillAppear:animated];
    
    [self.youTubePlayer loadWithVideoId:self.selectedVideo.videoID];
    [self.youTubePlayer playVideo];
}

- (IBAction)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
