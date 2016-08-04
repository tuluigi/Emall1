//
//  EMMeInfoViewController.m
//  EMall
//
//  Created by Luigi on 16/8/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMMeInfoViewController.h"
#import "OCUTableCellHeader.h"
#import "EMImagePickBrowserHelper.h"
typedef NS_ENUM(NSInteger,EMMeUserInfoItem) {
    EMMeUserInfoItemNickName        =10,
    EMMeUserInfoItemGender      ,
    EMMeUserInfoItemEmail       ,
    EMMeUserInfoItemAvtar       ,
};
typedef NS_ENUM(NSInteger,EMMeUserInfoActionSheetTag) {
    EMMeUserInfoActionSheetTagGender  =200,
    EMMeUserInfoActionSheetTagAvatar  ,
};
@interface EMMeInfoViewController ()

@end

@implementation EMMeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"个人资料";
    
    OCTableCellRightImageModel *avatarModel=[[OCTableCellRightImageModel alloc]  initWithTitle:@"头像" imageName:[RI  avatar] accessoryType:UITableViewCellAccessoryNone type:EMMeUserInfoItemAvtar];
    avatarModel.placeholderImageUrl=EMDefaultImageName;
    OCTableCellTextFiledModel *nickNameModel=[[OCTableCellTextFiledModel alloc]  initWithTitle:@"昵称" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMMeUserInfoItemNickName];
   OCTableCellDetialTextModel *genderModel=[[OCTableCellDetialTextModel alloc]  initWithTitle:@"性别" imageName:nil accessoryType:UITableViewCellAccessoryDisclosureIndicator type:EMMeUserInfoItemGender];
    genderModel.detailText=@"男";
    OCTableCellTextFiledModel *emailModel=[[OCTableCellTextFiledModel alloc]  initWithTitle:@"邮箱" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMMeUserInfoItemEmail];

    self.dataSourceArray=[NSMutableArray arrayWithObjects:avatarModel,nickNameModel,genderModel,emailModel, nil];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return   self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCTableCellModel *cellModel=[self.dataSourceArray  objectAtIndex:indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[cellModel reusedCellIdentifer]];
    if (nil==cell) {
        cell= [cellModel cellWithReuseIdentifer:[cellModel reusedCellIdentifer]];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    [(OCUTableViewCell *)cell setCellModel:cellModel];
//    switch (cellModel.type) {
//        case EMUserTableCellModelTypeOrderState:
//        {
//            cell.separatorInset=UIEdgeInsetsZero;
//            cell.accessoryType=UITableViewCellAccessoryNone;
//            [(EMMeOrderStateCell *)cell setDelegate:self];
//            [(EMMeOrderStateCell *)cell setOrderStateArry:self.orderStateArray];
//        }
//            break;
//        case EMUserTableCellModelTypeOrder:
//        case EMUserTableCellModelTypeLogout:
//        case EMUserTableCellModelTypeShoppingAddress:
//        case EMUserTableCellModelTypeServices:{
//            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//        }
//            break;
//            
//        default:
//            break;
//    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCTableCellModel *cellModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    CGFloat height= OCUISCALE(44);
    if (cellModel.type==EMMeUserInfoItemAvtar) {
        height=OCUISCALE(60);
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OCTableCellModel *cellModel=[self.dataSourceArray  objectAtIndex:indexPath.row];
    UIAlertController *alertController=[[UIAlertController alloc]  init];
    if (cellModel.type==EMMeUserInfoItemGender) {
        alertController.title=@"性别";
        UIAlertAction *menAction=[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *womenAction=[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *cancleAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:menAction];
        [alertController addAction:womenAction];
        [alertController addAction:cancleAction];
        [self presentViewController:alertController  animated:YES completion:^{
            
        }];
    }else if (cellModel.type==EMMeUserInfoItemAvtar){
        alertController.title=@"";
        [EMImagePickBrowserHelper showImagePickerOnController:self takeType:EMTakePictureTypeAll  onCompletionBlock:^(UIImage *editImage, UIImage *originImage, NSURL *fileUrl) {
            
        }];
    }
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
