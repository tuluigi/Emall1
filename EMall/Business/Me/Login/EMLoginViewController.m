//
//  EMLoginViewController.m
//  EMall
//
//  Created by Luigi on 16/7/8.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMLoginViewController.h"

@interface EMLoginHeadView :UIView
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *label;
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
@end

typedef NS_ENUM(NSInteger,EMLoginViewControllerType) {
    EMLoginViewControllerTypeLogin      ,
    EMLoginViewControllerTypeRegister   ,
};

@interface EMLoginViewController ()
@property (nonatomic,copy)NSString *userName,*userPwd;
@property (nonatomic,copy)EMLoginCompletionBlock loginCompletionBlock;
@property  (nonatomic,copy)EMRegisterCompletionBlock registerCompletionBloc;
@property (nonatomic,assign)EMLoginViewControllerType loginType;

@end

@implementation EMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.row==0||indexPath.row==1) {
        NSString *identifer=@"LoginUserNamePwdCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if (nil==cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            UITextField *textField=[[UITextField alloc]  initWithFrame:CGRectMake(100.0, 5.0, 200.0, 35.0)];
            textField.delegate=self;
            textField.textAlignment=NSTextAlignmentLeft;
            textField.tag=1000;
            [cell.contentView addSubview:textField];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, OCUISCALE(25), OCUISCALE(5), OCUISCALE(-25)));
            }];
            textField.layer.cornerRadius=10;
            textField.layer.masksToBounds=YES;
            textField.layer.borderColor=ColorHexString(@"#b7b7b7").CGColor;
            textField.layer.borderWidth=0.5;
        }
        UITextField *textField=(UITextField *)[cell viewWithTag:1000];
        if (indexPath.row==0) {
            textField.placeholder=@"用户名";
        }else if (indexPath.row==1){
            textField.placeholder=@"密码";
        }

    }else if (indexPath.row==2){
        NSString *identifer=@"LoginButton";
        cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if (nil==cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            UIFont *font=[UIFont oc_systemFontOfSize:17];
            UILabel *titleLable=[UILabel labelWithText:@"登录" font:font textAlignment:NSTextAlignmentCenter];
            titleLable.backgroundColor=ColorHexString(@"#ffffff");
            titleLable.tag=2000;
            [cell.contentView addSubview:titleLable];
            [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, OCUISCALE(25), OCUISCALE(5), OCUISCALE(-25)));
            }];
            titleLable.layer.cornerRadius=30;
            titleLable.layer.masksToBounds=YES;
        }
    }else if (indexPath.row==3){
        NSString *identifer=@"ForgetPwdIdentifer";
        cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if (nil==cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            cell.textLabel.text=@"忘记密码";
            cell.textLabel.font=[UIFont oc_systemFontOfSize:13];
            cell.textLabel.textColor=ColorHexString(@"#5d5d5d");
        }

    }
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
