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
static NSString *const kGoodsCommonCellIdenfier = @"kGoodsCommonCellIdenfier";
static NSString *const kGoodsInfoCellIdenfier = @"kGoodsInfoCellIdenfier";
@interface EMGoodsDetailViewController ()<EMGoodsDetialBootmViewDelegate>
@property (nonatomic,strong)UIButton *backButton;
@property (nonatomic,strong)UIImageView *headImageView;

@property (nonatomic,strong)EMGoodsModel *goodsModel;
@property (nonatomic,strong)EMGoodsDetialBootmView *bottomView;
@end

@implementation EMGoodsDetailViewController
- (instancetype)initWithGoodsID:(NSInteger )goodsID{
    self=[super init];
    if (self) {
        self.tableViewStyle=UITableViewStyleGrouped;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor redColor];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden=YES;
    [self.view addSubview:self.backButton];
    [self.view bringSubviewToFront:self.backButton];
    self.tableView.tableHeaderView=self.headImageView;
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
        make.edges.mas_equalTo(UIEdgeInsetsMake(-20, 0, OCUISCALE(50),0 ));
    }];
     EMGoodsModel  * agoodsModel=[[EMGoodsModel alloc] init];
    agoodsModel.goodsImageUrl=@"http://pic31.nipic.com/20130710/13151003_093759013311_2.jpg";
    agoodsModel.goodsName=@"这是一件很好的商品，新款上市了，大家赶紧来看看啊看";
    agoodsModel.goodsPrice=123;
    agoodsModel.saleCount=134;
    agoodsModel.commentCount=3455;
    self.goodsModel=agoodsModel;

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
                aCell.textLabel.text=[NSString stringWithFormat:@"商品评价 (%@)",[NSString tenThousandUnitString:self.goodsModel.commentCount]];
            }else if (indexPath.row ==1){
                aCell.textLabel.font=[UIFont oc_systemFontOfSize:12];
                aCell.textLabel.textColor=[UIColor colorWithHexString:@"#5d5c5c"];
               
                aCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                aCell.textLabel.text=[NSString stringWithFormat:@"评价:%@         %@\n%@",@"好评",@"xiaoli",@"这个东西真好用，哈哈哈，大家杆件都来购买呀"];
            }
        }else if (indexPath.section==3){
             aCell.textLabel.text=@"商品详情";
             aCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
    }else if(indexPath.section==0){
        EMGoodsInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kGoodsInfoCellIdenfier forIndexPath:indexPath];
        [cell setTitle:self.goodsModel.goodsName price:self.goodsModel.goodsPrice saleCount:self.goodsModel.saleCount];
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
        EMGoodsSpecView *specView=[EMGoodsSpecView specGoodsView];
        [self.view addSubview:specView];
        WEAKSELF
        [specView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(weakSelf.view);
            make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
            make.height.mas_equalTo(OCUISCALE(400));
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
//        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
