//
//  OCGoodsCommentModel.h
//  EMall
//
//  Created by Luigi on 16/7/26.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseModel.h"

@interface OCGoodsCommentModel : OCBaseModel
@property (nonnull,strong)NSString *commentID;
@property (nonnull,strong)NSString *content;
@property (nonnull,strong)NSString *userID;
@property (nonnull,strong)NSString *nickName,*userAvatar;

@property (nonnull,strong)NSString *goodsID;
@property (nonnull,strong)NSString *goodsSize;
@property (nonnull,strong)NSString *goodColor;
@end
