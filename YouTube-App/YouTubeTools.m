//
//  YouTubeTools.m
//  YouTube-App
//
//  Created by Admin on 20.05.15.
//  Copyright (c) 2015 AShi. All rights reserved.
//

#import "YouTubeTools.h"
#import "YouTubeVideo.h"
#import "AFNetworking.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation YouTubeTools

+ (NSString *) developerKey
{
    return @"AIzaSyASGR2chwqKEFBWxbrk-PkbH9wgWBwHIXg";
}

+ (NSMutableArray *) popularVideoArrayWithMaxResults:(NSString *) maxResults
                               withCompletitionBlock:(void (^)() )reloadData;
{
    // getting json from YouTube API
    NSString *playlistID = @"PLgMaGEI-ZiiZ0ZvUtduoDRVXcU5ELjPcI";
    NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%%2CcontentDetails&maxResults=%@&playlistId=%@&fields=items%%2Fsnippet&key=%@", maxResults, playlistID, [self developerKey]];
    
    NSLog(@"URL: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableArray *videoList = [[NSMutableArray alloc] init];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON Retrieved");

         NSDictionary *items = [responseObject objectForKey:@"items"];
         for (NSDictionary *item in items )
         {
             YouTubeVideo *youTubeVideo = [[YouTubeVideo alloc] init];
             NSDictionary* snippet = [item objectForKey:@"snippet"];
             youTubeVideo.title = [snippet objectForKey:@"title"];
             youTubeVideo.videoID = [[snippet objectForKey:@"resourceId"]objectForKey:@"videoId"];
             youTubeVideo.previewUrl = [[[snippet objectForKey:@"thumbnails"] objectForKey:@"high"] objectForKey:@"url"];
             //youTubeVideo .videoDate =[snippet objectForKey:@"publishedAt"];
             [videoList addObject:youTubeVideo];
         }
         reloadData();
         
         //[self.tableView reloadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Video playlist"
                                                             message:[error localizedDescription]
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
         [alertView show];
     }];
    
    // 5
    [operation start];
    return videoList;
}

// finding
+ (NSMutableArray *) findVideoArrayWithString:(NSString *) string
                                   maxResults:(NSString *) maxResults
                        withCompletitionBlock:(void (^)() ) reloadData;
{
    return nil;
}

+ (YouTubeVideo *) detailedVideoInfoForId: (NSString *) videoId
{
    
    // getting json from YouTube API
    NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?part=snippet%%2CcontentDetails%%2Cstatistics&id=%@&key=%@",videoId, [self developerKey]];
    
    NSLog(@"URL: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         YouTubeVideo *youTubeVideo = [[YouTubeVideo alloc] init];
         NSDictionary *items = [responseObject objectForKey:@"items"];
         for (NSDictionary *item in items )
         {
             NSDictionary* snippet = [item objectForKey:@"snippet"];
             NSDictionary* contentDetails = [item objectForKey:@"contentDetails"];
             NSDictionary* statistics = [item objectForKey:@"statistics"];
             
             youTubeVideo.videoID = [item objectForKey:@"id"];
             
             youTubeVideo.title = [snippet objectForKey:@"title"];
             youTubeVideo.videoDescription = [snippet objectForKey:@"description"];
             youTubeVideo.publishedAt = [snippet objectForKey:@"publishedAt"];
             if ([[[snippet objectForKey:@"thumbnails"] objectForKey:@"high"] objectForKey:@"url"])
                 youTubeVideo.previewUrl = [[[snippet objectForKey:@"thumbnails"] objectForKey:@"high"] objectForKey:@"url"];
             else
                 [[[snippet objectForKey:@"thumbnails"] objectForKey:@"medium"] objectForKey:@"url"];
             
             youTubeVideo.duration = [contentDetails objectForKey:@"duration"];
             
             youTubeVideo.viewsCount = [statistics objectForKey:@"viewCount"];
             youTubeVideo.likesCount = [statistics objectForKey:@"likeCount"];
             youTubeVideo.dislikesCount = [statistics objectForKey:@"dislikeCount"];
             youTubeVideo.commentCount = [statistics objectForKey:@"commentCount"];
             
             [youTubeVideo testPrint];
         }
         
         //return youTubeVideo;
         
         //[self.tableView reloadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Video"
                                                             message:[error localizedDescription]
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
         [alertView show];
        
     }];
    
    return nil;
}

#pragma system method
// first request
-(RACSignal*)signalGetNetworkStep1 {
    NSURL* url = ...;
    return [RACSignal createSignal:^(RACDisposable *(id subscriber) {
        NSURLRequest *request1 = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation1 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [subscriber sendNext:JSON];
            [subscriber sendCompleted];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            [subscriber sendError:error];
        }];
        [operation1 start];
        return nil;
    }
                                     }

@end
