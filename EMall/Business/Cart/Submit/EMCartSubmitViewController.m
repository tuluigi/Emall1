//
//  EMCartSubmitViewController.m
//  EMall
//
//  Created by Luigi on 16/7/23.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMCartSubmitViewController.h"
#import "EMShopCartModel.h"
#import "EMCartBottomView.h"
#import "EMCartSubmitCell.h"
#import "EMShopAddressModel.h"
#import "EMCartAddressCell.h"
#import "UITableView+FDKeyedHeightCache.h"
#import "NSAttributedString+Price.h"
#import "EMShoppingAddressListController.h"
#import "EMCartPayViewController.h"
#import "EMOrderNetService.h"
#import "EMMeNetService.h"
#import "EMOrderModel.h"
#import "OCUTableCellHeader.h"
#import "EMGoodsPostageFootView.h"
#define  kSubmitCellIdenfier  @"KSubmitCellIdenfier"
#define  kAddressCellIdenfier @"kAddressCellIdenfier"
#define  kPriceCellIdenfier   @"kPriceCellIdenfier"

#define kLogisticsCellIdenfier  @"kLogisticsCellIdenfier"//物流
#define kRemarksCellIdenfier   @"kRemarksCellIdenfier"//备注

#define kEMCartSubmitRemarkCellType     200

@interface EMCartSubmitViewController ()<EMCartBottomViewDelegate,EMShoppingAddressListControllerDelegate>
@property (nonatomic,strong)__block EMShopAddressModel *addressModel;
@property (nonatomic,strong)EMCartBottomView *bottomView;
@property (nonatomic,assign)CGFloat addressCellheight;
@property (nonatomic,assign)__block EMOrderLogisticsType logisticType;
@property (nonatomic,strong)__block OCTableCellTextViewModel *detailTextViewModel;
@end
//xjphsd
@implementation EMCartSubmitViewController

- (void)setCartArray:(NSArray *)cartArray{
    [self.dataSourceArray addObjectsFromArray:cartArray];
   
    // Do any additional setup after loading the view.
}
- (UITableView *)tableView{
    if (nil==_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[EMCartSubmitCell class] forCellReuseIdentifier:kSubmitCellIdenfier];
        
        [_tableView registerClass:[EMCartAddressCell class] forCellReuseIdentifier:kAddressCellIdenfier];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (EMCartBottomView *)bottomView{
    if (nil==_bottomView) {
        _bottomView=[EMCartBottomView bottomCartViewDisableSelelct:YES];
        _bottomView.delegate=self;
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self onInitContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onInitContentView{
    self.navigationItem.title=@"确认订单";
    [self.view addSubview:self.bottomView];
    self.logisticType=EMOrderLogisticsTypeUnKonwn;
    WEAKSELF
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(OCUISCALE(50));
    }];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.removeExisting=YES;
        make.top.left.right.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.bottomView.mas_top);
    }];
