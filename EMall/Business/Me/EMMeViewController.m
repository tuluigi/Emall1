//
//  EMMeViewController.m
//  EMall
//
//  Created by Luigi on 16/6/22.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMMeViewController.h"
#import "OCUTableCellHeader.h"
#import "EMMEHeadView.h"

typedef NS_ENUM(NSInteger,EMUserTableCellModelType) {
    EMUserTableCellModelTypeOrder           =100,//订单
    EMUserTableCellModelTypeOrderState          ,//订单状态
    EMUserTableCellModelTypeShoppingAddress     ,//收获地址
    EMUserTableCellModelTypeServices            ,//联系客服
    EMUserTableCellModelTypeLogout              ,//退出登录
    
};

@interface EMMeViewController ()
@property (nonatomic,strong)EMMEHeadView *headView;
@end

@implementation EMMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self onInitData];
}
- (void)onInitData{
    self.fd_prefersNavigationBarHidden=YES;
    
    self.navigationItem.title=@"我";
    self.tableView.separatorColor=[UIColor colorWithHexString:@"#eeeeee"];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    WEAKSELF
    [[NSNotificationCenter defaultCenter] addObserverForName:OCLoginSuccessNofication object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        /*
        if ([RI isLogined]) {
            if (weakSelf.dataSourceArray.count==4) {
                OCTableCellButtonModel *quitModel=[[OCTableCellButtonModel alloc]  initWithTitle:@"退出登录" imageName:nil accessoryType:UITableViewCellAccessoryNone type:OCUserTableCellModelTypeLogout];
                NSArray *groupArray5=@[quitModel];
                [weakSelf.dataSourceArray addObject:groupArray5];
            }
        }
        [weakSelf.tableView reloadData];
         */
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:OCLogoutNofication object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if (weakSelf.dataSourceArray.count==5) {
            [weakSelf.dataSourceArray removeLastObject];
            [weakSelf.tableView reloadData];
        }
    }];
    NSArray *groupArray0,*groupArray1,*groupArray2,*groupArray3;
    OCTableCellDetialTextModel *userInfoModel=[[OCTableCellDetialTextModel alloc]  initWithTitle:@"全部订单" imageName:@"icon_me_collect" accessoryType:UITableViewCellAccessoryDisclosureIndicator type:EMUserTableCellModelTypeOrder];
    userInfoModel.tableCellStyle=UITableViewCellStyleSubtitle;
    groupArray0=@[userInfoModel];
    
    OCTableCellDetialTextModel *addressModel=[[OCTableCellDetialTextModel alloc]  initWithTitle:@"地址管理" imageName:@"icon_me_collect" accessoryType:UITableViewCellAccessoryDisclosureIndicator type:EMUserTableCellModelTypeShoppingAddress];
    addressModel.tableCellStyle=UITableViewCellStyleSubtitle;
    groupArray1=@[addressModel];
    
    OCTableCellDetialTextModel *serviceModel=[[OCTableCellDetialTextModel alloc]  initWithTitle:@"联系客服" imageName:@"icon_me_collect" accessoryType:UITableViewCellAccessoryDisclosureIndicator type:EMUserTableCellModelTypeServices];
    serviceModel.tableCellStyle=UITableViewCellStyleSubtitle;
    groupArray2=@[serviceModel];

    OCTableCellDetialTextModel *quitModel=[[OCTableCellDetialTextModel alloc]  initWithTitle:@"退出登录" imageName:@"icon_me_collect" accessoryType:UITableViewCellAccessoryDisclosureIndicator type:EMUserTableCellModelTypeLogout];
    quitModel.tableCellStyle=UITableViewCellStyleSubtitle;
    groupArray3=@[quitModel];
    
    self.dataSourceArray=[NSMutableArray arrayWithObjects:groupArray0,groupArray1,groupArray2,groupArray3, nil];
    
   
    [self.headView setUserName:@"小明" headImageUrl:@"http://www.ld12.com/upimg358/20160130/063405411156224.jpg" level:1];
    CGSize size=[self.headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.headView.frame=CGRectMake(0, 0, size.width, size.height);
     self.tableView.tableHeaderView=self.headView;
    UIEdgeInsets edgeInset=self.tableView.contentInset;
    self.tableView.contentInset=UIEdgeInsetsMake(edgeInset.top-20, edgeInset.left, edgeInset.bottom, edgeInset.right);
    [self.tableView reloadData];
    

}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arry=[self.dataSourceArray objectAtIndex:section];
    NSInteger count=arry.count;
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCTableCellModel *cellModel=[[self.dataSourceArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[cellModel reusedCellIdentifer]];
    if (nil==cell) {
        cell= [cellModel cellWithReuseIdentifer:[cellModel reusedCellIdentifer]];
    }
    [(OCUTableViewCell *)cell setCellModel:cellModel];
    switch (cellModel.type) {
        case EMUserTableCellModelTypeOrderState:
        {
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
            break;
            case EMUserTableCellModelTypeOrder:
            case EMUserTableCellModelTypeLogout:
            case EMUserTableCellModelTypeShoppingAddress:
        case EMUserTableCellModelTypeServices:{
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        default:
            break;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return OCUISCALE(20);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
#pragma  mark - getter

- (EMMEHeadView *)headView{
    if (nil==_headView) {
        _headView=[EMMEHeadView meHeadView];
    }
    return _headView;
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
