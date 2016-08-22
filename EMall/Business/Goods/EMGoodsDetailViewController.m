//
//  EMGoodsDetailViewController.m
//  EMall
//
//  Created by Luigi on 16/7/24.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsDetailViewController.h"
#import "EMGoodsInfoTableViewCell.h"
#import "EMGoodsModel.h"
#import "NSString+VideoDuration.h"
#import "EMGoodsDetialBootmView.h"
#import "EMGoodsCommentListController.h"
#import "EMGoodsWebViewController.h"
#import "EMGoodsSpecView.h"
#import "EMGoodsSpecMaskView.h"
#import "EMGoodsNetService.h"
#import "EMInfiniteView.h"
#import "EMImagePickBrowserHelper.h"
#import "EMShopCartNetService.h"
#import "EMServiceController.h"

#import <MediaPlayer/MPMoviePlayerViewController.h>
#import <AVKit/AVPlayerViewController.h>
static NSString *const kGoodsCommonCellIdenfier = @"kGoodsCommonCellIdenfier";
static NSString *const kGoodsInfoCellIdenfier = @"kGoodsInfoCellIdenfier";
@interface EMGoodsDetailViewController ()<EMGoodsDetialBootmViewDelegate,OCPageLoadViewDelegate,EMInfiniteViewDelegate>
@property (nonatomic,strong)UIButton *backButton;
@property (nonatomic,strong)UIImageView *headImageView;
@property (nonatomic,strong)EMInfiniteView *infiniteView;

@property (nonatomic,strong)EMGoodsModel *goodsModel;
@property (nonatomic,strong)EMGoodsDetialBootmView *bottomView;
@property (nonatomic,assign)__block CGAffineTransform tramsform;

@property (nonatomic,strong)EMGoodsModel *aGoodsModel;
@property (nonatomic,assign)NSInteger goodsID;

@property (nonatomic,strong)__block EMGoodsDetailModel *detailModel;

@end

@implementation EMGoodsDetailViewController
- (instancetype)initWithGoodsID:(NSInteger )goodsID{
    self=[super init];
    if (self) {
        self.goodsID=goodsID;
        self.tableViewStyle=UITableViewStyleGrouped;
    }
    return self;
}
- (instancetype)initWithGoodsModel:(EMGoodsModel * )goodsModel{
    self=[self initWithGoodsID:goodsModel.goodsID];
    self.goodsModel=goodsModel;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden=YES;
    [self.view addSubview:self.backButton];
    [self.view bringSubviewToFront:self.backButton];
    
    WEAKSELF
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(OCUISCALE(32));
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(OCUISCALE(kEMOffX));
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(37), OCUISCALE(37)));
    }];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(OCUISCALE(50));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting=YES;
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, OCUISCALE(50),0 ));
    }];
    UIEdgeInsets contentInset=self.tableView.contentInset;
    contentInset.top-=20;
    self.tableView.contentInset=contentInset;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.tramsform=weakSelf.view.transform;
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppIntoForground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
    [self getGoodsDetailWithGoodsID:self.goodsID];
}
- (void)setDetailModel:(EMGoodsDetailModel *)detailModel{
    _detailModel=detailModel;
    if (_detailModel) {
        [self getGoodsSpecListWithGoodsID:_detailModel.goodsModel.goodsID];
    }
    self.tableView.tableHeaderView=self.infiniteView;
    [self.tableView reloadData];
}
- (void)getGoodsDetailWithGoodsID:(NSInteger)goodsID{
    WEAKSELF
    [self.tableView showPageLoadingView];
    self.bottomView.hidden=YES;
    NSURLSessionTask *task=[EMGoodsNetService getGoodsDetailWithGoodsID:goodsID onCompletionBlock:^(OCResponseResult *responseResult) {
        [weakSelf.tableView dismissPageLoadView];
        if (responseResult.responseCode==OCCodeStateSuccess) {
            weakSelf.bottomView.hidden=NO;
            weakSelf.detailModel=responseResult.responseData;
        }else{
            [weakSelf.tableView showPageLoadedMessage:@"获取数据失败,点击重试" delegate:self];
        }
    }];
    [self addSessionTask:task];
}
- (void)getGoodsSpecListWithGoodsID:(NSInteger)goodsID{
    WEAKSELF
    NSURLSessionTask *task=[EMGoodsNetService getGoodsSpeListWithGoodsID:self.goodsID onCompletionBlock:^(OCResponseResult *responseResult) {
        if (responseResult.responseCode==OCCodeStateSuccess) {
            [weakSelf.detailModel.goodsSpecListArray removeAllObjects];
            [weakSelf.detailModel.goodsSpecListArray addObjectsFromArray:responseResult.responseData];
        }
    }];
    [self addSessionTask:task];
}
-(void)ocPageLoadedViewOnTouced{
    [self getGoodsDetailWithGoodsID:self.goodsID];
}
- (void)addShopCartWithGoodsID:(NSInteger)goodsID infoID:(NSInteger)specID buyCount:(NSInteger)buyCount{
    WEAKSELF
    if ([RI isLogined]) {
        [self.view showHUDLoading];
        NSURLSessionTask *task=[EMShopCartNetService addShopCartWithUserID:[RI userID] infoID:specID buyCount:buyCount onCompletionBlock:^(OCResponseResult *responseResult) {
            //        [weakSelf.view dismissHUDLoading];
            if (responseResult.responseCode==OCCodeStateSuccess) {
                [weakSelf.view showHUDMessage:@"添加到购物车成功"];
            }else{
                [weakSelf.view showHUDMessage:@"添加失败"];
            }
        }];
        [self addSessionTask:task];
    }else{
        [self showLoginControllerOnCompletionBlock:^(BOOL isSucceed) {
            if (isSucceed) {
                [weakSelf addShopCartWithGoodsID:goodsID infoID:specID buyCount:buyCount];
            }
        }];
    }
}

