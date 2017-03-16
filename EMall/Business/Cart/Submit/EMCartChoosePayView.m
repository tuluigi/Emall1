//
//  EMCartChoosePayView.m
//  EMall
//
//  Created by StarJ on 16/11/1.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMCartChoosePayView.h"
#import "EMCartChoosePayCell.h"

#define WIDTH  [[UIScreen mainScreen]bounds].size.width
#define HEIGHT [[UIScreen mainScreen]bounds].size.height
#define ChoosePayViewHeight HEIGHT/2
#define CellHeight (ChoosePayViewHeight - 80)/4

static NSString *const ChoosePayCellIdenfier = @"ChoosePayCellIdenfier";

@implementation EMCartChoosePayView

- (UIView *)initWithFrame:(CGRect)frame withTitle:(NSString *)title withType:(NSInteger)type
{
    self = [super initWithFrame:frame] ;
    if (self) {
        self.backgroundColor = [UIColor clearColor] ;
        
        [self layOutUIWith:title] ;
        _type = type ;
    }
    return self ;
}

#pragma mark - LayoutUIs
- (void)layOutUIWith:(NSString *)title
{
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-ChoosePayViewHeight, WIDTH, ChoosePayViewHeight)] ;
    _backgroundView.backgroundColor = [UIColor whiteColor] ;
    [self addSubview:_backgroundView] ;
    
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    _submitBtn.backgroundColor = [UIColor redColor] ;
    [_submitBtn setTintColor:[UIColor whiteColor]] ;
    [_submitBtn addTarget:self action:@selector(submitChoose:) forControlEvents:UIControlEventTouchUpInside] ;
    [_backgroundView addSubview:_submitBtn] ;
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backgroundView.mas_bottom).offset(-60) ;
        make.left.mas_equalTo(_backgroundView.mas_left) ;
        make.right.mas_equalTo(_backgroundView.mas_right) ;
        make.bottom.mas_equalTo(_backgroundView.mas_bottom) ;
    }] ;
    
    UILabel *headTitleLabel = [UILabel labelWithText:title font:[UIFont oc_systemFontOfSize:14.0f] textAlignment:NSTextAlignmentLeft];
    
    //    headTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    //    headTitleLabel.textColor = [UIColor redColor];
    //    headTitleLabel.text = title;
    //    headTitleLabel.textAlignment = NSTextAlignmentLeft;
    [_backgroundView addSubview:headTitleLabel];
    
    [headTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_backgroundView.mas_top).offset ((CellHeight-16.f)/2);
        make.centerX.mas_equalTo(_backgroundView.mas_centerX);
        make.height.mas_equalTo (16.0f);
    }];
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CellHeight-1, WIDTH, 1)] ;
    [lineView setImage:[UIImage imageNamed:@"line.png"]] ;
    [_backgroundView addSubview:lineView] ;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CellHeight, WIDTH, ChoosePayViewHeight - 80 - CellHeight) style:UITableViewStylePlain] ;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.scrollEnabled = NO ;
    _tableView.delegate = self ;
    _tableView.dataSource = self ;
    [_backgroundView addSubview:_tableView] ;
}

- (void)submitChoose:(UIButton *)sender
{
    //    if (self.indexPathRow == 1) {
    //       // [self showHUDMessage:@"暂不支持微信支付！"] ;
    //    }else
    //    {
    //        [self upDownSelf] ;
    //    }
    [self upDownSelf] ;
    if (self.delegate && [self.delegate respondsToSelector:@selector(choosePayBtn:indexRow:totalPrice:)]) {
        [self.delegate choosePayBtn:sender indexRow:self.indexPathRow totalPrice:submitPrice] ;
    }
}

- (void)upDownSelf
{
    self.backgroundColor = [UIColor clearColor] ;
    __weak EMCartChoosePayView *weakSelf = self ;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT) ;
    }] ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_type != 1) {
        UITouch *touch = [touches anyObject] ;
        if (touch.view.frame.origin.y < ChoosePayViewHeight) {
            [self upDownSelf] ;
        }
    }
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self.tableView registerClass:[EMCartChoosePayCell class] forCellReuseIdentifier:ChoosePayCellIdenfier] ;
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *chooseCell ;
    EMCartChoosePayCell *cell = [tableView dequeueReusableCellWithIdentifier:ChoosePayCellIdenfier] ;
    cell.delegate = self ;
    if (self.indexPathRow == indexPath.row)
    {
        cell.chooseBtn.selected = YES ;
    }
    else
    {
        cell.chooseBtn.selected = NO ;
    }
    
    if (self.indexPathRow == 0) {
        
        
        
        CGFloat myFee = self.totalPrice * 0.026 + 0.3 ;
        // myFee = [self roundFloat:myFee] ;
        fee = [NSString stringWithFormat:@"%.2f",myFee] ;
        
        submitPrice = self.totalPrice + [fee floatValue] ;
        NSLog(@"========================支付一%f=======================",submitPrice) ;
        NSLog(@"========================支付二%.2f=======================",submitPrice) ;
        
    }
    else
    {
        submitPrice = self.totalPrice ;
    }
    [_submitBtn setTitle:[NSString stringWithFormat:@"确认支付 $ %.2f",submitPrice] forState:UIControlStateNormal] ;
    
    switch (indexPath.row) {
        case 0:
            [cell setIconImage:@"cart_paypal_icon" withTitle:@"PayPal支付" forIndex:indexPath.row withFee:fee] ;
            break ;
        case 1:
            [cell setIconImage:@"cart_weixin_icon" withTitle:@"微信支付" forIndex:indexPath.row withFee:fee] ;
            break ;
        case 2:
            [cell setIconImage:@"cart_huikuan_icon" withTitle:@"转账汇款" forIndex:indexPath.row withFee:fee] ;
            break ;
            
        default:
            break ;
    }
    chooseCell = cell ;
    return chooseCell ;
}

-(CGFloat)roundFloat:(CGFloat)price{
    return (price*100 + 0.5)/100 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heigth = CellHeight ;
    return heigth ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPathRow = indexPath.row ;
    [self.tableView reloadData] ;
}

- (void)selectedBtnClick:(UIButton *)button
{
    UITableViewCell *cell = (EMCartChoosePayCell *)[[button superview] superview] ;
    NSIndexPath *path = [self.tableView indexPathForCell:cell] ;
    self.indexPathRow = path.row ;
    [self.tableView reloadData] ;
}

@end
