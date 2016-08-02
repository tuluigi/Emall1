//
//  EMLoginViewController.m
//  EMall
//
//  Created by Luigi on 16/7/8.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMLoginViewController.h"
#import "UITextField+IndexPath.h"
@interface EMLoginHeadView :UIView
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *label;
+ (EMLoginHeadView *)loginHeadViewWithTitle:(NSString *)title;
@end

@implementation EMLoginHeadView

-(instancetype)init{
    self=[super init];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    _imageView=[[UIImageView alloc]  init];
    _imageView.image=[UIImage imageNamed:@"loginheader"];
    [self addSubview:_imageView];
    
    _label=[UILabel labelWithText:@"登录后即可开始享受海购生活呦" font:[UIFont oc_systemFontOfSize:13] textAlignment:NSTextAlignmentLeft];
    _label.textColor=ColorHexString(@"#5d5c5c");
    [self addSubview:_label];
    
    WEAKSELF
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.top.mas_equalTo(weakSelf.mas_top).offset(OCUISCALE(10));
    }];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).offset(OCUISCALE(25));
        make.top.mas_equalTo(weakSelf.imageView.mas_bottom).offset(OCUISCALE(10));
        make.bottom.mas_equalTo(weakSelf.mas_bottom).mas_equalTo(OCUISCALE(-12.5));
    }];
}
+ (EMLoginHeadView *)loginHeadViewWithTitle:(NSString *)title{
    EMLoginHeadView *headView=[[EMLoginHeadView alloc]  init];
    headView.label.text=title;
    CGSize size=[headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    headView.frame=CGRectMake(0, 0, size.width, size.height);
    return headView;
}
@end

typedef NS_ENUM(NSInteger,EMLoginViewControllerType) {
    EMLoginViewControllerTypeLogin      ,
    EMLoginViewControllerTypeRegister   ,
};

@interface EMLoginViewController ()<UITextFieldDelegate>
@property (nonatomic,copy)NSString *userName,*userPwd,*repatePwd,*email;
@property (nonatomic,copy)EMLoginCompletionBlock loginCompletionBlock;
@property  (nonatomic,copy)EMRegisterCompletionBlock registerCompletionBloc;
@property (nonatomic,assign)EMLoginViewControllerType loginType;

@end

@implementation EMLoginViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
- (UITableView *)tableView{
    if (nil==_tableView) {
        _tableView=[[TPKeyboardAvoidingTableView alloc]  initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.showsHorizontalScrollIndicator=NO;
        _tableView.tableFooterView=[UIView new];
    }
    return _tableView;
}
- (void)viewDidLoad {
//    self.tableView=[[TPKeyboardAvoidingTableView alloc]  initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    self.tableView.delegate=self;
//    self.tableView.dataSource=self;
//    self.tableView.showsVerticalScrollIndicator=NO;
//    self.tableView.showsHorizontalScrollIndicator=NO;
    [super viewDidLoad];
    EMLoginHeadView *headView;
    if (self.loginType==EMLoginViewControllerTypeLogin) {
        self.navigationItem.title=@"登录";
        headView=[EMLoginHeadView loginHeadViewWithTitle:@"登录后即可开始享受海购生活呦"];
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(gotoRegisterController)];
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviousController)];
    }else if (self.loginType==EMLoginViewControllerTypeRegister){
        self.navigationItem.title=@"注册";
        headView=[EMLoginHeadView loginHeadViewWithTitle:@"注册后即可开始享受海购生活呦"];
    }
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;

    self.tableView.tableHeaderView=headView;
    // Do any additional setup after loading the view.
}
- (void)gotoRegisterController{
    EMLoginViewController *registerController=[EMLoginViewController registerViewControlerOnCompletionBlock:^(EMUserModel *userModel) {
        
    }];
    [self.navigationController pushViewController:registerController animated:YES];
}
- (void)backToPreviousController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
+ (EMLoginViewController *)loginViewControllerOnCompletionBlock:(EMLoginCompletionBlock)competionBlock{
    EMLoginViewController *loginController=[[EMLoginViewController alloc]  init];
    loginController.loginType=EMLoginViewControllerTypeLogin;
    loginController.loginCompletionBlock=competionBlock;
    return loginController;

}

