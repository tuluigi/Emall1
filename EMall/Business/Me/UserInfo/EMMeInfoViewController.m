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
#import "EMUserModel.h"
#import "OCNUploadNetService.h"
#import "NSDate+Category.h"
typedef NS_ENUM(NSInteger,EMMeUserInfoItem) {
    EMMeUserInfoItemAvtar       ,
    EMMeUserInfoItemNickName    ,
    EMMeUserInfoItemGender      ,
    EMMeUserInfoItemBirthday    ,
    EMMeUserInfoItemEmail       ,
    EMMeUserInfoItemWeChat       ,
};
typedef NS_ENUM(NSInteger,EMMeUserInfoActionSheetTag) {
    EMMeUserInfoActionSheetTagGender  =200,
    EMMeUserInfoActionSheetTagAvatar  ,
};
@interface EMMeInfoViewController ()
@property (nonatomic,strong)__block EMUserModel *userModel;
@property(nonatomic,strong)UIDatePicker *dataPicker;
@property(nonatomic,strong)UIView *pickView;
@property (nonatomic, strong) MASConstraint *pickViewHeightConstraint;


@property (nonatomic,strong)__block OCTableCellRightImageModel *avatarModel;
@property (nonatomic,strong)__block OCTableCellTextFiledModel *nickNameModel;
@property (nonatomic,strong)__block OCTableCellDetialTextModel *genderModel;
@property (nonatomic,strong)__block OCTableCellDetialTextModel *birthdayModel;
@property (nonatomic,strong)__block OCTableCellTextFiledModel *emailModel;
@property (nonatomic,strong)__block OCTableCellTextFiledModel *wechatModel;
@property (nonatomic,strong)__block NSDate *birthdayDate;

@property (nonatomic,strong)__block MBProgressHUD *progressHud;
@end

@implementation EMMeInfoViewController
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.view dismissHUDLoading];
    [_progressHud hide:YES];
    [_progressHud removeFromSuperview];

    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"个人资料";
    EMUserModel *model=[EMUserModel loginUserModel];
    _avatarModel=[[OCTableCellRightImageModel alloc]  initWithTitle:@"头像" imageName:[RI  avatar] accessoryType:UITableViewCellAccessoryNone type:EMMeUserInfoItemAvtar];
    _avatarModel.placeholderImageName=@"avator_default";
    _avatarModel.imageUrl=model.avatar;
    _nickNameModel=[[OCTableCellTextFiledModel alloc]  initWithTitle:@"昵称" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMMeUserInfoItemNickName];
    _nickNameModel.inputText=model.nickName;
   _genderModel=[[OCTableCellDetialTextModel alloc]  initWithTitle:@"性别" imageName:nil accessoryType:UITableViewCellAccessoryDisclosureIndicator type:EMMeUserInfoItemGender];
    _genderModel.detailText=model.genderString;
    _birthdayModel=[[OCTableCellDetialTextModel alloc]  initWithTitle:@"生日" imageName:nil accessoryType:UITableViewCellAccessoryDisclosureIndicator type:EMMeUserInfoItemBirthday];
    _birthdayModel.detailText=[model.birtadyDay convertDateToStringWithFormat:@"yyyy-MM-dd"];
    
    _emailModel=[[OCTableCellTextFiledModel alloc]  initWithTitle:@"邮箱" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMMeUserInfoItemEmail];
    _emailModel.inputText=model.email;
