//
//  NSString+VideoDuration.h
//  OpenCourse
//
//  Created by Luigi on 15/12/3.
//
//

#import <Foundation/Foundation.h>

@interface NSString (VideoDuration)
/**
 *  将视频秒转化为时分秒字符串; 格式如下： 01时10分20秒
 *
 *  @param videoSeconds 总时长,单位秒
 *
 *  @return  格式化后字符串
 */
+ (NSString *)durationDataStingWithVideoSeconds:(CGFloat)videoSeconds;

/**
 *  将视频秒精确到时分  格式如下： 01:10
 *
 *  @param videoSeconds 总时长,单位秒
 *
 *  @return 格式化后字符串
 */
+ (NSString *)hourMinuteStingWithVideoSeconds:(CGFloat)videoSeconds;

/**
 *  将数字转化为以万为单位的字符串
 *
 *  @param numberValue 数字
 *
 *  @return 字符串
 */
+ (NSString *)tenThousandUnitString:(NSInteger)numberValue;

+ (NSString *)byteStringFormatted:(unsigned long long)byte;
@end
