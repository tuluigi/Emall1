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
    NSAttributedString *resultAttr=[NSAttributedString goodsPriceAttrbuteStringWithPrice:price markFontSize:8 priceInterFontSize:13 pointInterSize:8 color:[UIColor colorWithHexString:@"#e51e0e"]];
    return resultAttr;
}
+ (NSAttributedString *)goodsPriceAttrbuteStringWithPrice:(CGFloat)price markFontSize:(CGFloat)markSize priceInterFontSize:(CGFloat)priceIntegerSize pointInterSize:(CGFloat)pointSize color:(UIColor *)color{
    UIColor *textColor=color;
    if (nil==textColor) {
        textColor=  [UIColor colorWithHexString:@"#e51e0e"];
    }
  
    if (!markSize) {
        markSize=8;
    }
    if (!priceIntegerSize) {
        priceIntegerSize=13;
    }
    if (!pointSize) {
        pointSize=8;
    }
    NSAttributedString *markAtrr=[[NSAttributedString alloc]  initWithString:@"$" attributes:@{NSFontAttributeName:[UIFont oc_systemFontOfSize:OCUISCALE(markSize)]}];
    
    NSInteger priceInteger=(NSInteger)price;
    NSInteger pointeInteger=(price-priceInteger)*10;
    
    //    NSDictionary *priceDic=@{NSFontAttributeName:[UIFont oc_systemFontOfSize:OCUISCALE(13)],NSForegroundColorAttributeName:textColor};
    NSAttributedString *priceIntegerAttr=[[NSAttributedString alloc]  initWithString:[NSString stringWithFormat:@"%ld",priceInteger] attributes:@{NSFontAttributeName:[UIFont oc_systemFontOfSize:OCUISCALE(priceIntegerSize)]}];
    NSAttributedString *pricePointerAttr=[[NSAttributedString alloc]  initWithString:[NSString stringWithFormat:@".%.1ld",pointeInteger] attributes:@{NSFontAttributeName:[UIFont oc_systemFontOfSize:OCUISCALE(pointSize)]}];
    
    NSMutableAttributedString *resultAttr=[[NSMutableAttributedString alloc] initWithAttributedString:markAtrr];
    [resultAttr appendAttributedString:priceIntegerAttr];
    [resultAttr appendAttributedString:pricePointerAttr];
    [resultAttr addAttributes:@{NSForegroundColorAttributeName:textColor} range:NSMakeRange(0, resultAttr.length)];
    return resultAttr;

}
@end
