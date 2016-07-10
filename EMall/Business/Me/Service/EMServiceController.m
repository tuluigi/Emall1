//
//  EMServiceController.m
//  EMall
//
//  Created by Luigi on 16/7/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMServiceController.h"

@interface EMServiceFootView :UIView
@property(nonatomic,strong)UIImageView *headImageView;
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
//    self.backgroundColor=RGB(229, 26, 30);
    _headImageView=[[UIImageView alloc]  init];
    _headImageView.backgroundColor=[UIColor redColor];
    [self addSubview:_headImageView];
    WEAKSELF
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(OCUISCALE(-10));
        make.top.mas_equalTo(weakSelf.mas_top).offset(OCUISCALE(20));
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(60), OCUISCALE(60)));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    }];
}

+ (CGFloat)headViewHeight{
    return OCUISCALE(100+80+10);
}
+ (EMServiceFootView *)serviceFootView{
    EMServiceFootView *headView=[[EMServiceFootView alloc]  init];
    CGSize size=[headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    headView.frame=CGRectMake(0, 0, size.width, size.height);
    return headView;
}
@end
@interface EMServiceController ()

@end

@implementation EMServiceController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title=@"联系客服";
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
        cell.detailTextLabel.text=@"4005-864-455";
        cell.imageView.image=[UIImage imageNamed:@"icon_me_collect"];
    }else if (indexPath.row==1){
        cell.textLabel.text=@"扫描二维码，关注海吃微信公众号";
        cell.detailTextLabel.text=@"";
        cell.imageView.image=[UIImage imageNamed:@"icon_me_collect"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        
    }
}
@end
