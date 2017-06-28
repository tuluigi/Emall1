//
//  EMCartPayViewController.m
//  EMall
//
//  Created by Luigi on 16/7/24.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMCartPayViewController.h"
#import "NSAttributedString+Price.h"
#import "EMCartPayCell.h"
#import "EMCartViewController.h"
#import "EMSystemConfigModel.h"
#import "EMImagePickBrowserHelper.h"

static NSString *const kPayInfollIdenfier = @"kPayInfollIdenfier";
static NSString *const kPayPriceCellIdenfier = @"kPayPriceCellIdenfier";
static NSString *const kPayOrderNumCellIdenfier = @"kPayOrderNumCellIdenfier";

static NSString *const kPayWeChatCellIdenfier = @"kPayWeChatCellIdenfier";


#define kWeChatQRImageWidth 140
#define kWeChatQRImageHeight 150
@interface EMCartPayViewController ()
@property (nonatomic,assign)CGFloat totalPrice;
@property (nonatomic,copy)NSString *orderNum;
@property (nonatomic,copy)NSString *titleLabel;

/**
 0:paypal
 1:微信
 2:转账汇款
 */
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,assign)CGFloat cellHeight;

@end

@implementation EMCartPayViewController
- (instancetype)initWithTotalPrice:(CGFloat)totalPrice orderNum:(NSString *)orderNum titleLabel:(NSString *)titleLabel index:(NSInteger)index{
    self=[super init];
    if (self) {
        self.totalPrice=totalPrice;
        self.orderNum=orderNum;
        self.titleLabel=titleLabel;
        self.index=index ;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_interactivePopDisabled=YES;
    self.navigationItem.title=@"订单支付";
    [self.navigationItem setHidesBackButton:YES];;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]  initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(didDoneBarButtonPress)];
    [self.tableView reloadData];
}

