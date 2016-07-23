//
//  NSAttributedString+Price.h
//  EMall
//
//  Created by Luigi on 16/7/22.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Price)
//根据price生成attr price 
+ (NSAttributedString *)goodsPriceAttrbuteStringWithPrice:(CGFloat)price;
@end
