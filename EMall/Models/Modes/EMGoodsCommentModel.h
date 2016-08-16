//
//  EMGoodsCommentModel.h
//  EMall
//
//  Created by Luigi on 16/7/27.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseModel.h"

@interface EMCommentStarModel : OCBaseModel
@property (nonatomic,assign)NSInteger star,startNum,index;
@property (nonatomic,copy)NSString *starString;
@end

@interface EMGoodsCommentModel : OCBaseModel
@property (nonatomic,assign)NSInteger commentID;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,assign)NSInteger userID;
@property (nonatomic,copy)NSString *nickName,*userAvatar;

@property (nonatomic,assign)NSInteger goodsID;
@property (nonatomic,assign)NSInteger level;//评级 1,2,3
@property (nonatomic,copy,readonly)NSString *levelString;
@property (nonatomic,copy)NSString *commentTime;//评论时间
@end

@interface EMGoodsCommentHomeModel :OCBaseModel
@property (nonatomic,strong)NSMutableArray *commentArray,*startArray;

@end