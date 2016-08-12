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

@property (nonatomic,strong)EMGoodsDetailModel *detailModel;

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
    self.view.backgroundColor=[UIColor redColor];
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
    
    NSArray *imageArray=@[@"http://img20.360buyimg.com/da/jfs/t3085/14/190311847/160405/fdbfef46/57a9ac53Neb4a13ae.jpg",
                          @"http://img20.360buyimg.com/da/jfs/t2731/149/4118719199/98908/2dc1fa5c/57ac3fc5N21a6c823.jpg",
                          @"http://img11.360buyimg.com/da/jfs/t3226/172/222213990/121068/a16ae9b8/57ac18a5Na40e5db1.jpg",
                          @"http://img14.360buyimg.com/da/jfs/t2974/351/2380644676/139211/50c2e8b3/57ac2a0cN345414cd.jpg",
                          @"https://img.alicdn.com/tps/i4/TB1DqXdLpXXXXcxXVXXSutbFXXX.jpg_q100.jpg",
                          @"https://aecpm.alicdn.com/simba/img/TB1_JXrLVXXXXbZXVXXSutbFXXX.jpg"];
    [_detailModel.goodsModel.goodsImageArray addObjectsFromArray:imageArray];

     self.tableView.tableHeaderView=self.infiniteView;
    [self.tableView reloadData];
}
- (void)getGoodsDetailWithGoodsID:(NSInteger)goodsID{
    WEAKSELF
    [self.tableView showPageLoadingView];
    NSURLSessionTask *task=[EMGoodsNetService getGoodsDetailWithGoodsID:goodsID onCompletionBlock:^(OCResponseResult *responseResult) {
        [weakSelf.tableView dismissPageLoadView];
        if (responseResult.responseCode==OCCodeStateSuccess) {
            weakSelf.detailModel=responseResult.responseData;
        }else{
            [weakSelf.tableView showPageLoadedMessage:@"获取数据失败,点击重试" delegate:self];
        }
    }];
    [self addSessionTask:task];
}
-(void)ocPageLoadedViewOnTouced{
    [self getGoodsDetailWithGoodsID:self.goodsID];
}
-(void)handleAppIntoForground{
   self.view.center = CGPointMake(self.view.superview.bounds.size.width/2,
                              self.view.superview.bounds.size.height/2);
//    self.view.transform=self.view.transform;;
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
    if (section==0||section==1||section==3) {
        row=1;
    }else if (section==2){
        row=2;
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
            aCell.textLabel.text=@"请选择规格、数量";
        }else if (indexPath.section==2){
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
        [cell setTitle:self.detailModel.goodsModel.goodsName price:self.detailModel.goodsModel.goodsPrice saleCount:self.detailModel.goodsModel.saleCount];
        aCell=cell;
    }
    return aCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=OCUISCALE(50);
    if (indexPath.section==0) {
        WEAKSELF
        height=[tableView fd_heightForCellWithIdentifier:kGoodsInfoCellIdenfier configuration:^(id cell) {
            [(EMGoodsInfoTableViewCell *)cell setTitle:weakSelf.goodsModel.goodsName   price:weakSelf.goodsModel.goodsPrice saleCount:weakSelf.goodsModel.saleCount];
        }];
    }else if (indexPath.section==2){
        if (indexPath.row==1) {
            
        }
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
        WEAKSELF
        __block EMGoodsSpecMaskView *maskView=[EMGoodsSpecMaskView goodsMaskViewWithGoodsDetailModel:self.detailModel onDismissBlock:^(EMGoodsSpecMaskView *aSpecMaskView) {
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
        
    }else if (indexPath.section==2) {
        if (indexPath.row==0) {
            EMGoodsCommentListController *commentListController=[[EMGoodsCommentListController alloc]  initWithGoodsID:self.goodsModel.goodsID];
            commentListController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:commentListController animated:YES];
        }
    }else if (indexPath.section==3){
        EMGoodsWebViewController *goodsWebController=[[EMGoodsWebViewController alloc]  initWithUrl:nil];
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
    NSString  *imageUrl=[self.detailModel.goodsModel.goodsImageArray objectAtIndex:index];
    cell.imageUrl=imageUrl;
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
