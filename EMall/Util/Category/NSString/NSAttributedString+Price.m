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
    NSAttributedString *resultAttr=[NSAttributedString goodsPriceAttrbuteStringWithPrice:price markFontSize:13 priceInterFontSize:17 pointInterSize:13 color:[UIColor colorWithHexString:@"#e51e0e"]];
    return resultAttr;
}
+ (NSAttributedString *)goodsPriceAttrbuteStringWithPrice:(CGFloat)price promotePrice:(CGFloat)promotePrice{
    NSAttributedString *attrString=[self goodsPriceAttrbuteStringWithPrice:promotePrice];
    if (promotePrice) {
          NSAttributedString *att0=[NSAttributedString horizontalLineAttrStringWithText:[NSString stringWithFormat:@"$%.1f",price] textColor:[UIColor colorWithHexString:@"#e51e0e"] font:[UIFont oc_systemFontOfSize:10]];
        NSMutableAttributedString *mutbleAttr=[[NSMutableAttributedString alloc] initWithAttributedString:attrString];
        NSAttributedString *spaceAttr=[[NSAttributedString alloc]  initWithString:@"  "];
        [mutbleAttr appendAttributedString:spaceAttr];
        [mutbleAttr appendAttributedString:att0];
        attrString=mutbleAttr;
    }
    return attrString;
}
+ (NSAttributedString *)goodsPriceAttrbuteStringWithPrice:(CGFloat)price markFontSize:(CGFloat)markSize priceInterFontSize:(CGFloat)priceIntegerSize pointInterSize:(CGFloat)pointSize color:(UIColor *)color{
    UIColor *textColor=color;
    if (nil==textColor) {
        textColor=  [UIColor colorWithHexString:@"#e51e0e"];
    }
  
    if (!markSize) {
        markSize=13;
    }
    if (!priceIntegerSize) {
        priceIntegerSize=17;
    }
    if (!pointSize) {
        pointSize=13;
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
+(NSAttributedString *)horizontalLineAttrStringWithText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font{
    NSMutableAttributedString *priceAttrStr=[[NSMutableAttributedString alloc]  initWithString:text attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleNone)}];
    NSDictionary *priceDic=@{
                             NSForegroundColorAttributeName:color,NSFontAttributeName:font,
                             NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    [priceAttrStr addAttributes:priceDic range:NSMakeRange(0, text.length)];
    return priceAttrStr;
}
@end
