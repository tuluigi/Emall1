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
#import "EMOrderDetailGoodsCell.h"
#import "EMOrderNetService.h"
#import "EMOrderInfoCell.h"
#import "EMOrderDetailGoodsCell.h"
#import "EMOrderGoodsCommentController.h"
#import "OCUTableCellHeader.h"
#import "OCUTableViewTextViewCell.h"

#import "EMCartChoosePayView.h"
#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "EMCartPayViewController.h"


//#define kPayPalEnvironment PayPalEnvironmentNoNetwork
//#define kPayPalEnvironment PayPalEnvironmentSandbox
#define kPayPalEnvironment PayPalEnvironmentProduction

#define WIDTH  [[UIScreen mainScreen]bounds].size.width
#define HEIGHT [[UIScreen mainScreen]bounds].size.height
#define ChoosePayViewHeight HEIGHT/2


#define  kSubmitCellIdenfier  @"KSubmitCellIdenfier"
#define  kAddressCellIdenfier @"kAddressCellIdenfier"
#define  kPriceCellIdenfier   @"kPriceCellIdenfier"

#define kLogisticsCellIdenfier  @"kLogisticsCellIdenfier"//物流
#define kRemarksCellIdenfier   @"kRemarksCellIdenfier"//备注
#define kQRcodeCellIdenfier @"kQRcodeCellIdenfier"//二维码

#define kEMCartSubmitRemarkCellType     200
@interface EMOrderDetailController ()<reBuyButtonDelegate,ChoosePayViewDelegate,PayPalPaymentDelegate>

{
    NSString *getAppJson ;
}


@property (nonatomic,assign)NSInteger orderID;
@property (nonatomic,strong)EMOrderDetialModel *orderDetailModel;
@property (nonatomic,strong)__block EMOrderModel *orderModel;
@property (nonatomic,strong)__block OCTableCellTextViewModel *detailTextViewModel;

@property (nonatomic,strong)EMCartChoosePayView *choosePayView ;
@property (nonatomic,strong, readwrite) PayPalConfiguration *payPalConfig ;
@property (nonatomic,strong) NSString *PayEnvironment ;
@property (nonatomic,strong) NSString *PayResulText ;

@end

@implementation EMOrderDetailController
- (instancetype)initWithOrderID:(NSInteger )orderID{
    self=[super init];
    if (self) {
        self.orderID=orderID;
    }
    return self;
}

#pragma mark - reBuyButtonDelegate
- (void)reBuyButtonDidClick
{
    [self showChoosePayView] ;
}

#pragma mark - ChoosePayViewDelegate
- (void)choosePayBtn:(UIButton *)button indexRow:(NSInteger)index totalPrice:(CGFloat)totalprice
{
    [self upOrderOfOrderID:self.orderID type:index+1] ;
    if (index == 0) {
        NSLog(@"选择了PayPal支付 支付了：%.2f",totalprice) ;
        [self submitOrderWithPayPal] ;
    }
    else if (index == 1)
    {
        WEAKSELF
        NSLog(@"选择了微信支付 支付了：%.2f",totalprice) ;
        EMCartPayViewController *payController=[[EMCartPayViewController alloc]  initWithTotalPrice:self.orderModel.payPrice-self.orderModel.discountPrice  orderNum:_orderModel.orderNumber titleLabel:@"微信支付" index:1];
        payController.hidesBottomBarWhenPushed=YES;
        [weakSelf.navigationController pushViewController:payController animated:YES];
    }else
    {
        WEAKSELF
        NSLog(@"选择了转账汇款 支付了：%.2f",totalprice) ;
        EMCartPayViewController *payController=[[EMCartPayViewController alloc]  initWithTotalPrice:self.orderModel.payPrice-self.orderModel.discountPrice  orderNum:_orderModel.orderNumber titleLabel:@"" index:2];
        payController.hidesBottomBarWhenPushed=YES;
        [weakSelf.navigationController pushViewController:payController animated:YES];
    }

}