//    _wechatModel=[[OCTableCellTextFiledModel alloc]  initWithTitle:@"微信" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMMeUserInfoItemWeChat];
//    _wechatModel.inputText=model.wechatID;
    self.dataSourceArray=[NSMutableArray arrayWithObjects:_avatarModel,_nickNameModel,_genderModel,_birthdayModel,_emailModel, nil];
    [self.tableView reloadData];
    [self getUserInfo];
    UIBarButtonItem *rightButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonPressed)];
    self.navigationItem.rightBarButtonItem=rightButtonItem;
    self.navigationItem.rightBarButtonItem.enabled=NO;
     [self.view addSubview:self.pickView];
    WEAKSELF
    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(300);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setBirthdayDate:(NSDate *)birthdayDate{
    _birthdayDate=birthdayDate;
     self.birthdayModel.detailText=[_birthdayDate convertDateToStringWithFormat:@"yyyy-MM-dd"];
    NSInteger index=[self.dataSourceArray indexOfObject:self.birthdayModel];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)getUserInfo{
    WEAKSELF
    [self.tableView showPageLoadingView];
    NSURLSessionTask *task=[EMMeNetService getUserInfoWithUserID:[RI userID] onCompletionBlock:^(OCResponseResult *responseResult) {
        [weakSelf.tableView dismissPageLoadView];
        if (responseResult.responseCode==OCCodeStateSuccess) {
            if ([responseResult.responseData isKindOfClass:[EMUserModel class]]) {
                weakSelf.userModel=responseResult.responseData;
                weakSelf.navigationItem.rightBarButtonItem.enabled=YES;
                weakSelf.nickNameModel.inputText=weakSelf.userModel.nickName;
                weakSelf.avatarModel.imageUrl=weakSelf.userModel.avatar;
                weakSelf.genderModel.detailText=weakSelf.userModel.genderString;
                weakSelf.emailModel.inputText=weakSelf.userModel.email;
                weakSelf.birthdayDate=weakSelf.userModel.birtadyDay;
                [weakSelf.tableView reloadData];
            }
        }else{
            [weakSelf.tableView showPageLoadedMessage:@"获取信息失败" delegate:nil];
        }
    }];
    [self addSessionTask:task];
}
- (void)didRightBarButtonPressed{
    [self.view endEditing:YES];
    OCTableCellRightImageModel *avatorImageModel=self.avatarModel;
    OCTableCellTextFiledModel *nickNameModel=self.nickNameModel;
    OCTableCellDetialTextModel *genderModel=self.genderModel;
    OCTableCellDetialTextModel *birthdayModel=self.birthdayModel;
    OCTableCellTextFiledModel *emailModel=self.emailModel;
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
    NSURLSessionTask *task=[EMMeNetService editUserInfoWithUserID:[RI userID] UserName:nickNameModel.inputText email:emailModel.inputText birthday:birthdayModel.detailText avatar:avatorImageModel.imageUrl gender:gender wechatID:_wechatModel.inputText oldAvatar:RI.avatar OnCompletionBlock:^(OCResponseResult *responseResult) {
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
            }else if(model.placeholderImageName){
                photo=[MWPhoto  photoWithImage:[UIImage imageNamed:model.placeholderImageName]];
            }
            [EMImagePickBrowserHelper showImageBroswerOnController:weakSelf withImageArray:@[photo] currentIndex:0];
        }];
        UIAlertAction *womenAction=[UIAlertAction actionWithTitle:@"修改图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
          [EMImagePickBrowserHelper showImagePickerOnController:self takeType:EMTakePictureTypeAll  onCompletionBlock:^(UIImage *editImage, UIImage *originImage, NSURL *fileUrl) {
                _progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
              _progressHud.removeFromSuperViewOnHide=YES;
                _progressHud.mode = MBProgressHUDModeAnnularDeterminate;
                _progressHud.labelText = @"上传中...";
               NSURLSessionTask *task= [OCNUploadNetService uploadPhotoWithData:UIImageJPEGRepresentation(editImage, 0.8) parmDic:nil fileType:@"jpeg" didSendData:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
                   CGFloat progress=totalBytesSent/(totalBytesExpectedToSend*1.0);
                   _progressHud.progress=progress;
                } onCompletionBlock:^(OCResponseResult *responseResult) {
                    [_progressHud hide:YES];
                    [_progressHud removeFromSuperview];
                 
                    if (responseResult.responseCode==OCCodeStateSuccess) {
                        [weakSelf.view showHUDMessage:@"上传成功,请保存"];
                        weakSelf.avatarModel.imageUrl=responseResult.responseData;
                        [[SDImageCache sharedImageCache] storeImage:editImage forKey: weakSelf.avatarModel.imageUrl toDisk:YES];
                        [weakSelf.tableView reloadData];
                    }else{
                        [weakSelf.view showHUDMessage:@"上传失败"];
                    }
                }];
                [weakSelf addSessionTask:task];
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
    }else if (cellModel.type==EMMeUserInfoItemBirthday){
        [self.view endEditing:YES];
        WEAKSELF
        [UIView animateWithDuration:0.2 animations:^{
            [weakSelf.pickView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(weakSelf.view);
            }];
            if (weakSelf.birthdayDate) {
                [weakSelf.dataPicker setDate:weakSelf.birthdayDate animated:YES];
            }
            [weakSelf.pickView layoutIfNeeded];
        }];
        return;
    }
}
-(void)dateChanged:(UIDatePicker *)sender{
    NSDate*date= sender.date;
    self.birthdayDate=date;
}
-(void)doneButtonPressed:(UIBarButtonItem *)sender{
    WEAKSELF
    [UIView animateWithDuration:0.2 animations:^{
        [weakSelf.pickView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view).offset(300);
        }];
        [weakSelf.pickView layoutIfNeeded];
        NSDate*date= weakSelf.dataPicker.date;
        weakSelf.birthdayDate=date;
    }];
    return;
}
-(void)cancelButtonPressed:(UIBarButtonItem *)sender{
    WEAKSELF
    [UIView animateWithDuration:0.2 animations:^{
        [weakSelf.pickView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view).offset(300);
        }];
        [weakSelf.pickView layoutIfNeeded];
    }];
    return;
    
}
-(UIView *)pickView{
    if (nil==_pickView) {
        _pickView=[[UIView alloc]  init];
        [_pickView addSubview:self.dataPicker];
        
        UIToolbar *pickerToolbar = [[UIToolbar alloc] init];
        pickerToolbar.backgroundColor=RGB(240, 240, 240);
        pickerToolbar.barStyle = UIBarStyleDefault;
        [pickerToolbar sizeToFit];
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]
                                      
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
        [barItems addObject:cancelBtn];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:flexSpace];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]
                                    
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
        [barItems addObject:doneBtn];
        [pickerToolbar setItems:barItems animated:YES];
        [_pickView addSubview:pickerToolbar];
        
        
        
        [pickerToolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_pickView);
            make.height.equalTo(@(40));
        }];
        
        [_dataPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(pickerToolbar.mas_bottom);
            make.left.right.bottom.equalTo(_pickView);
        }];
    }
    return _pickView;
}
-(UIDatePicker *)dataPicker{
    if (nil==_dataPicker) {
        _dataPicker = [[UIDatePicker alloc] init];
        _dataPicker.datePickerMode = UIDatePickerModeDate;
        _dataPicker.hidden = NO;
        _dataPicker.minimumDate = [[NSDate alloc]  initWithTimeIntervalSince1970:0];
        _dataPicker.maximumDate= [NSDate date];
        //响应日期选择事件，自定义dateChanged方法
        [ _dataPicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        
    }
    return _dataPicker;
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
