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
#import "EMCartChoosePayView.h"
#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"

#define  kSubmitCellIdenfier  @"KSubmitCellIdenfier"
#define  kAddressCellIdenfier @"kAddressCellIdenfier"
#define  kPriceCellIdenfier   @"kPriceCellIdenfier"

#define kLogisticsCellIdenfier  @"kLogisticsCellIdenfier"//物流
#define kRemarksCellIdenfier   @"kRemarksCellIdenfier"//备注

// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
// - For testing, use PayPalEnvironmentNoNetwork.

//#define kPayPalEnvironment PayPalEnvironmentNoNetwork
//#define kPayPalEnvironment PayPalEnvironmentSandbox
#define kPayPalEnvironment PayPalEnvironmentProduction

#define kEMCartSubmitRemarkCellType     200

#define WIDTH  [[UIScreen mainScreen]bounds].size.width
#define HEIGHT [[UIScreen mainScreen]bounds].size.height
#define ChoosePayViewHeight HEIGHT/2

@interface EMCartSubmitViewController ()<EMCartBottomViewDelegate,EMShoppingAddressListControllerDelegate,ChoosePayViewDelegate,PayPalPaymentDelegate>
{
    EMOrderModel *orderModel ;
    NSString *getAppJson ;
}
@property (nonatomic,strong)__block EMShopAddressModel *addressModel;
@property (nonatomic,strong)EMCartBottomView *bottomView;
@property (nonatomic,assign)CGFloat addressCellheight;
@property (nonatomic,assign)__block EMOrderLogisticsType logisticType;
@property (nonatomic,strong)__block OCTableCellTextViewModel *detailTextViewModel;
@property (nonatomic,strong)EMCartChoosePayView *choosePayView ;

@property (nonatomic,strong, readwrite) PayPalConfiguration *payPalConfig ;
@property (nonatomic,strong) NSString *PayEnvironment ;
@property (nonatomic,strong) NSString *PayResulText ;
@property (nonatomic,strong) UIView *successView ;

@end
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

- (PayPalConfiguration *)payPalConfig
{
    if (nil == _payPalConfig) {
        _payPalConfig = [[PayPalConfiguration alloc] init] ;
        _payPalConfig.acceptCreditCards = NO ;
        _payPalConfig.merchantName = @"E-STAR(AUST)PTY LTD" ;
        _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
        _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
        _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
        _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal ;
        self.PayEnvironment = kPayPalEnvironment ;
        NSLog(@"PayPal environment = %@",self.PayEnvironment) ;
        self.successView.hidden = YES ;
        NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
    }
    return _payPalConfig ;
}

- (UIView *)successView
{
    if (nil==_successView) {
        _successView = [[UIView alloc] init] ;
    }
    return _successView ;
}

#pragma mark - 初始化选择支付界面
- (EMCartChoosePayView *)createChoosePayView
{
    if (!_choosePayView) {
        self.choosePayView = [[EMCartChoosePayView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, ChoosePayViewHeight) withTitle:@"请选择支付方式" withType:1] ;
        CGFloat totlePrice = [self totalPrice] ;
        self.choosePayView.totalPrice = totlePrice ;
        self.choosePayView.delegate = self ;
    }
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate ;
    [delegate.window addSubview:_choosePayView] ;
    return _choosePayView ;
}

#pragma mark - 显示支付选择弹窗
- (void)showChoosePayView
{
    __weak EMCartSubmitViewController *weakSelf = self ;
    self.choosePayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0] ;
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.choosePayView setFrame:CGRectMake(0, 0, WIDTH, HEIGHT)] ;
    } completion:^(BOOL finished) {
        weakSelf.choosePayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] ;
    }] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self onInitContentView];
    [self createChoosePayView] ;//初始化选择支付界面
    [self payPalConfig] ;//初始化PayPal配置
}

//预先开启支付环境
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES] ;
    [self setPayPalEnvironment:self.PayEnvironment] ;
}