#pragma mark - PayPal支付提交
- (void)submitOrderWithPayPal
{
    self.PayResulText = nil ;
    NSMutableArray *itemsArray = [NSMutableArray array] ;
    NSLog(@"商品有几样：%lu",(unsigned long)self.orderModel.goodsArray.count) ;
    for (int i = 0; i < self.orderModel.goodsArray.count; i++) {
        EMOrderGoodsModel *goodsModel = self.orderModel.goodsArray[i] ;
        
       // CGFloat price = goodsModel.goodsPrice - goodsModel.discountPrice ;
        
        PayPalItem *item = [PayPalItem itemWithName:goodsModel.goodsName withQuantity:goodsModel.buyCount withPrice:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",goodsModel.discountPrice]] withCurrency:@"AUD" withSku:[NSString stringWithFormat:@"%ld-%ld",(long)[RI userID],(long)goodsModel.orderID]] ;
        
        [itemsArray addObject:item] ;
    }
    NSDecimalNumber *subTotal = [PayPalItem totalPriceForItems:itemsArray] ;
    NSDecimalNumber *shipping = [NSDecimalNumber decimalNumberWithString:@"0.00"] ;
    CGFloat totlePrice = self.orderModel.payPrice-self.orderModel.discountPrice ;
    CGFloat feePrice = totlePrice * 0.026 + 0.3 ;
    NSString *fee = [NSString stringWithFormat:@"%.2f",feePrice] ;
    NSDecimalNumber *tax = [NSDecimalNumber decimalNumberWithString:fee] ;
    
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subTotal withShipping:shipping withTax:tax] ;
    NSDecimalNumber *total = [[subTotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax] ;
    
    PayPalPayment *payment = [[PayPalPayment alloc] init] ;
    payment.amount = total ;
    payment.currencyCode = @"AUD" ;
    payment.shortDescription = @"嗨吃嗨购购物" ;
    payment.items = itemsArray ;
    payment.paymentDetails = paymentDetails ;
    
    if (!payment.processable) {
        
    }
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:self.payPalConfig delegate:self] ;
    
    [self presentViewController:paymentViewController animated:YES completion:nil] ;
}


#pragma mark - PayPalPaymentDelegate
- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment
{
    NSLog(@"PayPal Payment Success") ;
    self.PayResulText = [completedPayment description] ;
    NSLog(@"PayPal resulttext:%@",self.PayResulText) ;
   // [self showSuccess] ;
    [self sendCompletedPaymentToServer:completedPayment] ;
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController
{
    NSLog(@"PayPal Payment Canceled");
    self.PayResulText = nil;
  //  self.successView.hidden = YES;
    [self showChoosePayView] ;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    
    [self paypalWithOrderID:_orderModel.orderID Confirmation:completedPayment.confirmation] ;
}

#pragma mark - 提交PayPal订单
- (void)paypalWithOrderID:(NSInteger)orderID Confirmation:(NSDictionary *)confirmation
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:confirmation options:NSJSONWritingPrettyPrinted error:nil] ;
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    
    NSString *oid = [NSString stringWithFormat:@"%ld",(long)orderID] ;
    
    CGFloat totlePrice = _orderModel.payPrice-_orderModel.discountPrice ;
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
            EMCartPayViewController *payController=[[EMCartPayViewController alloc]  initWithTotalPrice:_orderModel.payPrice-_orderModel.discountPrice  orderNum:_orderModel.orderNumber titleLabel:titlelable index:0];
            payController.hidesBottomBarWhenPushed=YES;
            [weakSelf.navigationController pushViewController:payController animated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        [weakSelf.view dismissHUDLoading] ;
        [weakSelf.view showHUDMessage:[NSString stringWithFormat:@"%@",error]] ;
    }] ;
}



#pragma mark - 初始化选择支付界面
- (EMCartChoosePayView *)createChoosePayView
{
    if (!_choosePayView) {
        self.choosePayView = [[EMCartChoosePayView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, ChoosePayViewHeight) withTitle:@"请选择支付方式" withType:2] ;
        CGFloat totlePrice = self.orderModel.payPrice-self.orderModel.discountPrice ;
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
    __weak EMOrderDetailController *weakSelf = self ;
    self.choosePayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0] ;
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.choosePayView setFrame:CGRectMake(0, 0, WIDTH, HEIGHT)] ;
    } completion:^(BOOL finished) {
        weakSelf.choosePayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] ;
    }] ;
}

#pragma mark - 初始化PayPal配置
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
       // self.successView.hidden = YES ;
        NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
    }
    return _payPalConfig ;
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



