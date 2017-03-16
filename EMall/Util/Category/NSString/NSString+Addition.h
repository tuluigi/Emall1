//
//  NSString+Addition.h
//  OpenCourse
//
//  Created by Luigi on 15/8/26.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)
/**
 *  根据字符串内容自动计算宽高
 *
 *  @param font     文本的字体
 *  @param maxTextSize 最大宽高
 *
 *  @return cgSize
 */
- (CGSize)boundingRectWithfont:(UIFont *)font maxTextSize:(CGSize)maxTextSize;
- (CGSize)boundingFontLeadingRectWithfont:(UIFont *)font maxTextSize:(CGSize)maxTextSize;
+(NSString *)stringByReplaceNullString:(NSString *)aString;
/**
 *  是否是邮箱格式
 *
 *  @return
 */
- (BOOL)isValidateEmail;
- (NSString *)removeSufferEmail;

- (BOOL)isBlankString;

//根据中英文判断字符长度
- (NSInteger)numberOfStringInByte;

//根据中英文 中英文标点 判断字符串长度
- (NSInteger)integerNumberConvertByMixString;
@end
