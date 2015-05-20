//
//  YouTubeVideo.h
//  YouTube-App
//
//  Created by Admin on 19.05.15.
//  Copyright (c) 2015 AShi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YouTubeVideo : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *videoDescription;
@property (strong, nonatomic) NSString *previewUrl;
@property (strong, nonatomic) NSString *videoID;

@property (strong, nonatomic) NSString *publishedAt;
@property (strong, nonatomic) NSString *duration;

@property (strong, nonatomic) NSString *viewsCount;
@property (strong, nonatomic) NSString *likesCount;
@property (strong, nonatomic) NSString *dislikesCount;
@property (strong, nonatomic) NSString *commentCount;

- (void)testPrint;

@end
