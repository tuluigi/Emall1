//
//  EMOrderGoodsCommentController.m
//  EMall
//
//  Created by Luigi on 16/8/15.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMOrderGoodsCommentController.h"
#import "UIPlaceHolderTextView.h"
#import "EMGoodsNetService.h"

#define  kStartButtonTag        10000
#define  kTotalStarNum   5

@interface EMOrderGoodsCommentController ()<UITextViewDelegate>
@property (nonatomic,assign)NSInteger goodsID,orderID;
@property (nonatomic,strong)NSString *imageUrl;
@property (nonatomic,strong)UIPlaceHolderTextView *textView;
@property (nonatomic,strong)UIImageView *goodsImageView;
@end

@implementation EMOrderGoodsCommentController
- (instancetype)initWithGoodsID:(NSInteger)goodsID orderID:(NSInteger)orderID goodsImageUrl:(NSString *)imageUrl{
    self=[super init];
    self.orderID=orderID;
    self.goodsID=goodsID;
    self.imageUrl=imageUrl;
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationItem.title=@"发表评论";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]  initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonPressed)];
    self.navigationItem.rightBarButtonItem.enabled=NO;
    [self.view addSubview:self.textView];
    [self.view addSubview:self.goodsImageView];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:EMDefaultImage];
    WEAKSELF
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(OCUISCALE(kEMOffX));
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(OCUISCALE(kEMOffX));
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(OCUISCALE(-kEMOffX));
        make.height.mas_equalTo(OCUISCALE(80));
    }];
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.textView.mas_left);
        make.top.mas_equalTo(weakSelf.textView.mas_bottom).offset(10);
        make.size.mas_equalTo(OCUISCALE(80),OCUISCALE(60));
    }];
    UIView *lastView=self.goodsImageView;
    for (NSInteger i=1; i<=kTotalStarNum; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.selected=YES;
        [button setBackgroundImage:[UIImage imageNamed:@"btn_star"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_star_selected"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(didStartButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=kStartButtonTag+i;
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lastView.mas_right).offset(10);
            make.centerY.mas_equalTo(lastView.mas_centerY);
        }];
        lastView=button;
    }
    
}
- (void)didStartButtonPressed:(UIButton *)sender{
    NSInteger index=sender.tag-kStartButtonTag;
    for (NSInteger i=1; i<=5; i++) {
        UIButton *button=(UIButton *)[self.view viewWithTag:kStartButtonTag+i];
        if (i<=index) {
            button.selected=YES;
        }else{
            button.selected=NO;
        }
    }
}
- (void)didRightBarButtonPressed{
    WEAKSELF
    NSInteger level=1;
    for (NSInteger i=kTotalStarNum; i>=1; i--) {
        UIButton *button=(UIButton *)[self.view viewWithTag:kStartButtonTag+i];
        if (button.selected) {
            level=i;
            break;
        }
    }
    [weakSelf.view showHUDLoading];
    NSURLSessionTask *task=[EMGoodsNetService writeComemntWithUsrID:[RI userID] orderID:self.orderID goodID:self.goodsID content:self.textView.text star:level onCompletionBlock:^(OCResponseResult *responseResult) {
        if (responseResult.responseCode==OCCodeStateSuccess) {
            [weakSelf.view showHUDMessage:@"评论成功" completionBlock:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [weakSelf.view showHUDMessage:@"评论失败"];
        }
    }];
    [self addSessionTask:task];
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>=2) {
        self.navigationItem.rightBarButtonItem.enabled=YES;
    }else{
        self.navigationItem.rightBarButtonItem.enabled=NO;
    }
}
-(UIPlaceHolderTextView *)textView{
    if (nil==_textView) {
        _textView=[[UIPlaceHolderTextView alloc]  init];
        _textView.placeholderColor=kEM_LightDarkTextColor;
        _textView.placeHolderLabel.font=[UIFont oc_systemFontOfSize:13];
        _textView.font=[UIFont oc_systemFontOfSize:14];
        _textView.delegate=self;
        _textView.layer.borderColor=RGB(225, 225, 225).CGColor;
        _textView.layer.borderWidth=0.5;
        _textView.layer.cornerRadius=4;
        _textView.layer.masksToBounds=YES;
        _textView.placeholder=@"客官，购买的宝贝可还符合您心意？快来告诉海购君~";
        [_textView becomeFirstResponder];
    }
    return _textView;
}
-(UIImageView *)goodsImageView{
    if (nil==_goodsImageView) {
        _goodsImageView=[UIImageView new];
    }
    return _goodsImageView;
}
@end
