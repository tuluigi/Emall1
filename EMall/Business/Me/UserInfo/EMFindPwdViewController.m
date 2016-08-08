//
//  EMFindPwdViewController.m
//  EMall
//
//  Created by Luigi on 16/8/8.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMFindPwdViewController.h"
#import "UITextField+IndexPath.h"
#import "UITextField+DisablePast.h"
#import "UITextField+HiddenKeyBoardButton.h"
@interface EMFindPwdViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UIImageView *headImageView;
@property (nonatomic,copy)NSString *userName,*email;
@end

@implementation EMFindPwdViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title=@"找回密码";
       self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _headImageView=[[UIImageView alloc]  initWithFrame:CGRectMake(0, 0, OCWidth, OCUISCALE(200))];
    _headImageView.contentMode=UIViewContentModeCenter;
    _headImageView.image=[UIImage imageNamed:@"loginheader"];
    self.tableView.tableHeaderView=self.headImageView;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]  initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonPressed)];
    
}
- (void)didRightBarButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)findUserPassword{
    [self.tableView endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    UITableViewCell *cell;
    if (indexPath.row==0||indexPath.row==1) {
        NSString *identifer=@"LoginUserNamePwdCell";
        cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if (nil==cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            UITextField *textField=[[UITextField alloc]  initWithFrame:CGRectMake(100.0, 5.0, 200.0, 35.0)];
            textField.delegate=self;
            textField.textAlignment=NSTextAlignmentLeft;
            textField.tag=1000;
            textField.font=[UIFont oc_systemFontOfSize:15];
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [cell.contentView addSubview:textField];
            [textField addHiddenKeyBoardInputAccessView];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, OCUISCALE(25), OCUISCALE(5), OCUISCALE(25)));
            }];
            textField.layer.cornerRadius=10;
            textField.layer.masksToBounds=YES;
            textField.layer.borderColor=ColorHexString(@"#b7b7b7").CGColor;
            textField.layer.borderWidth=0.5;
            UIView *leftView=[UIView new];
            leftView.backgroundColor=[UIColor whiteColor];
            leftView.frame=CGRectMake(0, 0, 15, 35);
            textField.leftView=leftView;
            textField.leftViewMode=UITextFieldViewModeAlways;
        }
        UITextField *textField=(UITextField *)[cell viewWithTag:1000];
        textField.indexPath=indexPath;
        if (indexPath.row==0) {
            textField.placeholder=@"  用户名";
        }else if (indexPath.row==1){
            textField.placeholder=@"  请输入邮箱";
        }
    }else if (indexPath.row==2){
        NSString *identifer=@"LoginButton";
        cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if (nil==cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            UIFont *font=[UIFont oc_systemFontOfSize:17];
            UILabel *titleLable=[UILabel labelWithText:@"确定" font:font textAlignment:NSTextAlignmentCenter];
            titleLable.backgroundColor=ColorHexString(@"#e51e0e");
            titleLable.textColor=[UIColor whiteColor];
            titleLable.font=[UIFont oc_systemFontOfSize:17];
            titleLable.tag=2000;
            [cell.contentView addSubview:titleLable];
            [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, OCUISCALE(25), OCUISCALE(5), OCUISCALE(25)));
            }];
            titleLable.layer.cornerRadius=15;
            titleLable.layer.masksToBounds=YES;
        }
    }else if (indexPath.row==3){
        NSString *identifer=@"footdesccellidenfer";
        cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if (nil==cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            UIFont *font=[UIFont oc_systemFontOfSize:17];
            UILabel *titleLable=[UILabel labelWithText:@"我们将发验证码发送到您的邮箱，请登陆邮箱根据邮件提示操作！" font:font textAlignment:NSTextAlignmentLeft];
            titleLable.numberOfLines=0;
            titleLable.font=[UIFont oc_systemFontOfSize:13];
            titleLable.textColor=ColorHexString(@"#5d5d5d");
            titleLable.tag=2000;
            [cell.contentView addSubview:titleLable];
            [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(10, OCUISCALE(25), OCUISCALE(5), OCUISCALE(25)));
            }];
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=50;
    if (indexPath.row==3) {
        height=80;
    }
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {//找回密码
        
    }
}
@end
