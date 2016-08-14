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
#define kSubmitCellIdenfier  @"KSubmitCellIdenfier"
#define  kAddressCellIdenfier @"kAddressCellIdenfier"
#define  kPriceCellIdenfier  @"kPriceCellIdenfier"
@interface EMCartSubmitViewController ()<EMCartBottomViewDelegate,EMShoppingAddressListControllerDelegate>
@property (nonatomic,strong)__block EMShopAddressModel *addressModel;
@property (nonatomic,strong)EMCartBottomView *bottomView;
@property (nonatomic,assign)CGFloat addressCellheight;

@end

@implementation EMCartSubmitViewController

- (void)setCartArray:(NSArray *)cartArray{
    [self.dataSourceArray addObjectsFromArray:cartArray];
    [self.bottomView updateCartBottomWithSelectItemCount:self.dataSourceArray.count totalItems:self.dataSourceArray.count totalPrice:[self totalPrice]];
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
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
    self.addressModel.userName=@"收货人";
    self.addressModel.userTel=@"收货人电话";
    self.addressModel.wechatID=@"";
    self.addressModel.detailAddresss=@"请选择收获地址";
    [self getUserDefaultShoppingAddress];
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
                    [weakSelf.tableView reloadData];
//                    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
        }
    }];
    [weakSelf addSessionTask:task];
}
#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
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
- (void)submitOrderWithShopCartModels:(NSArray *)shopCartArrays addressID:(NSInteger)addressID logiticType:(NSInteger)type remarks:(NSString *)remarks{
    WEAKSELF
    [self.view showHUDLoading];
    NSURLSessionTask *task=[EMOrderNetService submitWithUserID:[RI userID] shopCarts:shopCartArrays addressID:addressID logisticType:type remark:remarks onCompletionBlock:^(OCResponseResult *responseResult) {
        if (responseResult.responseCode==OCCodeStateSuccess) {
            [weakSelf.view showHUDMessage:@"提交订单成功"];
        }else{
            [weakSelf.view showHUDMessage:responseResult.responseMessage];
        }
    }];
    [self addSessionTask:task];
}
#pragma mark -bottomView select
//提交订单
- (void)cartBottomViewSubmitButtonPressed:(EMCartBottomView *)bottomView{
    
    [self submitOrderWithShopCartModels:self.dataSourceArray addressID:self.addressModel.addressID logiticType:1 remarks:nil];
    
    
    //    EMCartPayViewController *payController=[[EMCartPayViewController alloc]  initWithTotalPrice:[self totalPrice]];
    //    payController.hidesBottomBarWhenPushed=YES;
    //    [self.navigationController pushViewController:payController animated:YES];
}
#pragma  mark -address
- (void)shopAddressListControlerDidSelectAddress:(EMShopAddressModel *)addressModel{
    
    self.addressModel=addressModel;
    [self.tableView reloadData];
    //    return;
    //    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
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
