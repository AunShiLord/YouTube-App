//
//  AppDelegate.m
//  YouTube-App
//
//  Created by Admin on 18.05.15.
//  Copyright (c) 2015 AShi. All rights reserved.
//

#import "AppDelegate.h"
#import "PopularVideoViewController.h"
#import "SearchVideoViewController.h"
#import "VideoViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //NewsListViewController *newsList = [[NewsListViewController alloc] init];
    NSString *developerKey = @"AIzaSyASGR2chwqKEFBWxbrk-PkbH9wgWBwHIXg";
    
    PopularVideoViewController *popularVideoViewController = [[PopularVideoViewController alloc] init];
    popularVideoViewController.DEV_KEY = developerKey;
    //popularVideoViewController.videoViewController = videoViewController;
    //popularVideoViewController.videoNavigationController = videoNavigationController;
    UINavigationController *popularVideoNavigationController = [[UINavigationController alloc] initWithRootViewController:popularVideoViewController];
    popularVideoNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"Популярное" image:nil selectedImage:nil];
    
    SearchVideoViewController *searchVideoViewController = [[SearchVideoViewController alloc] init];
    searchVideoViewController.DEV_KEY = developerKey;
    //searchVideoViewController.videoViewController = videoViewController;
    //searchVideoViewController.videoNavigationController = videoNavigationController;
    UINavigationController *searchVideoNavigationController = [[UINavigationController alloc] initWithRootViewController:searchVideoViewController];
    searchVideoNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"Поиск" image:nil selectedImage:nil];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[popularVideoNavigationController, searchVideoNavigationController]];
    [tabBarController.tabBar setBarTintColor:[UIColor redColor]];
    
    //self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-568h_2x.png"]];
    [self.window makeKeyAndVisible];
    [self.window setRootViewController:tabBarController];
    
    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
