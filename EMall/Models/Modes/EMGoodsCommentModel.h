//
//  EMGoodsCommentModel.h
//  EMall
//
//  Created by Luigi on 16/7/27.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseModel.h"

@interface EMGoodsCommentModel : OCBaseModel
@property (nonatomic,copy)NSString *commentID;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *userID;
@property (nonatomic,copy)NSString *nickName,*userAvatar;

@property (nonatomic,copy)NSString *goodsID;
@property (nonatomic,copy)NSString *goodsSize;
@property (nonatomic,copy)NSString *goodColor;
@property (nonatomic,assign)NSInteger level;//评级
@property (nonatomic,copy,readonly)NSString *levelString;
@property (nonatomic,assign)long long commentTime;//评论时间
@end
