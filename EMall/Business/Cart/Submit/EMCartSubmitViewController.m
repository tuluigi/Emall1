//
//  EMCartSubmitViewController.m
//  EMall
//
//  Created by Luigi on 16/7/23.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMCartSubmitViewController.h"
#import "EMShopCartModel.h"
@interface EMCartSubmitViewController ()
@property (nonatomic,strong)NSArray *cartArray;
@end

@implementation EMCartSubmitViewController
+ (EMCartSubmitViewController *)cartSubmitViewWithCartArray:(NSArray *)cartArray{
    EMCartSubmitViewController *cartSubmitViewController=[[EMCartSubmitViewController alloc] init];
    cartSubmitViewController.cartArray=cartArray;
    cartSubmitViewController.hidesBottomBarWhenPushed=YES;
    return cartSubmitViewController;
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
