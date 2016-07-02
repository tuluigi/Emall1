//
//  NSString+Utility.m
//  Edu901iPhone
//
//  Created by user on 14-2-17.
//  Copyright (c) 2014年 user. All rights reserved.
//

#import "NSString+Utility.h"
#import <CoreText/CoreText.h>

@implementation NSString (Utility)

- (UIColor *)colorWithHexString {
    NSString *hex = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    if ([hex hasPrefix:@"#"]) {
        hex = [hex substringFromIndex:1];
    }
    // strip 0X if it appears
    else if ([hex hasPrefix:@"0X"]) {
        hex = [hex substringFromIndex:2];
    }
    else {
        hex = hex;
    }
    
    NSUInteger length = hex.length;
    // Separate into r, g, b substrings
    NSRange range = NSMakeRange(0, 0);
    NSString *rString = nil;
    NSString *gString = nil;
    NSString *bString = nil;
    unsigned int r, g, b;

    if (length == 3) {
        range.length = 1;
        rString = [hex substringWithRange:range];
        rString = [NSString stringWithFormat:@"%@%@", rString, rString];
        range.location = 1;
        gString = [hex substringWithRange:range];
        gString = [NSString stringWithFormat:@"%@%@", gString, gString];
        range.location = 2;
        bString = [hex substringWithRange:range];
        bString = [NSString stringWithFormat:@"%@%@", bString, bString];
    }
    else if (length == 6) {
        range.length = 2;
        rString = [hex substringWithRange:range];
        range.location = 2;
        gString = [hex substringWithRange:range];
        range.location = 4;
        bString = [hex substringWithRange:range];
    }
    else {
        return [UIColor grayColor];
    }

    // Scan values
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (NSUInteger)numberOfMatchesNonChineseCharacterSet {
    return [NSString numberOfMatchesNonChineseCharacterSetInString:self];
}


- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)self,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8));
    return result;
}

- (NSString *)URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                             (CFStringRef)self,
                                                                                                             CFSTR(""),
                                                                                                             kCFStringEncodingUTF8));
    return result;
}


- (NSString *)removeSpaceOfTyping {
    const unichar replace[1] = {0x2006};//Chinese Input Method special space while typing.
    NSString *str = [NSString stringWithCharacters:replace length:1];
    NSString *ret = nil;
    ret = [self stringByReplacingOccurrencesOfString:str withString:@""];
    ret = [ret stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return ret;
}

- (CGSize)sizeWithFont:(UIFont *)font inSize:(CGSize)size {
    CGSize s = CGSizeZero;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        s = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    else {
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary * attributes = @{NSFontAttributeName : font,
                                      NSParagraphStyleAttributeName : paragraphStyle};
        s = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |
                                                    NSStringDrawingUsesFontLeading
                            attributes:attributes
                               context:nil].size;
    }
    
    return s;
}

- (CGSize)sizeWithFont:(UIFont *)font inSize:(CGSize)size lineSpacing:(CGFloat)lineSpace
{
    CGSize contentSize;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle};
    contentSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    return contentSize;
}

- (CGSize)sizeWithFont:(UIFont *)font inSize:(CGSize)size lineSpacing:(CGFloat)lineSpace characterSpacing:(long)characterSpace lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize contentSize;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    if (lineSpace) {
        paragraphStyle.lineSpacing = lineSpace;
    }
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSMutableDictionary *attributesDic = [[NSMutableDictionary alloc] initWithDictionary:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle}];
    long kerning=[OCUIUtil kerningWithFontSize:font.pointSize fontRatio:characterSpace];
    if (kerning) {
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &kerning);
        [attributesDic setObject:(__bridge id)num forKey:(id)kCTKernAttributeName];
    }
    contentSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributesDic context:nil].size;
    
    return contentSize;
}

- (CGSize)sizeWithFont:(UIFont *)font inSize:(CGSize)size lineSpacing:(CGFloat)lineSpace characterSpacing:(long)characterSpace
{
    return [self sizeWithFont:font inSize:size lineSpacing:lineSpace characterSpacing:characterSpace lineBreakMode:NSLineBreakByCharWrapping];
}

+ (BOOL)isNilOrEmptyForString:(NSString *)aString {
    if ([aString isEqual:[NSNull null]] || !aString || !aString.length) {
        return YES;
    }
    return NO;
}

+ (NSUInteger)numberOfMatchesNonChineseCharacterSetInString:(NSString *)aString {
    if ([self isNilOrEmptyForString:aString]) {
        return 0;
    }
    
    NSString *pattern = @"[^\u4E00-\u9FFF]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:aString
                                                        options:0
                                                          range:NSMakeRange(0, [aString length])];
    return numberOfMatches;
}


+ (NSString *)playTimeString:(int )seconds
{
	int s = seconds % 60;
	int m = (seconds - s)/60 % 60;
	int h = (seconds - s - m*60)/3600;
	return [NSString stringWithFormat:@"%02d:%02d:%02d",h,m,s];
}
- (NSString *)encode64String
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    return base64String;
}
- (NSString *)decodedWith64String
{
    NSData *dataFrom64String = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSString *base64DecodeString = [[NSString alloc] initWithData:dataFrom64String encoding:NSUTF8StringEncoding];
    return base64DecodeString;
}


@end