- (void)didDoneBarButtonPress{
    NSArray *viewControlelrs=self.navigationController.viewControllers;
    UIViewController *targetController;
    for (UIViewController *aController in viewControlelrs) {
        if ([aController isKindOfClass:[EMCartViewController class]]) {
            targetController=aController;
            break;
        }
    }
    if (targetController) {
        [self.navigationController popToViewController:targetController animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self.tableView registerClass:[EMCartPayCell class] forCellReuseIdentifier:kPayInfollIdenfier];
    NSInteger count=3;
    if (self.index==1) {//微信支付
        count=4;
    }else if (self.index==2){
        count=4;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *aCell;
    if (indexPath.row==0) {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kPayPriceCellIdenfier];
        if (nil==cell) {
            cell=[[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kPayPriceCellIdenfier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.textLabel.textColor=kEM_LightDarkTextColor;
            cell.textLabel.font=[UIFont oc_systemFontOfSize:14];
            cell.textLabel.text=@"订单金额:";
        }
        //        UIColor *color=[UIColor colorWithHexString:@"#272727"];
        //        NSMutableAttributedString *priceAttrStr=[[NSMutableAttributedString alloc] initWithString:@"您的订单金额为:" attributes:@{NSFontAttributeName:[UIFont oc_systemFontOfSize:OCUISCALE(13)],NSForegroundColorAttributeName:color}];
        NSAttributedString *aStrr=[NSAttributedString goodsPriceAttrbuteStringWithPrice:self.totalPrice markFontSize:13 priceInterFontSize:19 pointInterSize:19 color:nil];
        //        [priceAttrStr appendAttributedString:aStrr];
        
        cell.detailTextLabel.attributedText=aStrr;
        aCell=cell;
    }else if (indexPath.row==2){
        EMCartPayCell *cell=[tableView dequeueReusableCellWithIdentifier:kPayInfollIdenfier forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
        EMSystemConfigModel *configModel=[EMCache em_objectForKey:EMCache_SystemConfigKey];
        NSString *accName=configModel.accName;
        if ([NSString isNilOrEmptyForString:accName]) {
            accName=@"HI CHI GO ";
        }
        
        NSString *bsb=configModel.bsb;
        NSString *acc=configModel.acc;
        if ([NSString isNilOrEmptyForString:bsb]) {
            bsb=@"033172";
        }
        if ([NSString isNilOrEmptyForString:acc]) {
            acc=@"838740";
        }
        [(EMCartPayCell *)cell setPayCartName:accName cartID:bsb bankName:acc titleLabel:self.titleLabel index:self.index];
        aCell=cell;
    }else if (indexPath.row==1){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kPayOrderNumCellIdenfier];
        if (nil==cell) {
            cell=[[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kPayOrderNumCellIdenfier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.textLabel.textColor=kEM_LightDarkTextColor;
            cell.textLabel.font=[UIFont oc_systemFontOfSize:14];
            cell.detailTextLabel.textColor=kEM_LightDarkTextColor;
            cell.detailTextLabel.font=[UIFont oc_systemFontOfSize:14];
            cell.textLabel.text=@"订单号：";
        }
        cell.detailTextLabel.text=self.orderNum;
        aCell=cell;
    }else if (indexPath.row==3|| indexPath.row==4){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kPayWeChatCellIdenfier];
        if (nil==cell) {
            cell=[[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kPayWeChatCellIdenfier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.textLabel.textColor=kEM_LightDarkTextColor;
            cell.textLabel.font=[UIFont oc_systemFontOfSize:14];
            UIImageView *imgView=[UIImageView new];
            imgView.tag=2000;
            [cell.contentView addSubview:imgView];
            
            if (self.index==1) {
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(cell.contentView.mas_centerX).offset(-20);
                make.size.mas_equalTo(CGSizeMake(kWeChatQRImageWidth, kWeChatQRImageHeight));
                //                make.centerX.mas_equalTo(cell.contentView.mas_centerX).offset(20);
                make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            }];
            
            UIImageView *imgView1=[UIImageView new];
            imgView1.tag=2001;
            [cell.contentView addSubview:imgView1];
            
            [imgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.contentView.mas_centerX).offset(20);
                make.size.mas_equalTo(CGSizeMake(kWeChatQRImageWidth, kWeChatQRImageHeight));
                make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            }];
            }else{
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(kWeChatQRImageWidth, kWeChatQRImageHeight));
                    make.centerX.mas_equalTo(cell.contentView.mas_centerX);
                    make.centerY.mas_equalTo(cell.contentView.mas_centerY);
                }];
            }
        }
        UIImageView *imgView=[cell.contentView viewWithTag:2000];
        UIImageView *imgView1=[cell.contentView viewWithTag:2001];
        if (indexPath.row==3) {
            imgView.image = [UIImage imageNamed:@"wechat_service_qr"];
            if (self.index==1) {
                imgView1.image  = [UIImage imageNamed:@"wechat_pay_qr"];
            }else{
                imgView1.image = nil;
            }
        }
        aCell=cell;
    }
    return aCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (indexPath.row==0) {
        height=OCUISCALE(60);
    }else if(indexPath.row==2){
        if (self.index == 1) {
            height = 80 ;
        }
        else{
            //            height=[tableView fd_heightForCellWithIdentifier:kPayInfollIdenfier configuration:^(id cell) {
            ////            [(EMCartPayCell *)cell setShopCartModel:cartModel];
            //        }];
            height = 160 ;
        }
    }else if ((indexPath.row==3)||(indexPath.row==4)){
        height=kWeChatQRImageHeight+13*2;
    }else{
        height=44;
    }
    _cellHeight += height ;
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==1) {//订单cell 点击copy
        UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
        [self showCopyMenuItemInView:cell];
    }else if (indexPath.row==3 || indexPath.row==4){
        //客服
        //微信扫码转账
        NSMutableArray *photoArray =[NSMutableArray new];
        
        UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
        UIImageView *imgView =[cell.contentView viewWithTag:2000];
        UIImage *qrImg = imgView.image;
        MWPhoto *photo = [MWPhoto photoWithImage:qrImg];
        if (qrImg && photo) {
            [photoArray addObject:photo];
        }
        
        UIImageView *imgView1 =[cell.contentView viewWithTag:2001];
        UIImage *qrImg1 = imgView1.image;
         MWPhoto *photo1 = [MWPhoto photoWithImage:qrImg1];
        if (qrImg1 && photo1) {
            [photoArray addObject:photo1];
        }
        
        [EMImagePickBrowserHelper showImageBroswerOnController:self withImageArray:photoArray currentIndex:0];
    }
}
- (void)showCopyMenuItemInView:(UIView *)aView{
    [self becomeFirstResponder];
    //    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@""
    //                                                          action:@selector(copy:)];
    [[UIMenuController sharedMenuController] setMenuItems:nil];
    [[UIMenuController sharedMenuController] setTargetRect:aView.bounds inView:aView];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
}

#pragma mark - Menu Actions
- (BOOL)canBecomeFirstResponder {
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copy:));
}
- (void)copy:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    
    NSString *content  = self.orderNum;
    
    pboard.string= content;
    [[UIApplication sharedApplication].keyWindow showHUDMessage:@"订单号已复制到粘贴板，可直接粘贴结果使用"];
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
