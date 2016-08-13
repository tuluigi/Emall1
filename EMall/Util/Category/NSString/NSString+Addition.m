//
//  NSString+Addition.m
//  OpenCourse
//
//  Created by Luigi on 15/8/26.
//
//

#import "NSString+Addition.h"

@implementation NSString (Addition)
/**
 *  根据字符串内容自动计算宽高
 *
 *  @param font     文本的字体
 *  @param maxTextSize 最大宽高
 *
 *  @return cgSize
 */
- (CGSize)boundingRectWithfont:(UIFont *)font maxTextSize:(CGSize)maxTextSize
{
    CGSize contentSize;
    if ([[[UIDevice currentDevice]  systemVersion] floatValue]>=7.0) {
        contentSize=[self boundingRectWithSize:maxTextSize options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size;
    }else{
#ifdef __IPHONE_6_0
        contentSize=[self sizeWithFont:font constrainedToSize:maxTextSize];
#endif
    }
    return contentSize;
}
- (CGSize)boundingFontLeadingRectWithfont:(UIFont *)font maxTextSize:(CGSize)maxTextSize{
    CGSize contentSize;
    if ([[[UIDevice currentDevice]  systemVersion] floatValue]>=7.0) {
        contentSize=[self boundingRectWithSize:maxTextSize options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size;
    }else{
#ifdef __IPHONE_6_0
        contentSize=[self sizeWithFont:font constrainedToSize:maxTextSize];
#endif
    }
    return contentSize;

}
+(NSString *)stringByReplaceNullString:(NSString *)aString {
    if ((NSNull *) aString == [NSNull null]) {
        aString= @"";
    }
    if (aString == nil) {
        aString= @"";
    } else if ([aString length] == 0) {
        return @"";
    } else {
        aString = [aString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([aString length] == 0) {
            aString= @"";
        }
    }
    return aString;
}
- (BOOL)isValidateEmail
{
    NSString *regex = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}




- (NSString *)removeSufferEmail{
    NSString *newStr=self;
    BOOL isEamlil=[self isValidateEmail];
    if (isEamlil) {
        NSArray *tempArray=[self componentsSeparatedByString:@"@"];
        if (tempArray&&tempArray.count) {
            NSString *str=[@"@" stringByAppendingString:[tempArray lastObject]];
            newStr=[self stringByReplacingOccurrencesOfString:str withString:@""];
        }
    }
    return newStr;
}

- (BOOL)isBlankString {
    if (self == nil) {
        return YES;
    }
    
    if (self == NULL) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSNull class]]) {
        return  YES;
    }
    
    if ([self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return YES;
    }
    
    return NO;
}

- (NSInteger)numberOfStringInByte {
    NSUInteger  character = 0;
    for(int i=0; i< [self length];i++){
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){ //判断是否为中文
            character +=2;
        }else{
            character +=1;
        }
    }
    return character;
}

- (NSInteger)integerNumberConvertByMixString {
    NSInteger strlength = 0;
    char * p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}



@end