#pragma mark - 初始化tableview
- (UITableView *)tableView{
    if (nil==_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[EMOrderDetailGoodsCell class] forCellReuseIdentifier:kSubmitCellIdenfier];
        
        [_tableView registerClass:[EMCartAddressCell class] forCellReuseIdentifier:kAddressCellIdenfier];
        [_tableView registerClass:[EMOrderInfoCell class] forCellReuseIdentifier:kPriceCellIdenfier];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

//预先开启支付环境
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES] ;
    [self getOrderDetailWithOrderID:self.orderID];
    [self payPalConfig] ;
    [self setPayPalEnvironment:self.PayEnvironment] ;
}

- (void)setPayPalEnvironment:(NSString *)environment
{
    self.PayEnvironment = environment ;
    [PayPalMobile preconnectWithEnvironment:environment] ;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title=@"订单详情";
    _detailTextViewModel=[[OCTableCellTextViewModel alloc] initWithTitle:@"备注" imageName:nil accessoryType:UITableViewCellAccessoryNone type:kEMCartSubmitRemarkCellType];
    _detailTextViewModel.disableEdit=YES;
    _detailTextViewModel.placeHoleder=@"请填写订单备注";
}
-(void)routerEventName:(NSString *)event userInfo:(NSDictionary *)userInfo{
    if ([event isEqualToString:kEMOrderDetailGoodsCommentEvent]) {
        EMOrderGoodsModel *goodsModel=[userInfo objectForKey:kEMOrderDetailGoodsCommentEvent];
        EMOrderGoodsCommentController *goodsCommentController=[[EMOrderGoodsCommentController alloc]  initWithGoodsID:goodsModel.goodsID orderID:goodsModel.orderID goodsImageUrl:goodsModel.goodsImageUrl];
        goodsCommentController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:goodsCommentController animated:YES];
    }
}
- (void)getOrderDetailWithOrderID:(NSInteger )orderID{
    [self.view showPageLoadingView];
    WEAKSELF
    NSURLSessionTask *task=[EMOrderNetService getOrderDetailWithOrderID:orderID onCompletionBlock:^(OCResponseResult *responseResult) {
        [weakSelf.view dismissPageLoadView];
        if (responseResult.responseCode==OCCodeStateSuccess) {
            weakSelf.orderModel=responseResult.responseData;
            [weakSelf.tableView reloadData];
            [self createChoosePayView] ;
        }else{
            [weakSelf.view showPageLoadedMessage:@"获取数据失败" delegate:nil];
        }
    }];
    [self addSessionTask:task];
}
#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count=0;
    if (section==0) {
        count=1;
    }else if(section==3){
        count=self.orderModel.goodsArray.count;
    }else{
        count=1;
    }
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *aCell;
    if (indexPath.section==1) {
        EMCartAddressCell *cell=[tableView dequeueReusableCellWithIdentifier:kAddressCellIdenfier forIndexPath:indexPath];
        EMShopAddressModel *addressModel=[[EMShopAddressModel alloc]  init];
        addressModel.userName=self.orderModel.receiver;
        addressModel.userTel=self.orderModel.receiverTel;
        addressModel.detailAddresss=self.orderModel.receiverAddresss;
        addressModel.wechatID=self.orderModel.receiverWeChat;
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.addresssModel=addressModel;
        aCell=cell;
    }else if (indexPath.section==2){
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
    }else if (indexPath.section==3){
        EMOrderDetailGoodsCell *cell=[tableView dequeueReusableCellWithIdentifier:kSubmitCellIdenfier forIndexPath:indexPath];
        cell.orderGoodsModel=[self.orderModel.goodsArray objectAtIndex:indexPath.row];
        aCell=cell;
    }else if(indexPath.section==0){
        EMOrderInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:kPriceCellIdenfier forIndexPath:indexPath];
        if (nil==cell) {
            cell=[[EMOrderInfoCell alloc]  initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kPriceCellIdenfier];
            cell.selectionStyle=UITableViewCellSelectionStyleGray;
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        cell.delegate = self ;
        NSInteger buyCount=0;
        for (EMOrderGoodsModel *goodsModel in _orderModel.goodsArray) {
            buyCount+=goodsModel.buyCount;
        }
        //        UIColor *color=[UIColor colorWithHexString:@"#272727"];
        //        NSMutableAttributedString *priceAttrStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%ld件商品，合计金额:",buyCount] attributes:@{NSFontAttributeName:[UIFont oc_systemFontOfSize:OCUISCALE(13)],NSForegroundColorAttributeName:color}];
        //        [priceAttrStr appendAttributedString:[NSAttributedString goodsPriceAttrbuteStringWithPrice:self.orderModel.totalPrice]];
        [cell setOrderID:self.orderModel.orderNumber submitTime:self.orderModel.subitTime payTime:self.orderModel.payTime sendTime:nil totalCount:buyCount totalPrice:self.orderModel.payPrice-self.orderModel.discountPrice];
        //        cell.detailTextLabel.attributedText=priceAttrStr;
        aCell=cell;
    }else if(indexPath.section==4){
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kRemarksCellIdenfier];
        if (nil==cell) {
            cell=[[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kRemarksCellIdenfier];
            cell.textLabel.textColor=kEM_LightDarkTextColor;
            cell.textLabel.font=[UIFont oc_systemFontOfSize:13];
            cell.detailTextLabel.textColor=kEM_LightDarkTextColor;
            cell.detailTextLabel.font=[UIFont oc_systemFontOfSize:13];
            cell.textLabel.text=@"订单备注";
            cell.detailTextLabel.numberOfLines=0;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        if (![NSString isNilOrEmptyForString:self.orderModel.remarks]) {
            cell.detailTextLabel.text=self.orderModel.remarks;
        }else{
            cell.detailTextLabel.text=@"无";
        }
        
        aCell=cell;
    
    }else
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kQRcodeCellIdenfier];
        if (nil == cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kQRcodeCellIdenfier] ;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            UIImageView *qrcodeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QRImage"]] ;
            [cell.contentView addSubview:qrcodeImageView] ;
           // WEAKSELF
            [qrcodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(cell.mas_centerX) ;
                make.centerY.mas_equalTo(cell.mas_centerY) ;
                make.width.mas_equalTo(180) ;
                make.height.mas_equalTo(180) ;
            }] ;
           // cell.imageView.image = [UIImage imageNamed:@"QRImage"] ;
        }
        aCell = cell ;
    }
    return aCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (indexPath.section==1) {
        __block EMShopAddressModel *weadAddressModel=[[EMShopAddressModel alloc]  init];
        weadAddressModel.userName=self.orderModel.receiver;
        weadAddressModel.userTel=self.orderModel.receiverTel;
        weadAddressModel.detailAddresss=self.orderModel.receiverAddresss;
        [tableView.fd_keyedHeightCache invalidateHeightForKey:kAddressCellIdenfier];
        height=[tableView fd_heightForCellWithIdentifier:kAddressCellIdenfier configuration:^(id cell) {
            [(EMCartAddressCell *)cell setAddresssModel:weadAddressModel];
        }];
    }else if(indexPath.section==3){
        __block EMOrderGoodsModel *goodsModel=[self.orderModel.goodsArray objectAtIndex:indexPath.row];
        height=[tableView fd_heightForCellWithIdentifier:kSubmitCellIdenfier configuration:^(id cell) {
            [(EMOrderDetailGoodsCell *)cell setOrderGoodsModel:goodsModel];
        }];
    }else if(indexPath.section==2){
        height=44;
    }else if(indexPath.section==0){
        NSInteger buyCount=0;
        for (EMOrderGoodsModel *goodsModel in _orderModel.goodsArray) {
            buyCount+=goodsModel.buyCount;
        }
        WEAKSELF
        height=[tableView fd_heightForCellWithIdentifier:kPriceCellIdenfier configuration:^(id cell) {
            [cell setOrderID:weakSelf.orderModel.orderNumber submitTime:weakSelf.orderModel.subitTime payTime:weakSelf.orderModel.payTime sendTime:nil totalCount:buyCount totalPrice:weakSelf.orderModel.payPrice-weakSelf.orderModel.discountPrice];
        }];
    }else if(indexPath.section==4){
        height=OCUISCALE(80);
    }else
    {
        height=OCUISCALE(200) ;
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
    if (section==1) {
        title=@"收货地址";
    }else if (section==2){
        title=@"配送方式";
    }else if (section==3){
        title=@"商品列表";
    }else if(section==0){
        title=@"订单信息";
    }else if (section==4){
        title=@"订单备注";
    }else{
        title=@"联系客服";
    }
    
    headView.textLabel.text=title;
    return headView;
}



@end
