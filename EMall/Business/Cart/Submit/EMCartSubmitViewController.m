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
#import "EMSubmitCartCell.h"
#import "EMShopAddressModel.h"
@interface EMCartSubmitViewController ()
@property (nonatomic,strong)EMShopAddressModel *addressModel;
@property (nonatomic,strong)EMCartBottomView *bottomView;
@end

@implementation EMCartSubmitViewController
+ (EMCartSubmitViewController *)cartSubmitViewWithCartArray:(NSArray *)cartArray{
    EMCartSubmitViewController *cartSubmitViewController=[[EMCartSubmitViewController alloc] init];
    [cartSubmitViewController.dataSourceArray addObjectsFromArray:cartArray];
    cartSubmitViewController.hidesBottomBarWhenPushed=YES;
    return cartSubmitViewController;
}
- (EMCartBottomView *)bottomView{
    if (nil==_bottomView) {
        _bottomView=[EMCartBottomView bottomCartViewDisableSelelct:YES];
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
    [self.tableView registerClass:[EMSubmitCartCell class] forCellReuseIdentifier:NSStringFromClass([EMSubmitCartCell class])];
}
#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *aCell;
    if (indexPath.section==0) {
        
    }else if (indexPath.section==1){
        EMSubmitCartCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EMSubmitCartCell class]) forIndexPath:indexPath];
        cell.shopCartModel=[self.dataSourceArray objectAtIndex:indexPath.row];
        aCell=cell;
    }
    return aCell;
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
