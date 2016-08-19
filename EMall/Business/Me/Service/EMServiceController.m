//
//  EMServiceController.m
//  EMall
//
//  Created by Luigi on 16/7/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMServiceController.h"
#import "QRCodeGenerator.h"
#import "EMImagePickBrowserHelper.h"
@interface EMServiceFootView :UIView
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *messageLabel;
@property(nonatomic,copy)NSString *imageUrl;


@end

@implementation EMServiceFootView
- (instancetype)init{
    self=[super init];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
   
    self.backgroundColor=[UIColor whiteColor];
    _headImageView=[[UIImageView alloc]  init];
    [self addSubview:_headImageView];
    UIImage *image=[QRCodeGenerator qrImageForString:@"https://www.pgyer.com/3Z6K" imageSize:OCUISCALE(100)];
    _headImageView.image=image;
   
    _messageLabel=[UILabel labelWithText:@"亲！请添加微信客服,微信进行咨询" font:[UIFont oc_systemFontOfSize:13] textAlignment:NSTextAlignmentCenter];
    _messageLabel.textColor=kEM_RedColro;
    [self addSubview:_messageLabel];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(handleImageViewTap)];
    [self.headImageView addGestureRecognizer:tapGesture];
    self.headImageView.userInteractionEnabled=YES;
    WEAKSELF
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(weakSelf.mas_top).offset(OCUISCALE(20));
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(150), OCUISCALE(150)));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    }];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).offset(kEMOffX);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-kEMOffX);
         make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(OCUISCALE(-20));
        make.height.mas_equalTo(OCUISCALE(30));
         make.top.mas_equalTo(weakSelf.headImageView.mas_bottom).offset(OCUISCALE(20));
    }];
     self.imageUrl=@"http://45.118.132.56:8081/images/webchat/QR.jpg";
}
- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl=imageUrl;
     [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:EMDefaultImage];
}
+ (CGFloat)headViewHeight{
    return OCUISCALE(150+20+20+20+30);
}
+ (EMServiceFootView *)serviceFootView{
    EMServiceFootView *headView=[[EMServiceFootView alloc]  init];
    CGSize size=[headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    headView.frame=CGRectMake(0, 0, size.width, size.height);
    return headView;
}
- (void)handleImageViewTap{
    MWPhoto *photo=[MWPhoto photoWithURL:[NSURL URLWithString:self.imageUrl]];
    [EMImagePickBrowserHelper showImageBroswerOnController:nil withImageArray:@[photo] currentIndex:0];
}
@end
@interface EMServiceController ()
@property (nonatomic,copy)NSString *telPhone;
@property (nonatomic,strong) UIWebView * phoneWebView;
@end

@implementation EMServiceController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title=@"联系客服";
    //04 525 66999
    self.telPhone=@"0452566999";
    self.tableView.tableFooterView=[EMServiceFootView serviceFootView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (nil==cell) {
        cell=[[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.textLabel.font=[UIFont oc_systemFontOfSize:13];
        cell.textLabel.textColor=ColorHexString(@"#5d5c5c");
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row==0) {
        cell.detailTextLabel.textColor=[UIColor redColor];
        cell.detailTextLabel.font=[UIFont oc_systemFontOfSize:13];
        cell.textLabel.text=@"全国客服电话";
        cell.detailTextLabel.text=self.telPhone;
        cell.imageView.image=[UIImage imageNamed:@"service_tel"];
    }else if (indexPath.row==1){
        cell.textLabel.text=@"扫描二维码，关注嗨吃GO微信公众号";
        cell.detailTextLabel.text=@"";
        cell.imageView.image=[UIImage imageNamed:@"service_wechat"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {

        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        WEAKSELF
        UIAlertAction *womenAction=[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"联系客服%@",self.telPhone] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (nil==_phoneWebView) {
                  _phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
            }
            NSString *tel=[NSString stringWithFormat:@"tel://%@",weakSelf.telPhone];
            NSURL *url=[NSURL URLWithString: tel];
            [_phoneWebView loadRequest: [NSURLRequest requestWithURL:url]];
        }];
        UIAlertAction *cancleAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:womenAction];
        [alertController addAction:cancleAction];
        [self presentViewController:alertController  animated:YES completion:^{
            
        }];

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
@end
