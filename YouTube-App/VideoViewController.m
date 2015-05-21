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
@property (strong, nonatomic) IBOutlet UIView *mpContainer;

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
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.mpContainer addGestureRecognizer:swipeUp];
    [self.mpContainer addGestureRecognizer:swipeDown];

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
    return self.youTubePlayer.frame.origin.y > 0;
}

- (void)minimizeMp:(BOOL)minimized animated:(BOOL)animated {
    
    if ([self mpIsMinimized] == minimized) return;
    
    CGRect tallContainerFrame, containerFrame;
    CGFloat tallContainerAlpha;
    
    if (minimized) {
        CGFloat mpWidth = 160;
        CGFloat mpHeight = 90; // 160:90 == 16:9
        
        CGFloat x = 320-mpWidth;
        CGFloat y = self.view.bounds.size.height - mpHeight;
        
        tallContainerFrame = CGRectMake(x, y, 320, self.view.bounds.size.height);
        containerFrame = CGRectMake(x, y, mpWidth, mpHeight);
        tallContainerAlpha = 0.0;
        
    } else {
        tallContainerFrame = self.view.bounds;
        containerFrame = CGRectMake(0, 0, 320, 180);
        tallContainerAlpha = 1.0;
    }
    
    NSTimeInterval duration = (animated)? 0.5 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        self.youTubePlayer.frame = tallContainerFrame;
        self.mpContainer.frame = containerFrame;
        self.youTubePlayer.alpha = tallContainerAlpha;
    }];
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
    
    //[self.view mini]
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
