//
//  EMOrderDetailController.m
//  EMall
//
//  Created by Luigi on 16/7/17.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMOrderDetailController.h"
#import "EMOrderModel.h"
#import "EMCartAddressCell.h"
#import "EMShopAddressModel.h"
#import "NSAttributedString+Price.h"
#import "EMCartSubmitCell.h"
#import "EMOrderNetService.h"
#define  kSubmitCellIdenfier  @"KSubmitCellIdenfier"
#define  kAddressCellIdenfier @"kAddressCellIdenfier"
#define  kPriceCellIdenfier   @"kPriceCellIdenfier"

#define kLogisticsCellIdenfier  @"kLogisticsCellIdenfier"//物流
#define kRemarksCellIdenfier   @"kRemarksCellIdenfier"//备注

@interface EMOrderDetailController ()
@property (nonatomic,assign)NSInteger orderID;
@property (nonatomic,strong)EMOrderDetialModel *orderDetailModel;
@property (nonatomic,strong)__block EMOrderModel *orderModel;
@end

@implementation EMOrderDetailController
- (instancetype)initWithOrderID:(NSInteger )orderID{
    self=[super init];
    if (self) {
        self.orderID=orderID;
    }
    return self;
}
- (UITableView *)tableView{
    if (nil==_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[EMCartSubmitCell class] forCellReuseIdentifier:kSubmitCellIdenfier];
        
        [_tableView registerClass:[EMCartAddressCell class] forCellReuseIdentifier:kAddressCellIdenfier];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title=@"订单详情";
    [self getOrderDetailWithOrderID:self.orderID];
}
- (void)getOrderDetailWithOrderID:(NSInteger )orderID{
    [self.view showPageLoadingView];
    WEAKSELF
    NSURLSessionTask *task=[EMOrderNetService getOrderDetailWithOrderID:orderID onCompletionBlock:^(OCResponseResult *responseResult) {
        [weakSelf.view dismissPageLoadView];
        if (responseResult.responseCode==OCCodeStateSuccess) {
            weakSelf.orderModel=responseResult.responseData;
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf.view showPageLoadedMessage:@"获取数据失败" delegate:nil];
        }
    }];
    [self addSessionTask:task];
}
#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count=0;
    if (section==0) {
        count=1;
    }else if(section==2){
        count=self.orderModel.goodsArray.count;
    }else{
        count=1;
    }
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *aCell;
    if (indexPath.section==0) {
        EMCartAddressCell *cell=[tableView dequeueReusableCellWithIdentifier:kAddressCellIdenfier forIndexPath:indexPath];
        EMShopAddressModel *addressModel=[[EMShopAddressModel alloc]  init];
        addressModel.userName=self.orderModel.receiver;
        addressModel.userTel=self.orderModel.receiverTel;
        addressModel.detailAddresss=self.orderModel.receiverAddresss;
         cell.accessoryType=UITableViewCellAccessoryNone;
        cell.addresssModel=addressModel;
        aCell=cell;
    }else if (indexPath.section==1){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kLogisticsCellIdenfier];
        if (nil==cell) {
            cell=[[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kLogisticsCellIdenfier];
            cell.textLabel.textColor=kEM_LightDarkTextColor;
            cell.textLabel.font=[UIFont oc_systemFontOfSize:13];
            cell.detailTextLabel.textColor=kEM_LightDarkTextColor;
            cell.detailTextLabel.font=[UIFont oc_systemFontOfSize:13];
            cell.textLabel.text=@"配送方式";
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.detailTextLabel.text=self.orderModel.logisticsTypeString;
        aCell=cell;
    }else if (indexPath.section==2){
        EMCartSubmitCell *cell=[tableView dequeueReusableCellWithIdentifier:kSubmitCellIdenfier forIndexPath:indexPath];
        cell.orderGoodsModel=[self.orderModel.goodsArray objectAtIndex:indexPath.row];
        aCell=cell;
    }else{
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kPriceCellIdenfier];
        if (nil==cell) {
            cell=[[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kPriceCellIdenfier];
            cell.selectionStyle=UITableViewCellSelectionStyleGray;
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        
        NSInteger buyCount=0;
        for (EMOrderGoodsModel *goodsModel in _orderModel.goodsArray) {
            buyCount+=goodsModel.buyCount;
        }
        UIColor *color=[UIColor colorWithHexString:@"#272727"];
        NSMutableAttributedString *priceAttrStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%ld件商品，合计金额:",buyCount] attributes:@{NSFontAttributeName:[UIFont oc_systemFontOfSize:OCUISCALE(13)],NSForegroundColorAttributeName:color}];
        [priceAttrStr appendAttributedString:[NSAttributedString goodsPriceAttrbuteStringWithPrice:self.orderModel.totalPrice]];
        
        cell.detailTextLabel.attributedText=priceAttrStr;
        aCell=cell;
    }
    return aCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (indexPath.section==0) {

                __block EMShopAddressModel *weadAddressModel=[[EMShopAddressModel alloc]  init];
                weadAddressModel.userName=self.orderModel.receiver;
                weadAddressModel.userTel=self.orderModel.receiverTel;
                weadAddressModel.detailAddresss=self.orderModel.receiverAddresss;
                [tableView.fd_keyedHeightCache invalidateHeightForKey:kAddressCellIdenfier];
                height=[tableView fd_heightForCellWithIdentifier:kAddressCellIdenfier configuration:^(id cell) {
                    [(EMCartAddressCell *)cell setAddresssModel:weadAddressModel];
                }];


    }else if(indexPath.section==2){
        __block EMOrderGoodsModel *goodsModel=[self.orderModel.goodsArray objectAtIndex:indexPath.row];
        height=[tableView fd_heightForCellWithIdentifier:kSubmitCellIdenfier configuration:^(id cell) {
            [(EMCartSubmitCell *)cell setOrderGoodsModel:goodsModel];
        }];
    }else if(indexPath.section==1){
        height=44;
    }else{
        height=OCUISCALE(80);
    }
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
    if (nil==headView) {
        headView=[[UITableViewHeaderFooterView alloc]  initWithReuseIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
        headView.textLabel.font=[UIFont oc_systemFontOfSize:13];
        headView.textLabel.textColor=kEM_LightDarkTextColor;
    }
    NSString *title=@"";
    if (section==0) {
        title=@"收货地址";
    }else if (section==1){
        title=@"配送方式";
    }else if (section==2){
        title=@"商品列表";
    }else if(section==3){
        title=@"订单总价";
    }
    
    headView.textLabel.text=title;
    return headView;
}



@end
