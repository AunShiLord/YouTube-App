//
//  YouTubeVideo.m
//  YouTube-App
//
//  Created by Admin on 19.05.15.
//  Copyright (c) 2015 AShi. All rights reserved.
//

#import "YouTubeVideo.h"

@implementation YouTubeVideo

- (void) testPrint
{
    NSLog(@"1) %@\n2) %@\n3) %@\n4) %@\n5) %@\n6) %@\n7) %@\n8) %@\n9) %@\n10) %@\n",
          self.title, self.videoDescription, self.previewUrl, self.videoID,
          self.publishedAt, self.duration,
          self.viewsCount, self.likesCount, self.dislikesCount, self.commentCount);
}

@end
