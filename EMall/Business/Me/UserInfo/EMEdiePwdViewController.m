//
//  EMEdiePwdViewController.m
//  EMall
//
//  Created by Luigi on 16/8/4.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMEdiePwdViewController.h"
#import "EMMeNetService.h"
#import "OCUTableCellHeader.h"
typedef NS_ENUM(NSInteger,EMEditPwdType) {
    EMEditPwdTypeOrigin       ,
    EMEditPwdTypeNew            ,
    EMEditPwdTypeNewRepeat      ,
};

@interface EMEdiePwdViewController ()
@property (nonatomic,strong)OCTableCellTextFiledModel *originPwdModel,*npwdModel,*repeatNewPwdModel;
@end

@implementation EMEdiePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"修改密码";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]  initWithTitle:@"确定修改" style:UIBarButtonItemStylePlain target:self action:@selector(handleRightBarButtonPressed)];
    _originPwdModel=[[OCTableCellTextFiledModel alloc]  initWithTitle:@"旧密码" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMEditPwdTypeOrigin];
    _originPwdModel.placeHoleder=@"原密码";
    _npwdModel=[[OCTableCellTextFiledModel alloc]  initWithTitle:@"新密码" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMEditPwdTypeNew];
     _npwdModel.placeHoleder=@"新密码";
    _repeatNewPwdModel=[[OCTableCellTextFiledModel alloc]  initWithTitle:@"再次输入" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMEditPwdTypeNewRepeat];
     _repeatNewPwdModel.placeHoleder=@"再次输入";
    
    self.dataSourceArray=[NSMutableArray arrayWithObjects:_originPwdModel,_npwdModel,_repeatNewPwdModel, nil];
}
- (void)handleRightBarButtonPressed{
    [self.view endEditing:YES];
    if ([NSString isNilOrEmptyForString:self.originPwdModel.inputText]) {
        [self.tableView showHUDMessage:@"请输入原密码"];
    }else if ([NSString isNilOrEmptyForString:self.npwdModel.inputText]){
        [self.tableView showHUDMessage:@"请输入新密码"];
    }else if ([NSString isNilOrEmptyForString:self.repeatNewPwdModel.inputText]){
        [self.tableView showHUDMessage:@"请再次输入新密码"];
    }else if (![self.npwdModel.inputText isEqualToString:self.repeatNewPwdModel.inputText]){
        [self.tableView showHUDMessage:@"两次输入的密码不一样"];
    }else{
        WEAKSELF
        [self.tableView showHUDLoading];
        NSURLSessionTask *task=[EMMeNetService editUserPwdWithUserID:[RI userID] originPwd:[self.originPwdModel.inputText md5String] newPwd:[self.npwdModel.inputText md5String] onCompletionBlock:^(OCResponseResult *responseResult) {
            if (responseResult.responseCode==OCCodeStateSuccess) {
                [RI userLogout];
                [weakSelf.tableView showHUDMessage:@"密码修改成功，请重新登录" completionBlock:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    
                }];
            }else{
                [weakSelf.tableView showHUDMessage:responseResult.responseMessage];
            }
        }];
        [self addSessionTask:task];
    }
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
    [((OCUTableViewTextFieldCell *)cell).textField setTextAlignment:NSTextAlignmentLeft];
    [((OCUTableViewTextFieldCell *)cell).textField setSecureTextEntry:YES];
    [(OCUTableViewCell *)cell setCellModel:cellModel];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