- (void)setPayPalEnvironment:(NSString *)environment
{
    self.PayEnvironment = environment ;
    [PayPalMobile preconnectWithEnvironment:environment] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onInitContentView{
    self.navigationItem.title=@"确认订单";
    [self successView] ;
    orderModel = [[EMOrderModel alloc] init] ;
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.successView] ;
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
    
    [self.successView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(OCUISCALE(kEMOffX)) ;
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(OCUISCALE(-kEMOffX)) ;
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(OCUISCALE(-100)) ;
        make.height.mas_equalTo(OCUISCALE(200)) ;
    }] ;
    UIImageView *checkImageView = [[UIImageView alloc] init] ;
    [checkImageView setImage:[UIImage imageNamed:@"check"]] ;
    UILabel *successLabel = [UILabel labelWithText:@"Your transaction was successful!" font:[UIFont oc_systemFontOfSize:14] textAlignment:NSTextAlignmentLeft] ;
    [self.successView addSubview:checkImageView] ;
    [self.successView addSubview:successLabel] ;
    [checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.successView.mas_centerX) ;
        make.top.mas_equalTo(self.successView.mas_top).offset(20) ;
    }] ;
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.successView.mas_centerX) ;
        make.top.mas_equalTo(checkImageView.mas_bottom).offset(20) ;
    }] ;
    
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
//            cell.textLabel.textColor=kEM_RedColro;
            cell.textLabel.font=[UIFont oc_systemFontOfSize:13];
            cell.detailTextLabel.textColor=kEM_LightDarkTextColor;
            cell.detailTextLabel.font=[UIFont oc_systemFontOfSize:13];
            cell.textLabel.text=@"发货方式:";
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.detailTextLabel.text = @"送货到门";
        }
        /*
        if (self.logisticType==EMOrderLogisticsTypeExpress) {
              cell.detailTextLabel.text=@"快递送货";
        }else if(self.logisticType==EMOrderLogisticsTypeSelfPickUp){
              cell.detailTextLabel.text=@"Box Hill自取";
        }else{
            cell.detailTextLabel.text=@"";
        }
         */
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
        NSMutableAttributedString *priceAttrStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%ld件商品，%@合计金额:",(unsigned long)self.dataSourceArray.count,logsticPriceString] attributes:@{NSFontAttributeName:[UIFont oc_systemFontOfSize:OCUISCALE(13)],NSForegroundColorAttributeName:color}];
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
    }
    //V1.9 取消配送方式选项
    /*
    else if (indexPath.section==1){//配送方式
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
     */
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
/*
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat height=CGFLOAT_MIN;
    if (section==1&&self.logisticType!=EMOrderLogisticsTypeUnKonwn) {
        height=35;
    }
    return height;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1&&self.logisticType!=EMOrderLogisticsTypeUnKonwn) {
        EMGoodsPostageFootView *headView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([EMGoodsPostageFootView class])];
        if (nil==headView) {
            headView=[[EMGoodsPostageFootView alloc]  initWithReuseIdentifier:NSStringFromClass([EMGoodsPostageFootView class])];
        }
        headView.logisticType=self.logisticType;
        return headView;
    }else{
        return nil;
    }

}
*/
#pragma mark - 提交订单
- (void)submitOrderWithShopCartModels:(NSArray *)shopCartArrays addressID:(NSInteger)addressID logiticType:(NSInteger)type remarks:(NSString *)remarks{
    if (addressID<0) {
        [self.view showHUDMessage:@"请选择收货地址"];
    }else if([NSString isNilOrEmptyForString:self.addressModel.fullAdderssString ]){
        [self.view showHUDMessage:@"请填写完整收货地址"];
    } else{
    WEAKSELF
    [self.view showHUDLoading];
    remarks=[remarks stringByRemovingEmoji];
    NSURLSessionTask *task=[EMOrderNetService submitWithUserID:[RI userID] shopCarts:shopCartArrays addressID:addressID logisticType:type remark:remarks onCompletionBlock:^(OCResponseResult *responseResult) {
        if (responseResult.responseCode==OCCodeStateSuccess) {
            [weakSelf.view dismissHUDLoading];
//            [self showChoosePayView] ;
            orderModel=responseResult.responseData;
            NSLog(@"====================================订单的ID：%ld===============================",(long)orderModel.orderID) ;
            
            [self showChoosePayView] ;
            
        }else{
            [weakSelf.view showHUDMessage:responseResult.responseMessage];
        }
    }];
    [self addSessionTask:task];
    }
}