//    UIEdgeInsets inset= self.tableView.contentInset;
//    inset.bottom+=OCUISCALE(50);
//    self.tableView.contentInset=inset;
    
    _detailTextViewModel=[[OCTableCellTextViewModel alloc] initWithTitle:@"备注" imageName:nil accessoryType:UITableViewCellAccessoryNone type:kEMCartSubmitRemarkCellType];
    
    _detailTextViewModel.placeHoleder=@"请填写订单备注";
    
    
    self.addressModel=[[EMShopAddressModel alloc]  init];
    self.addressModel.userName=@"收货人";
    self.addressModel.userTel=@"收货人电话";
    self.addressModel.wechatID=@"";
    self.addressModel.detailAddresss=@"请选择收货地址";
    self.addressModel.addressID=-1;
    [self reloadData];
    [self getUserDefaultShoppingAddress];
}
- (void)reloadData{
    [self.bottomView updateCartBottomWithSelectItemCount:self.dataSourceArray.count totalItems:self.dataSourceArray.count totalPrice:[self totalPrice]];
    [self.tableView reloadData];
}
- (CGFloat)totalPrice{
    CGFloat totalPrice=0;
    for (EMShopCartModel *model in self.dataSourceArray) {
        if (!model.unSelected) {
            totalPrice+=(model.promotionPrice)*model.buyCount;
        }
    }
    return totalPrice;
}
- (void)getUserDefaultShoppingAddress{
    WEAKSELF
    NSURLSessionTask *task=[EMMeNetService getShoppingAddressListWithUrseID:[RI userID] onCompletionBlock:^(OCResponseResult *responseResult) {
        if (responseResult.responseCode==OCCodeStateSuccess) {
            NSArray *array=responseResult.responseData;
            if (array.count) {
                NSPredicate *predicate=[NSPredicate predicateWithFormat:@"_state=1"];
                NSArray *tempArray=[array filteredArrayUsingPredicate:predicate];
                if (tempArray&&tempArray.count) {
                    weakSelf.addressModel=[tempArray firstObject];
                    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
        }
    }];
    [weakSelf addSessionTask:task];
}
#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count=0;
    if (section==0) {
        count=1;
    }else if(section==2){
        count=self.dataSourceArray.count;
    }else{
        count=1;
    }
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *aCell;
    if (indexPath.section==0) {
        EMCartAddressCell *cell=[tableView dequeueReusableCellWithIdentifier:kAddressCellIdenfier forIndexPath:indexPath];
        cell.addresssModel=self.addressModel;
        aCell=cell;
    }else if (indexPath.section==1){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kLogisticsCellIdenfier];
        if (nil==cell) {
            cell=[[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kLogisticsCellIdenfier];
            cell.textLabel.textColor=kEM_RedColro;
            cell.textLabel.font=[UIFont oc_systemFontOfSize:13];
            cell.detailTextLabel.textColor=kEM_LightDarkTextColor;
            cell.detailTextLabel.font=[UIFont oc_systemFontOfSize:13];
            cell.textLabel.text=@"请选择取货方式";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        if (self.logisticType==EMOrderLogisticsTypeExpress) {
              cell.detailTextLabel.text=@"快递送货";
        }else if(self.logisticType==EMOrderLogisticsTypeSelfPickUp){
              cell.detailTextLabel.text=@"Box Hill自取";
        }else{
            cell.detailTextLabel.text=@"";
        }
        aCell=cell;
    }else if (indexPath.section==2){
        EMCartSubmitCell *cell=[tableView dequeueReusableCellWithIdentifier:kSubmitCellIdenfier forIndexPath:indexPath];
        cell.shopCartModel=[self.dataSourceArray objectAtIndex:indexPath.row];
        aCell=cell;
    }else if(indexPath.section==3){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kPriceCellIdenfier];
        if (nil==cell) {
            cell=[[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kPriceCellIdenfier];
            cell.selectionStyle=UITableViewCellSelectionStyleGray;
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        UIColor *color=[UIColor colorWithHexString:@"#272727"];
        NSString *logsticPriceString=@"";
        if (self.logisticType==EMOrderLogisticsTypeExpress) {
            //logsticPriceString=[NSString stringWithFormat:@"运费:$%.1f，",self.postagePrice];
        }
        NSMutableAttributedString *priceAttrStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%ld件商品，%@合计金额:",self.dataSourceArray.count,logsticPriceString] attributes:@{NSFontAttributeName:[UIFont oc_systemFontOfSize:OCUISCALE(13)],NSForegroundColorAttributeName:color}];
        [priceAttrStr appendAttributedString:[NSAttributedString goodsPriceAttrbuteStringWithPrice:[self totalPrice]]];
        
        cell.detailTextLabel.attributedText=priceAttrStr;
        aCell=cell;
    }else{
        OCUTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[self.detailTextViewModel reusedCellIdentifer]];
        if (nil==cell) {
            cell= [self.detailTextViewModel cellWithReuseIdentifer:[self.detailTextViewModel reusedCellIdentifer]];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.cellModel=self.detailTextViewModel;
        aCell=cell;
    }
    return aCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (indexPath.section==0) {
        if (self.addressCellheight) {
            height=self.addressCellheight;
        }else{
            if (self.addressModel) {
                __block EMShopAddressModel *weadAddressModel=self.addressModel;
                [tableView.fd_keyedHeightCache invalidateHeightForKey:kAddressCellIdenfier];
                height=[tableView fd_heightForCellWithIdentifier:kAddressCellIdenfier configuration:^(id cell) {
                    [(EMCartAddressCell *)cell setAddresssModel:weadAddressModel];
                }];
                self.addressCellheight=height;
            }else{
                height=OCUISCALE(50);
            }
        }
    }else if(indexPath.section==2){
        __block EMShopCartModel *cartModel=[self.dataSourceArray objectAtIndex:indexPath.row];
        height=[tableView fd_heightForCellWithIdentifier:kSubmitCellIdenfier configuration:^(id cell) {
            [(EMCartSubmitCell *)cell setShopCartModel:cartModel];
        }];
    }else if(indexPath.section==1){
        height=44;
    }else if(indexPath.section==4){
        height=OCUISCALE(80);
    }else{
        height=OCUISCALE(80);
    }
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        EMShoppingAddressListController *addressController=[[EMShoppingAddressListController alloc]  init];
        addressController.delegate=self;
        addressController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:addressController animated:YES];
    }else if (indexPath.section==1){//配送方式
        WEAKSELF
        UIAlertController *alertController=[[UIAlertController alloc]  init];
        alertController.title=@"选择取货方式";
        UIAlertAction *menAction=[UIAlertAction actionWithTitle:@"快递送货" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.logisticType=EMOrderLogisticsTypeExpress;
            [weakSelf reloadData];
        }];
        UIAlertAction *womenAction=[UIAlertAction actionWithTitle:@"Box Hill自取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             weakSelf.logisticType=EMOrderLogisticsTypeSelfPickUp;
            [weakSelf reloadData];
        }];
        UIAlertAction *cancleAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancleAction];
        [alertController addAction:menAction];
        [alertController addAction:womenAction];
        [self presentViewController:alertController  animated:YES completion:^{
            
        }];
    }
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
    }else if (section==4){
        title=@"订单备注";
    }
   
    headView.textLabel.text=title;
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat height=CGFLOAT_MIN;
    if (section==1&&self.logisticType==EMOrderLogisticsTypeExpress) {
        height=35;
    }
    return height;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1&&self.logisticType==EMOrderLogisticsTypeExpress) {
        EMGoodsPostageFootView *headView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([EMGoodsPostageFootView class])];
        if (nil==headView) {
            headView=[[EMGoodsPostageFootView alloc]  initWithReuseIdentifier:NSStringFromClass([EMGoodsPostageFootView class])];
        }
        return headView;
    }else{
        return nil;
    }

}
- (void)submitOrderWithShopCartModels:(NSArray *)shopCartArrays addressID:(NSInteger)addressID logiticType:(NSInteger)type remarks:(NSString *)remarks{
    if (addressID<0) {
        [self.view showHUDMessage:@"请选择收货地址"];
    }else if (self.logisticType==EMOrderLogisticsTypeUnKonwn){
        [self.view showHUDMessage:@"请选择配送方式"];
    }else{
    WEAKSELF
    [self.view showHUDLoading];
    remarks=[remarks stringByRemovingEmoji];
    NSURLSessionTask *task=[EMOrderNetService submitWithUserID:[RI userID] shopCarts:shopCartArrays addressID:addressID logisticType:type remark:remarks onCompletionBlock:^(OCResponseResult *responseResult) {
        if (responseResult.responseCode==OCCodeStateSuccess) {
            [weakSelf.view dismissHUDLoading];
            EMOrderModel *orderModel=responseResult.responseData;
            
            EMCartPayViewController *payController=[[EMCartPayViewController alloc]  initWithTotalPrice:orderModel.payPrice-orderModel.discountPrice  orderNum:orderModel.orderNumber];
            payController.hidesBottomBarWhenPushed=YES;
            [weakSelf.navigationController pushViewController:payController animated:YES];
        }else{
            [weakSelf.view showHUDMessage:responseResult.responseMessage];
        }
    }];
    [self addSessionTask:task];
    }
}
#pragma mark -bottomView select
//提交订单
- (void)cartBottomViewSubmitButtonPressed:(EMCartBottomView *)bottomView{
    
    [self submitOrderWithShopCartModels:self.dataSourceArray addressID:self.addressModel.addressID logiticType:self.logisticType remarks:self.detailTextViewModel.inputText];
}
#pragma  mark -address
- (void)shopAddressListControlerDidSelectAddress:(EMShopAddressModel *)addressModel{
    
    self.addressModel=addressModel;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
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
