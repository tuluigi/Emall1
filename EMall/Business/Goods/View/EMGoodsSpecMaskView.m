//
//  EMGoodsSpecMaskView.m
//  EMall
//
//  Created by Luigi on 16/8/11.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsSpecMaskView.h"
#import "EMGoodsSpecView.h"


@interface EMGoodsSpecMaskView ()
@property (nonatomic,copy)EMGoodsSpecMaskViewDismissBlock dismissBlock;
@end

@implementation EMGoodsSpecMaskView
+ (EMGoodsSpecMaskView *)goodsSpecMaskViewWithGoodsInfo:(id)goodsInfo onDismsiBlock:(EMGoodsSpecMaskViewDismissBlock)dismisBlock{
    EMGoodsSpecMaskView *aView=[[EMGoodsSpecMaskView alloc]  initWithFrame:[[UIScreen mainScreen] bounds]];
    aView.dismissBlock=dismisBlock;
    EMGoodsSpecView *specView=[EMGoodsSpecView specGoodsViewWithGoodInfo:goodsInfo onDismsiBlock:^(BOOL addCart, NSInteger goodsID, NSInteger buyCount, NSInteger sepecID) {
        if (aView.dismissBlock) {
            aView.dismissBlock(addCart,goodsID,buyCount,sepecID);
        }
    }];
    CGRect frame=specView.frame;
    frame.origin.y=CGRectGetHeight(specView.bounds)-frame.size.height;
    specView.frame=frame;
    [aView addSubview:specView];
    return  aView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor blackColor];
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(handleTapGesture)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}
- (void)handleTapGesture{
    if (self.dismissBlock) {
        self.dismissBlock(NO,0,0,0);
    }
}
@end