#pragma mark - PayPal支付提交
- (void)submitOrderWithPayPal
{
    self.PayResulText = nil ;
    NSMutableArray *itemsArray = [NSMutableArray array] ;
    for (int i = 0; i < self.dataSourceArray.count; i++) {
        EMShopCartModel *model = self.dataSourceArray[i] ;
        PayPalItem *item = [PayPalItem itemWithName:model.goodsName withQuantity:model.buyCount withPrice:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",model.promotionPrice]] withCurrency:@"AUD" withSku:[NSString stringWithFormat:@"%ld-%ld",(long)[RI userID],(long)model.cartID]] ;
        [itemsArray addObject:item] ;
    }
    NSDecimalNumber *subTotal = [PayPalItem totalPriceForItems:itemsArray] ;
    NSDecimalNumber *shipping = [NSDecimalNumber decimalNumberWithString:@"0.00"] ;
    CGFloat totlePrice = [self totalPrice] ;
    CGFloat feePrice = totlePrice * 0.026 + 0.3 ;
    NSString *fee = [NSString stringWithFormat:@"%.2f",feePrice] ;
    NSDecimalNumber *tax = [NSDecimalNumber decimalNumberWithString:fee] ;
    
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subTotal withShipping:shipping withTax:tax] ;
    NSDecimalNumber *total = [[subTotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax] ;
    
    PayPalPayment *payment = [[PayPalPayment alloc] init] ;
    payment.amount = total ;
    payment.currencyCode = @"AUD" ;
    payment.shortDescription = @"嗨吃嗨GO购物" ;
    payment.items = itemsArray ;
    payment.paymentDetails = paymentDetails ;
    
    if (!payment.processable) {
        
    }
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:self.payPalConfig delegate:self] ;
    
    [self presentViewController:paymentViewController animated:YES completion:nil] ;
}

#pragma mark -bottomView select
//提交订单
- (void)cartBottomViewSubmitButtonPressed:(EMCartBottomView *)bottomView{
    NSLog(@"点击了提交订单按钮") ;
    //默认只有快递方式了
    [self submitOrderWithShopCartModels:self.dataSourceArray addressID:self.addressModel.addressID logiticType:EMOrderLogisticsTypeExpress remarks:self.detailTextViewModel.inputText];
    //[self showChoosePayView] ;
}

#pragma mark - ChoosePayViewDelegate
- (void)choosePayBtn:(UIButton *)button indexRow:(NSInteger)index totalPrice:(CGFloat)totalprice
{
    [self upOrderOfOrderID:orderModel.orderID type:index+1] ;
    if (index == 0) {
        NSLog(@"选择了PayPal支付 支付了：%.2f",totalprice) ;
        [self submitOrderWithPayPal] ;
    }
    else if (index == 1)
    {
        WEAKSELF
        NSLog(@"选择了微信支付 支付了：%.2f",totalprice) ;
        EMCartPayViewController *payController=[[EMCartPayViewController alloc]  initWithTotalPrice:orderModel.payPrice-orderModel.discountPrice  orderNum:orderModel.orderNumber titleLabel:@"微信支付" index:1];
        payController.hidesBottomBarWhenPushed=YES;
        [weakSelf.navigationController pushViewController:payController animated:YES];
    }else
    {
        WEAKSELF
        NSLog(@"选择了转账汇款 支付了：%.2f",totalprice) ;
        EMCartPayViewController *payController=[[EMCartPayViewController alloc]  initWithTotalPrice:orderModel.payPrice-orderModel.discountPrice  orderNum:orderModel.orderNumber titleLabel:@"" index:2];
        payController.hidesBottomBarWhenPushed=YES;
        [weakSelf.navigationController pushViewController:payController animated:YES];
    }
}

#pragma mark - PayPalPaymentDelegate
- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment
{
    NSLog(@"PayPal Payment Success") ;
    self.PayResulText = [completedPayment description] ;
    NSLog(@"PayPal resulttext:%@",self.PayResulText) ;
    [self showSuccess] ;
    [self sendCompletedPaymentToServer:completedPayment] ;
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController
{
    NSLog(@"PayPal Payment Canceled");
    self.PayResulText = nil;
    self.successView.hidden = YES;
    [self showChoosePayView] ;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helpers
- (void)showSuccess {
    self.successView.hidden = NO;
    self.successView.alpha = 1.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:2.0];
    self.successView.alpha = 0.0f;
    [UIView commitAnimations];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    
    [self paypalWithOrderID:orderModel.orderID Confirmation:completedPayment.confirmation] ;
}


#pragma mark -address
- (void)shopAddressListControlerDidSelectAddress:(EMShopAddressModel *)addressModel{
    
    self.addressModel = addressModel ;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic] ;
}