-(void)handleAppIntoForground{
    self.view.center = CGPointMake(self.view.superview.bounds.size.width/2,
                                   self.view.superview.bounds.size.height/2);
    //    self.view.transform=self.view.transform;;
}
- (void)playGoodsDetailVideoWithUrl:(NSString *)urlString{
    //   urlString=@"http://mov.bn.netease.com/open-movie/nos/mp4/2016/08/09/SBT4C26SI_sd.mp4";
    if (![NSString isNilOrEmptyForString:urlString]) {
        NSURL *url=[NSURL URLWithString:urlString];
        AVPlayerViewController *playerController=[[AVPlayerViewController alloc]  init];
        AVPlayer *avplayer=[AVPlayer playerWithURL:url];
        [avplayer play];
        playerController.player=avplayer;
        [self presentViewController:playerController animated:YES completion:^{
            
        }];
    }else{
        [self.tableView showHUDMessage:@"视频无法播放"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didBackButtonPressed:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kGoodsCommonCellIdenfier];
    [self.tableView registerClass:[EMGoodsInfoTableViewCell class] forCellReuseIdentifier:kGoodsInfoCellIdenfier];
    
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row=0;
    if (section==0||section==3) {
        row=1;
    }else if (section==2){
        row=2;
    }else if (section==1){
        if (![NSString isNilOrEmptyForString:self.detailModel.goodsModel.videoUrl]) {//有视频的
            row=2;
        }else{
            row=1;
        }
    }
    return row;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *aCell;
    if (indexPath.section==2||indexPath.section==1||indexPath.section==3) {
        aCell=[tableView dequeueReusableCellWithIdentifier:kGoodsCommonCellIdenfier forIndexPath:indexPath];
        aCell.selectionStyle=UITableViewCellSelectionStyleNone;
        aCell.textLabel.font=[UIFont oc_systemFontOfSize:14];
        aCell.textLabel.textColor=[UIColor colorWithHexString:@"#272727"];
        aCell.textLabel.textAlignment=NSTextAlignmentLeft;
        aCell.accessoryType=UITableViewCellAccessoryNone;
        aCell.textLabel.numberOfLines=0;
        if (indexPath.section==1) {
            aCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.row==0) {
                aCell.textLabel.textColor=kEM_RedColro;
                aCell.textLabel.text=@"请选择规格、数量";
            }else{
                aCell.textLabel.text=@"分享视频";
            }
        }else if (indexPath.section==2){
            aCell.textLabel.textColor=[UIColor colorWithHexString:@"#272727"];
            if (indexPath.row==0) {
                aCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                aCell.textLabel.text=[NSString stringWithFormat:@"商品评价 (%@)",[NSString tenThousandUnitString:self.detailModel.goodsModel.commentCount]];
            }else if (indexPath.row ==1){
                aCell.textLabel.font=[UIFont oc_systemFontOfSize:12];
                aCell.textLabel.textColor=[UIColor colorWithHexString:@"#5d5c5c"];
                
                aCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                aCell.textLabel.text=[NSString stringWithFormat:@"评价:%@         %@\n%@",@"好评",stringNotNil(self.detailModel.goodsModel.userName),stringNotNil(self.detailModel.goodsModel.commentContent)];
            }
        }else if (indexPath.section==3){
            aCell.textLabel.text=@"商品详情";
            aCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
        }
    }else if(indexPath.section==0){
        EMGoodsInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kGoodsInfoCellIdenfier forIndexPath:indexPath];
        CGFloat price=0;
        if (self.detailModel) {
            price=self.detailModel.defaultGoodsInfo.goodsPrice;
            NSString *title=self.detailModel.goodsModel.goodsName;
            [cell setTitle:title price:price promotionPrice:self.detailModel.defaultGoodsInfo.promotionPrice  saleCount:self.detailModel.goodsModel.saleCount];
        }
        
        aCell=cell;
    }
    return aCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=OCUISCALE(50);
    if (indexPath.section==0) {
        WEAKSELF
        CGFloat price=0;
        height=[tableView fd_heightForCellWithIdentifier:kGoodsInfoCellIdenfier configuration:^(id cell) {
            [(EMGoodsInfoTableViewCell *)cell setTitle:weakSelf.detailModel.goodsModel.goodsName   price:price promotionPrice:0  saleCount:weakSelf.detailModel.goodsModel.saleCount];
        }];
    }
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height=CGFLOAT_MIN;
    if (section) {
        height=OCUISCALE(10);
    }
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            WEAKSELF
            __block EMGoodsSpecMaskView *maskView=[EMGoodsSpecMaskView goodsMaskViewWithGoodsDetailModel:self.detailModel onDismissBlock:^(EMGoodsSpecMaskView *aSpecMaskView, NSInteger info, NSInteger buyCount) {
                if (buyCount) {
                    [weakSelf addShopCartWithGoodsID:weakSelf.goodsID infoID:info buyCount:buyCount];
                }
                [UIView animateWithDuration:0.3 animations:^{
                    [aSpecMaskView dismissSpecView];
                    weakSelf.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
                } completion:^(BOOL finished) {
                    [aSpecMaskView finishedDismiss];
                }];
            }];
            
            
            
            [UIView animateWithDuration:0.3 animations:^{
                self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.85,0.85);
                [[UIApplication sharedApplication].keyWindow addSubview:maskView];
                [maskView presemtSpecView];
            } completion:^(BOOL finished) {
                
            }];
        }else if (indexPath.row==1){
            [self playGoodsDetailVideoWithUrl:self.detailModel.goodsModel.videoUrl];
        }
        
    }else if (indexPath.section==2) {
        if (indexPath.row==0) {
            EMGoodsCommentListController *commentListController=[[EMGoodsCommentListController alloc]  initWithGoodsID:self.detailModel.goodsModel.goodsID star:0];
            commentListController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:commentListController animated:YES];
        }
    }else if (indexPath.section==3){
        EMGoodsWebViewController *goodsWebController=[[EMGoodsWebViewController alloc]  initWithHtmlString:self.detailModel.goodsModel.goodsDetails];
        goodsWebController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:goodsWebController animated:YES];
    }
}
#pragma mark -EMInfiniteVieDelegate
- (NSInteger)numberOfInfiniteViewCellsInInfiniteView:(EMInfiniteView *)infiniteView{
    NSInteger count= self.detailModel.goodsModel.goodsImageArray.count;
    return count;
}

