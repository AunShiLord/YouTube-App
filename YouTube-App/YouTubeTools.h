//
//  YouTubeTools.h
//  YouTube-App
//
//  Created by Admin on 20.05.15.
//  Copyright (c) 2015 AShi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YouTubeVideo;

@interface YouTubeTools : NSObject

+ (NSString *) developerKey;

// methods to return list of video
+ (NSMutableArray *) popularVideoArrayWithMaxResults:(NSString *) maxResults
                               withCompletitionBlock:(void (^)() ) reloadData;


+ (NSMutableArray *) findVideoArrayWithString:(NSString *) string
                                   maxResults:(NSString *) maxResults
                        withCompletitionBlock:(void (^)() ) reloadData;

+ (YouTubeVideo *) detailedVideoInfoForId: (NSString *) videoId;
@end