+ (EMLoginViewController *)registerViewControlerOnCompletionBlock:(EMRegisterCompletionBlock)competionBlock{
    EMLoginViewController *loginController=[[EMLoginViewController alloc]  init];
    loginController.loginType=EMLoginViewControllerTypeRegister;
    loginController.registerCompletionBloc=competionBlock;
    return loginController;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Net
- (void)doLogin{
    if ([NSString isNilOrEmptyForString:self.userName]) {
         [self.view showHUDMessage:@"请输入用户名"];
    }else if ([NSString isNilOrEmptyForString:self.userPwd]){
        [self.view showHUDMessage:@"请输入密码"];
    }else{
        
    }
}
- (void)doRegister{
    if ([NSString isNilOrEmptyForString:self.userName]) {
        [self.view showHUDMessage:@"请输入用户名"];
    }else if ([NSString isNilOrEmptyForString:self.email]){
        [self.view showHUDMessage:@"请输入邮箱"];
    }else if (![self.email isValidateEmail]){
        [self.view showHUDMessage:@"请输入正确邮箱"];
    }else if ([NSString isNilOrEmptyForString:self.userPwd]){
        [self.view showHUDMessage:@"请输入密码"];
    }else if ([NSString isNilOrEmptyForString:self.repatePwd]){
        [self.view showHUDMessage:@"请输入重复密码"];
    }else if(![self.userPwd isEqualToString:self.repatePwd]){
        [self.view showHUDMessage:@"两次输入密码不一样!"];
    }else{
        
    }
}

#pragma mark -tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row=0;
    if (self.loginType==EMLoginViewControllerTypeLogin) {
        row=4;
    }else if (self.loginType==EMLoginViewControllerTypeRegister){
        row=5;
    }
    return row;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (self.loginType==EMLoginViewControllerTypeLogin) {
        if (indexPath.row==1||indexPath.row==0) {
            NSString *identifer=@"LoginUserNamePwdCell";
            cell=[tableView dequeueReusableCellWithIdentifier:identifer];
            if (nil==cell) {
                cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                UITextField *textField=[[UITextField alloc]  initWithFrame:CGRectMake(100.0, 5.0, 200.0, 35.0)];
                textField.delegate=self;
                textField.textAlignment=NSTextAlignmentLeft;
                textField.tag=1000;
                textField.font=[UIFont oc_systemFontOfSize:13];
                [cell.contentView addSubview:textField];
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, OCUISCALE(25), OCUISCALE(5), OCUISCALE(25)));
                }];
                textField.layer.cornerRadius=10;
                textField.layer.masksToBounds=YES;
                textField.layer.borderColor=ColorHexString(@"#b7b7b7").CGColor;
                textField.layer.borderWidth=0.5;
            }
            UITextField *textField=(UITextField *)[cell viewWithTag:1000];
            textField.indexPath=indexPath;
            if (indexPath.row==0) {
                textField.placeholder=@"  用户名";
            }else if (indexPath.row==1){
                textField.placeholder=@"  密码";
                textField.secureTextEntry=YES;
            }
        }else if (indexPath.row==2){
            NSString *identifer=@"LoginButton";
            cell=[tableView dequeueReusableCellWithIdentifier:identifer];
            if (nil==cell) {
                cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                UIFont *font=[UIFont oc_systemFontOfSize:17];
                UILabel *titleLable=[UILabel labelWithText:@"登录" font:font textAlignment:NSTextAlignmentCenter];
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
            UILabel *titleLable=(UILabel *)[cell viewWithTag:2000];
            if (self.loginType==EMLoginViewControllerTypeLogin) {
                titleLable.text=@"登录";
            }
        }else if (indexPath.row==3){
            NSString *identifer=@"ForgetPwdIdentifer";
            cell=[tableView dequeueReusableCellWithIdentifier:identifer];
            if (nil==cell) {
                cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.textLabel.textAlignment=NSTextAlignmentCenter;
                cell.textLabel.text=@"忘记密码?";
                cell.textLabel.font=[UIFont oc_systemFontOfSize:13];
                cell.textLabel.textColor=ColorHexString(@"#5d5d5d");
            }
        }
    }else if (self.loginType==EMLoginViewControllerTypeRegister) {
        if (indexPath.row==0||indexPath.row==1||indexPath.row==2) {
            NSString *identifer=@"LoginUserNamePwdCell";
            cell=[tableView dequeueReusableCellWithIdentifier:identifer];
            if (nil==cell) {
                cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                UITextField *textField=[[UITextField alloc]  initWithFrame:CGRectMake(100.0, 5.0, 200.0, 35.0)];
                textField.delegate=self;
                textField.textAlignment=NSTextAlignmentLeft;
                textField.tag=1000;
                textField.font=[UIFont oc_systemFontOfSize:13];
                [cell.contentView addSubview:textField];
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, OCUISCALE(25), OCUISCALE(5), OCUISCALE(25)));
                }];
                textField.layer.cornerRadius=10;
                textField.layer.masksToBounds=YES;
                textField.layer.borderColor=ColorHexString(@"#b7b7b7").CGColor;
                textField.layer.borderWidth=0.5;
            }
            UITextField *textField=(UITextField *)[cell viewWithTag:1000];
            textField.indexPath=indexPath;
            if (indexPath.row==0) {
                textField.placeholder=@"  用户名";
            }else if (indexPath.row==1){
                textField.placeholder=@"  邮箱";
                textField.secureTextEntry=YES;
            }else if (indexPath.row==2){
                textField.placeholder=@"  密码";
                textField.secureTextEntry=YES;
            }else if (indexPath.row==3&&self.loginType==EMLoginViewControllerTypeRegister){
                textField.placeholder=@"  重复密码";
                textField.secureTextEntry=YES;
            }
        }else if (indexPath.row==4){
            NSString *identifer=@"LoginButton";
            cell=[tableView dequeueReusableCellWithIdentifier:identifer];
            if (nil==cell) {
                cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                UIFont *font=[UIFont oc_systemFontOfSize:17];
                UILabel *titleLable=[UILabel labelWithText:@"登录" font:font textAlignment:NSTextAlignmentCenter];
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
            UILabel *titleLable=(UILabel *)[cell viewWithTag:2000];
            titleLable.text=@"注册";
        }
    }
    if (nil==cell) {
        cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        if (nil==cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat heigth=0;
    if (indexPath.row==3) {
        heigth=OCUISCALE(50);
    }else{
        heigth=OCUISCALE(48);
    }
    return heigth;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.loginType==EMLoginViewControllerTypeRegister) {
        if (indexPath.row==3) {
            [self.view endEditing:YES];
            [self doRegister];
        }
    }else if (self.loginType==EMLoginViewControllerTypeLogin){
        if (indexPath.row==2) {
             [self.view endEditing:YES];
            [self doLogin];
        }
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSIndexPath *indexPath=textField.indexPath;
    if (self.loginType==EMLoginViewControllerTypeLogin) {
        if (indexPath.row==0) {
            self.userName=textField.text;
        }else if (indexPath.row==1){
            self.userPwd=textField.text;
        }
    }else if (self.loginType==EMLoginViewControllerTypeRegister){
        if (indexPath.row==0) {
            self.userName=textField.text;
        }else if (indexPath.row==1){
            self.email=textField.text;
        }else if (indexPath.row==2){
            self.userPwd=textField.text;
        }else if (indexPath.row==3){
            self.repatePwd=textField.text;
        }
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
