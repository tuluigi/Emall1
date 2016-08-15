//
//  EMOrderGoodsCommentController.m
//  EMall
//
//  Created by Luigi on 16/8/15.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMOrderGoodsCommentController.h"
#import "UIPlaceHolderTextView.h"
@interface EMOrderGoodsCommentController ()
@property (nonatomic,assign)NSInteger goodsID,orderID;
@property (nonatomic,strong)NSString *imageUrl;
@property (nonatomic,strong)UIPlaceHolderTextView *placeHolderImageView;
@end

@implementation EMOrderGoodsCommentController
- (instancetype)initWithGoodsID:(NSInteger)goodsID orderID:(NSInteger)orderID goodsImageUrl:(NSString *)imageUrl{
    self=[super init];
    self.orderID=orderID;
    self.goodsID=goodsID;
    self.imageUrl=imageUrl;
    return self;
}
@end
