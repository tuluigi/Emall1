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
static NSString *const kSubmitCellIdenfier = @"KSubmitCellIdenfier";
static NSString *const kAddressCellIdenfier = @"kAddressCellIdenfier";
static NSString *const kPriceCellIdenfier = @"kPriceCellIdenfier";
@interface EMCartSubmitViewController ()<EMCartBottomViewDelegate,EMShoppingAddressListControllerDelegate>
@property (nonatomic,strong)EMShopAddressModel *addressModel;
@property (nonatomic,strong)EMCartBottomView *bottomView;

@end

@implementation EMCartSubmitViewController

- (void)setCartArray:(NSArray *)cartArray{
    [self.tableView registerClass:[EMCartSubmitCell class] forCellReuseIdentifier:kSubmitCellIdenfier];
    
    [self.tableView registerClass:[EMCartAddressCell class] forCellReuseIdentifier:kAddressCellIdenfier];
// [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kPriceCellIdenfier];
    [self.dataSourceArray addObjectsFromArray:cartArray];
    [self.bottomView updateCartBottomWithSelectItemCount:self.dataSourceArray.count totalItems:self.dataSourceArray.count totalPrice:[self totalPrice]];
    [self.tableView reloadData];
}
- (EMCartBottomView *)bottomView{
    if (nil==_bottomView) {
        _bottomView=[EMCartBottomView bottomCartViewDisableSelelct:YES];
        _bottomView.delegate=self;
    }
    return _bottomView;
}
- (instancetype)init{
    self=[super init];
    if (self) {
       
    }
    return self;
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
   

    WEAKSELF
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(OCUISCALE(50));
    }];
    UIEdgeInsets inset= self.tableView.contentInset;
    inset.bottom+=OCUISCALE(50);
    self.tableView.contentInset=inset;
    self.addressModel=[[EMShopAddressModel alloc]  init];
    self.addressModel.userName=@"小名";
    self.addressModel.userTel=@"13523576349";
    self.addressModel.wechatID=@"weixin_xxxID";
    self.addressModel.detailAddresss=@"北京市，海淀区，中关村，巴拉巴拉巴拉巴安拔萝卜";
    [self getUserDefaultShoppingAddressWithUserID:nil];
    

    
}
- (CGFloat)totalPrice{
    CGFloat totalPrice=0;
    for (EMShopCartModel *model in self.dataSourceArray) {
        if (!model.unSelected) {
            totalPrice+=model.goodsPrice*model.buyCount;
        }
    }
    return totalPrice;
}
- (void)getUserDefaultShoppingAddressWithUserID:(NSString *)userID{
   
    [self.tableView reloadData];
}
#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [self.tableView registerClass:[EMCartSubmitCell class] forCellReuseIdentifier:kSubmitCellIdenfier];
    
    [self.tableView registerClass:[EMCartAddressCell class] forCellReuseIdentifier:kAddressCellIdenfier];
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count=0;
    if (section==0) {
        count=1;
    }else if(section==1){
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
        EMCartSubmitCell *cell=[tableView dequeueReusableCellWithIdentifier:kSubmitCellIdenfier forIndexPath:indexPath];
        cell.shopCartModel=[self.dataSourceArray objectAtIndex:indexPath.row];
        aCell=cell;
    }else{
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kPriceCellIdenfier];
        if (nil==cell) {
            cell=[[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kPriceCellIdenfier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        UIColor *color=[UIColor colorWithHexString:@"#272727"];
        NSMutableAttributedString *priceAttrStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%ld件商品，合计金额:",self.dataSourceArray.count] attributes:@{NSFontAttributeName:[UIFont oc_systemFontOfSize:OCUISCALE(13)],NSForegroundColorAttributeName:color}];
        [priceAttrStr appendAttributedString:[NSAttributedString goodsPriceAttrbuteStringWithPrice:[self totalPrice]]];

        cell.detailTextLabel.attributedText=priceAttrStr;
        aCell=cell;
    }
    return aCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (indexPath.section==0) {
        if (self.addressModel) {
            __block EMShopAddressModel *weadAddressModel=self.addressModel;
            [tableView.fd_keyedHeightCache invalidateHeightForKey:kAddressCellIdenfier];
            height=[tableView fd_heightForCellWithIdentifier:kAddressCellIdenfier configuration:^(id cell) {
                [(EMCartAddressCell *)cell setAddresssModel:weadAddressModel];
            }];
        }else{
            height=OCUISCALE(50);
        }
    }else if(indexPath.section==1){
        __block EMShopCartModel *cartModel=[self.dataSourceArray objectAtIndex:indexPath.row];
        height=[tableView fd_heightForCellWithIdentifier:kSubmitCellIdenfier configuration:^(id cell) {
            [(EMCartSubmitCell *)cell setShopCartModel:cartModel];
        }];
    }else{
        height=OCUISCALE(80);
    }
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        EMShoppingAddressListController *addressController=[[EMShoppingAddressListController alloc]  init];
        addressController.delegate=self;
        addressController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:addressController animated:YES];
    }
}
#pragma mark -bottomView select
//提交订单
- (void)cartBottomViewSubmitButtonPressed:(EMCartBottomView *)bottomView{
    
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
