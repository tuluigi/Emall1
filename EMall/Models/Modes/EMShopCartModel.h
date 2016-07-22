//
//  EMShopCartModel.h
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseModel.h"

@interface EMShopCartModel : OCBaseModel
@property(nonatomic,copy)NSString *cartID;
@property(nonatomic,copy)NSString *goodsID;
@property(nonatomic,copy)NSString *goodsName;
@property(nonatomic,copy)NSString *goodsImageUrl;
@property(nonatomic,assign)CGFloat goodsPrice;

@property(nonatomic,assign)NSInteger buyCount;
@property (nonatomic,assign)CGFloat totalPrice;
@property (nonatomic,copy)NSString *spec;//尺寸
@property (nonatomic,assign)BOOL unSelected;//default is no
@end
