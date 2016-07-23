//
//  NSAttributedString+Price.m
//  EMall
//
//  Created by Luigi on 16/7/22.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "NSAttributedString+Price.h"

@implementation NSAttributedString (Price)
+ (NSAttributedString *)goodsPriceAttrbuteStringWithPrice:(CGFloat)price{
    UIColor *textColor=[UIColor colorWithHexString:@"#e51e0e"];
    NSAttributedString *markAtrr=[[NSAttributedString alloc]  initWithString:@"￥" attributes:@{NSFontAttributeName:[UIFont oc_systemFontOfSize:OCUISCALE(8)]}];
    
    NSInteger priceInteger=(NSInteger)price;
    NSInteger pointeInteger=price-priceInteger;
    
//    NSDictionary *priceDic=@{NSFontAttributeName:[UIFont oc_systemFontOfSize:OCUISCALE(13)],NSForegroundColorAttributeName:textColor};
    NSAttributedString *priceIntegerAttr=[[NSAttributedString alloc]  initWithString:[NSString stringWithFormat:@"%ld",priceInteger] attributes:@{NSFontAttributeName:[UIFont oc_systemFontOfSize:OCUISCALE(13)]}];
    NSAttributedString *pricePointerAttr=[[NSAttributedString alloc]  initWithString:[NSString stringWithFormat:@".%.2ld",pointeInteger] attributes:@{NSFontAttributeName:[UIFont oc_systemFontOfSize:OCUISCALE(8)]}];
    
    NSMutableAttributedString *resultAttr=[[NSMutableAttributedString alloc] initWithAttributedString:markAtrr];
    [resultAttr appendAttributedString:priceIntegerAttr];
    [resultAttr appendAttributedString:pricePointerAttr];
    [resultAttr addAttributes:@{NSForegroundColorAttributeName:textColor} range:NSMakeRange(0, resultAttr.length)];
    return resultAttr;
}
@end