- (EMInfiniteViewCell *)infiniteView:(EMInfiniteView *)infiniteView cellForRowAtIndex:(NSInteger)index{
    NSString *idenfier=NSStringFromClass([EMInfiniteViewCell class]);
    EMInfiniteViewCell *cell=(EMInfiniteViewCell *)[infiniteView dequeueReusableCellWithReuseIdentifier:idenfier atIndex:index];
    if (index<self.detailModel.goodsModel.goodsImageArray.count) {
        NSString  *imageUrl=[self.detailModel.goodsModel.goodsImageArray objectAtIndex:index];
        cell.imageUrl=imageUrl;
    }else{
        cell.imageUrl=nil;
    }
    return cell;
}
- (void)infiniteView:(EMInfiniteView *)infiniteView didSelectRowAtIndex:(NSInteger)index{
    NSMutableArray *imageArray=[[NSMutableArray alloc]  init];
    for (NSString *imageUrl in self.detailModel.goodsModel.goodsImageArray) {
        MWPhoto *photo=[MWPhoto photoWithURL:[NSURL URLWithString:imageUrl]];
        [imageArray addObject:photo];
    }
    [EMImagePickBrowserHelper showImageBroswerOnController:self withImageArray:imageArray currentIndex:index];
}
#pragma mark - bottomview delegate
- (void)goodsDetialBootmViewSubmitButtonPressed{
    if ([RI isLogined]) {
        if (self.detailModel.goodsInfoArray.count) {
            EMGoodsInfoModel *infoModel=[self.detailModel.goodsInfoArray firstObject];
            [self addShopCartWithGoodsID:self.goodsID infoID:infoModel.infoID buyCount:1];
        }else{
            [self.view showHUDMessage:@"商品数据错误"];
        }
    }else{
        WEAKSELF
        [self showLoginControllerOnCompletionBlock:^(BOOL isSucceed) {
            [weakSelf goodsDetialBootmViewSubmitButtonPressed];
        }];
    }
}
- (void)goodsDetialBootmViewServiceItemPressed{
    EMServiceController *serviceController=[[EMServiceController alloc]  initWithStyle:UITableViewStyleGrouped];
    serviceController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:serviceController animated:YES];
}
#pragma  mark - getter setter
- (void)setGoodsModel:(EMGoodsModel *)goodsModel{
    _goodsModel=goodsModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_goodsModel.goodsImageUrl] placeholderImage:EMDefaultImage];
    [self.tableView reloadData];
}
- (UIButton *)backButton{
    if (nil==_backButton) {
        _backButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"goods_backBtn"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(didBackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UIImageView *)headImageView{
    if (nil==_headImageView) {
        _headImageView=[[UIImageView alloc]  initWithFrame:CGRectMake(0, 0, OCWidth, OCUISCALE(333))];
        _headImageView.contentMode=UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds=YES;
    }
    return _headImageView;
}
- (EMGoodsDetialBootmView *)bottomView{
    if (nil==_bottomView) {
        _bottomView=[[EMGoodsDetialBootmView alloc]  init];
        _bottomView.delegate=self;
    }
    return _bottomView;
}
-(EMInfiniteView *)infiniteView{
    if (nil==_infiniteView) {
        _infiniteView=[[EMInfiniteView alloc]  initWithFrame:CGRectMake(0, 0, OCWidth, OCUISCALE(333))];
        [_infiniteView registerClass:[EMInfiniteViewCell class] forCellWithReuseIdentifier:NSStringFromClass([EMInfiniteViewCell class])];
        _infiniteView.delegate=self;
    }
    return _infiniteView;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
