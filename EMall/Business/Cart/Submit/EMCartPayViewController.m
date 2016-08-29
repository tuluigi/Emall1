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
static NSString *const kPayInfollIdenfier = @"kPayInfollIdenfier";
static NSString *const kPayPriceCellIdenfier = @"kPayPriceCellIdenfier";
static NSString *const kPayOrderNumCellIdenfier = @"kPayOrderNumCellIdenfier";
@interface EMCartPayViewController ()
@property (nonatomic,assign)CGFloat totalPrice;
@property (nonatomic,copy)NSString *orderNum;
@end

@implementation EMCartPayViewController
- (instancetype)initWithTotalPrice:(CGFloat)totalPrice orderNum:(NSString *)orderNum{
    self=[super init];
    if (self) {
        self.totalPrice=totalPrice;
        self.orderNum=orderNum;
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
        [(EMCartPayCell *)cell setPayCartName:accName cartID:bsb bankName:acc];
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
    }
    return aCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (indexPath.row==0) {
        height=OCUISCALE(60);
    }else if(indexPath.row==2){

        height=[tableView fd_heightForCellWithIdentifier:kPayInfollIdenfier configuration:^(id cell) {
//            [(EMCartPayCell *)cell setShopCartModel:cartModel];
        }];
    }else{
        height=44;
    }
    return height;
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