#pragma mark - 提交PayPal订单
- (void)paypalWithOrderID:(NSInteger)orderID Confirmation:(NSDictionary *)confirmation
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:confirmation options:NSJSONWritingPrettyPrinted error:nil] ;
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    
    NSString *oid = [NSString stringWithFormat:@"%ld",(long)orderID] ;
    
    CGFloat totlePrice = [self totalPrice] ;
    CGFloat feePrice = totlePrice * 0.026 + 0.3 ;
    NSString *fee = [NSString stringWithFormat:@"%.2f",feePrice] ;
    
    NSDictionary *parameters = @{@"item":jsonStr,
                                 @"oid":oid,
                                 @"fee":fee} ;
    NSLog(@"parameters:%@",parameters) ;
    
    
    getAppJson = [[NSString alloc] init] ;
    
    NSLog(@"%@",self.PayEnvironment) ;
    if ([self.PayEnvironment isEqualToString:@"sandbox"])
    {
        NSLog(@"yes!") ;
        getAppJson = @"http://www.tulip.city:82/shop_server/paypal" ;
    }
    else
    {
        NSLog(@"NO!") ;
        getAppJson = @"http://www.hichigo.com.au:8081/paypal" ;
    }
    NSLog(@"%@",getAppJson) ;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager] ;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer] ;
    
    WEAKSELF
    [self.view showHUDLoading];
    [manager POST:getAppJson parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf.view dismissHUDLoading] ;
        id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil] ;
       // 获取字典中的值
        if ([result isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dic = result ;
            NSLog(@"通知:%@",dic) ;
            NSInteger code = [dic[@"code"] integerValue] ;
            NSString *titlelable = [NSString stringWithFormat:@"PayPal:%@",dic[@"message"]];
            if (code == 100) {
                titlelable =[NSString stringWithFormat:@"PayPal:%@",dic[@"data"]] ;
            }
            EMCartPayViewController *payController=[[EMCartPayViewController alloc]  initWithTotalPrice:orderModel.payPrice-orderModel.discountPrice  orderNum:orderModel.orderNumber titleLabel:titlelable index:0];
            payController.hidesBottomBarWhenPushed=YES;
            [weakSelf.navigationController pushViewController:payController animated:YES];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"Error: %@", error);
        [weakSelf.view dismissHUDLoading] ;
        [weakSelf.view showHUDMessage:[NSString stringWithFormat:@"%@",error]] ;
    }] ;
}

#pragma mark - 确定订单型号
- (void)upOrderOfOrderID:(NSInteger)orderID type:(NSInteger)type
{
    NSString *oid = [NSString stringWithFormat:@"%ld",(long)orderID] ;
    NSString *typeStr = [NSString stringWithFormat:@"%ld",(long)type] ;
    NSDictionary *parameters = @{@"payType":typeStr,
                                 @"oid":oid
                                 } ;
    NSLog(@"parameters:%@",parameters) ;
    
    NSLog(@"%@",self.PayEnvironment) ;
    NSString *requestUrl = [NSString string] ;
    if ([self.PayEnvironment isEqualToString:@"sandbox"])
    {
        NSLog(@"yes!") ;
        requestUrl = @"http://180.153.58.144:8081/payment/updatePayType" ;
    }
    else
    {
        NSLog(@"NO!") ;
        requestUrl = @"http://www.hichigo.com.au:8081/payment/updatePayType" ;
    }
    NSLog(@"%@",requestUrl) ;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager] ;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer] ;
    
    WEAKSELF
    [self.view showHUDLoading];
    [manager POST:requestUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf.view dismissHUDLoading] ;
        id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil] ;
        // 获取字典中的值
        if ([result isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dic = result ;
            NSLog(@"通知:%@",dic) ;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        [weakSelf.view dismissHUDLoading] ;
        [weakSelf.view showHUDMessage:[NSString stringWithFormat:@"%@",error]] ;

    }] ;


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
