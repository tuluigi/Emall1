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
#import "EMMeNetService.h"
typedef NS_ENUM(NSInteger,EMMeUserInfoItem) {
    EMMeUserInfoItemAvtar       ,
    EMMeUserInfoItemNickName    ,
    EMMeUserInfoItemGender      ,
    EMMeUserInfoItemBirthday    ,
    EMMeUserInfoItemEmail       ,
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
    OCTableCellDetialTextModel *birthdayModel=[[OCTableCellDetialTextModel alloc]  initWithTitle:@"生日" imageName:nil accessoryType:UITableViewCellAccessoryDisclosureIndicator type:EMMeUserInfoItemGender];

    
    OCTableCellTextFiledModel *emailModel=[[OCTableCellTextFiledModel alloc]  initWithTitle:@"邮箱" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMMeUserInfoItemEmail];

    self.dataSourceArray=[NSMutableArray arrayWithObjects:avatarModel,nickNameModel,genderModel,birthdayModel,emailModel, nil];
    [self.tableView reloadData];
    
    UIBarButtonItem *rightButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonPressed)];
    self.navigationItem.rightBarButtonItem=rightButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getUserInfo{
    NSURLSessionTask *task=[EMMeNetService getUserInfoWithUserID:[RI userID] onCompletionBlock:^(OCResponseResult *responseResult) {
        if (responseResult.responseCode==OCCodeStateSuccess) {
            
        }
    }];
    [self addSessionTask:task];
}
- (void)didRightBarButtonPressed{
    [self.view endEditing:YES];
    OCTableCellRightImageModel *avatorImageModel=[self.dataSourceArray objectAtIndex:EMMeUserInfoItemAvtar];
    OCTableCellTextFiledModel *nickNameModel=[self.dataSourceArray objectAtIndex:EMMeUserInfoItemNickName];
    OCTableCellDetialTextModel *genderModel=[self.dataSourceArray objectAtIndex:EMMeUserInfoItemGender];
    OCTableCellDetialTextModel *birthdayModel=[self.dataSourceArray objectAtIndex:EMMeUserInfoItemBirthday];
    OCTableCellTextFiledModel *emailModel=[self.dataSourceArray objectAtIndex:EMMeUserInfoItemEmail];
    NSString *gender=@"1";
    if ([genderModel.detailText isEqualToString:@"男"]) {
        genderModel.detailText=@"1";
    }else{
        genderModel.detailText=@"2";
    }
    if ([NSString isNilOrEmptyForString:nickNameModel.inputText]) {
        [self.tableView showHUDMessage:@"名称不能为空"];
        return;
    }else if (![emailModel.inputText isValidateEmail]){
        [self.tableView showHUDMessage:@"请输入正确邮箱"];
        return;
    }
    WEAKSELF
    [self.tableView showHUDLoading];
    NSURLSessionTask *task=[EMMeNetService editUserInfoWithUserID:[RI userID] UserName:nickNameModel.inputText email:emailModel.inputText birthday:birthdayModel.detailText avatar:nil gender:gender OnCompletionBlock:^(OCResponseResult *responseResult) {
        if (responseResult.responseCode==OCCodeStateSuccess) {
            [weakSelf.tableView showHUDMessage:@"修改成功" completionBlock:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [weakSelf.tableView showHUDMessage:responseResult.responseMessage];
        }
    }];
    [self addSessionTask:task];
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
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCTableCellModel *cellModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    CGFloat height= OCUISCALE(44);
    if (cellModel.type==EMMeUserInfoItemAvtar) {
        height=OCUISCALE(80);
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 __block   OCTableCellModel *cellModel=[self.dataSourceArray  objectAtIndex:indexPath.row];
   
    if (cellModel.type==EMMeUserInfoItemGender) {
        WEAKSELF
         UIAlertController *alertController=[[UIAlertController alloc]  init];
        alertController.title=@"性别";
        UIAlertAction *menAction=[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [(OCTableCellDetialTextModel *)cellModel setDetailText:action.title];
            [weakSelf.tableView reloadData];
        }];
        UIAlertAction *womenAction=[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [(OCTableCellDetialTextModel *)cellModel setDetailText:action.title];
            [weakSelf.tableView reloadData];
        }];
        UIAlertAction *cancleAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:menAction];
        [alertController addAction:womenAction];
        [alertController addAction:cancleAction];
        [self presentViewController:alertController  animated:YES completion:^{
            
        }];
    }else if (cellModel.type==EMMeUserInfoItemAvtar){
        UIAlertController *alertController=[[UIAlertController alloc]  init];
        WEAKSELF
        UIAlertAction *menAction=[UIAlertAction actionWithTitle:@"查看图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            OCTableCellRightImageModel *model=(OCTableCellRightImageModel *)cellModel;
            MWPhoto *photo;
            if (model.image) {
                photo=[MWPhoto photoWithImage:model.image];
            }else if (model.imageUrl.length){
                photo=[MWPhoto photoWithURL:[NSURL URLWithString:model.imageUrl]];
            }else if(model.placeholderImageUrl){
                photo=[MWPhoto  photoWithImage:[UIImage imageNamed:model.placeholderImageUrl]];
            }
            [EMImagePickBrowserHelper showImageBroswerOnController:weakSelf withImageArray:@[photo] currentIndex:0];
        }];
        UIAlertAction *womenAction=[UIAlertAction actionWithTitle:@"修改图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [EMImagePickBrowserHelper showImagePickerOnController:self takeType:EMTakePictureTypeAll  onCompletionBlock:^(UIImage *editImage, UIImage *originImage, NSURL *fileUrl) {
                [(OCTableCellRightImageModel *)cellModel setImage:editImage];
                [weakSelf.tableView reloadData];
            }];
        }];
        UIAlertAction *cancleAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:menAction];
        [alertController addAction:womenAction];
        [alertController addAction:cancleAction];
        [self presentViewController:alertController  animated:YES completion:^{
            
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
