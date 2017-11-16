//
//  EMHtmlFile.m
//  EMall
//
//  Created by netease on 2017/11/16.
//  Copyright © 2017年 Luigi. All rights reserved.
//

#import "EMHtmlFile.h"

@implementation EMHtmlFile
+ (NSString *)htmlStringWithVideoSrc:(NSString *)videoSrc poster:(NSString *)poster{
    NSString *path =[[NSBundle mainBundle] pathForResource:@"em_video" ofType:@"html"];
    NSError *error;
    NSString *htmlString = [[NSString alloc] initWithContentsOfFile:path encoding:4 error:&error];
    if (htmlString.length &&nil==error) {
        if (videoSrc.length) {
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"EM_VIDEO_SRC" withString:videoSrc];
        }
        
        if (poster.length) {
            htmlString = [htmlString stringByReplacingOccurrencesOfString:@"EM_VIDEO_POSTER_SRC" withString:poster];
        }
        
    }
    return htmlString;
}
@end
