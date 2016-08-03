//
//  NSString+Encrypt.h
//  EMall
//
//  Created by Luigi on 16/8/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encrypt)
- (NSString *)md5String;

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;


- (NSString *)decodeBase64String;
- (NSString *)base64EncodedString;
@end
