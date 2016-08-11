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
@property (nonatomic,strong)EMGoodsSpecView *specView;
@end

@implementation EMGoodsSpecMaskView
- (void)dealloc{
    NSLog(@"%@ is dealloc",self);
}
+ (EMGoodsSpecMaskView *)goodsMaskViewOnDismissBlock:(EMGoodsSpecMaskViewDismissBlock)dismissBlock{
    EMGoodsSpecMaskView *aView=[[EMGoodsSpecMaskView alloc]  initWithFrame:[[UIScreen mainScreen] bounds]];
    [aView addSubview:aView.specView];
    aView.dismissBlock=dismissBlock;
    return  aView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return self;
}

- (void)presemtSpecView{
    self.specView.frame=[EMGoodsSpecView specFrame];
    [self addSubview:self.specView];
}
- (void)dismissSpecView{
    CGRect rect=[EMGoodsSpecView specFrame];
    rect.origin.y=OCHeight;
    self.specView.frame=rect;
}
- (void)finishedDismiss{
    [self.specView removeFromSuperview];
    self.specView=nil;
    [self removeFromSuperview];
}
- (EMGoodsSpecView *)specView{
    if (nil==_specView) {
        _specView=[EMGoodsSpecView specGoodsViewWithGoodInfo:nil onDismsiBlock:^(EMGoodsSpecView *specView, BOOL addCart, NSInteger goodsID, NSInteger buyCount, NSInteger sepecID) {
            if (self.dismissBlock) {
                self.dismissBlock(self);
            }
        }];
    }
    return _specView;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    WEAKSELF
    if (self.dismissBlock) {
        self.dismissBlock(weakSelf);
    }
}
@end
