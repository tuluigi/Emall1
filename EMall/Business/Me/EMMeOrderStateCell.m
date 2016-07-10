//
//  EMMeOrderStateCell.m
//  EMall
//
//  Created by Luigi on 16/7/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMMeOrderStateCell.h"
#import <JSBadgeView/JSBadgeView.h>
#import "EMOrderModel.h"
typedef void(^EMOrderItemViewSelectBlock)(EMOrderStateModel *stateModel);

@interface EMOrderStatetItemView : UIView
@property (nonatomic,strong)EMOrderStateModel *stateModel;
@property (nonatomic,copy)EMOrderItemViewSelectBlock selectBlock;
+ (CGSize)homeCatItemViewSize;
@end
@interface EMOrderStatetItemView ()
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong)  UILabel *nameLabel;
@property (nonatomic,strong) JSBadgeView *badgeView;
@end
@implementation EMOrderStatetItemView
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    _iconImageView=[[UIImageView alloc] init];
    _iconImageView.contentMode=UIViewContentModeScaleAspectFill;
    _iconImageView.clipsToBounds=YES;
    
    [self addSubview:_iconImageView];
    _nameLabel=[UILabel labelWithText:@"" font:[UIFont systemFontOfSize:OCUISCALE(11)] textColor:ColorHexString(@"#5d5c5c") textAlignment:NSTextAlignmentCenter];
    _nameLabel.adjustsFontSizeToFitWidth=YES;
    _nameLabel.backgroundColor=[UIColor clearColor];
    _nameLabel.numberOfLines=1;
    [self addSubview:_nameLabel];
    
    _badgeView=[[JSBadgeView alloc]  init];
    _badgeView.badgeTextColor=[UIColor whiteColor];
    _badgeView.badgeBackgroundColor=[UIColor yellowColor];
    _badgeView.badgeTextFont=[UIFont oc_systemFontOfSize:10];
    [self addSubview:_badgeView];
    
    WEAKSELF
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top).offset(OCUISCALE(10));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(20), OCUISCALE(20)));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageView.mas_bottom).offset(OCUISCALE(5));
        make.width.mas_equalTo([EMOrderStatetItemView homeCatItemViewSize].width);
        make.centerX.mas_equalTo(weakSelf.iconImageView);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(OCUISCALE(-10));
    }];
    [_badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(OCUISCALE(-5));
        make.centerY.mas_equalTo(weakSelf.iconImageView.mas_top);
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(8), OCUISCALE(8)));
    }];
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGesture];
}
- (void)setStateModel:(EMOrderStateModel *)stateModel{
    _stateModel=stateModel;
    _iconImageView.image=[UIImage imageNamed:_stateModel.icomName];
    self.nameLabel.text=_stateModel.stateName;
    if (_stateModel.badgeNumber) {
        self.badgeView.hidden=NO;
        self.badgeView.badgeText=[NSString stringWithFormat:@"%ld",_stateModel.badgeNumber];
    }else{
        self.badgeView.hidden=YES;
        self.badgeView.badgeText=@"";
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture{
    if (self.selectBlock) {
        self.selectBlock(self.stateModel);
    }
}

+ (CGSize)homeCatItemViewSize{
    return CGSizeMake(OCUISCALE(50), OCUISCALE(50));
}

@end

@interface EMMeOrderStateCell ()
@property (nonatomic,strong)UIScrollView *myScorllView;
@end

@implementation EMMeOrderStateCell
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    [self.contentView addSubview:self.myScorllView];
    [self.myScorllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}
- (void)setOrderStateArry:(NSArray *)orderStateArry{
    _orderStateArry=orderStateArry;
    [self reloadData];
    
}
- (void)reloadData{
    NSArray *subViewArray=[self.myScorllView subviews];
    for (UIView *aView in subViewArray) {
        [aView removeFromSuperview];
    }
    CGFloat offx    =OCUISCALE(4.5);
    __block CGFloat contentWidth=0;
    WEAKSELF
    CGSize itemViewSize =[EMOrderStatetItemView homeCatItemViewSize];
    for (NSInteger i=0; i<self.orderStateArry.count; i++) {
        EMOrderStatetItemView *itemView=[[EMOrderStatetItemView alloc]  init];
        itemView.stateModel=[self.orderStateArry objectAtIndex:i];
        itemView.selectBlock= ^(EMOrderStateModel *stateModel){
            if (_delegate &&[_delegate respondsToSelector:@selector(orderStateCellDidSelectItem:)]) {
                [_delegate orderStateCellDidSelectItem:stateModel];
            }
        };
        [self.myScorllView addSubview:itemView];
        CGFloat x=offx;
        if (i==0) {
            x=offx;
            contentWidth=offx;
        }else{
            x+=itemViewSize.width*i;
            contentWidth=x+itemViewSize.width;
            if (i==self.orderStateArry.count) {
                contentWidth+=offx;
            }
        }
        itemView.frame=CGRectMake(x, 0, itemViewSize.width, itemViewSize.height);
        self.myScorllView.contentSize=CGSizeMake(contentWidth, [EMOrderStatetItemView homeCatItemViewSize].height);
    }
}
- (UIScrollView *)myScorllView{
    if (nil==_myScorllView) {
        _myScorllView=[[UIScrollView alloc]  init];
        //        _myScorllView.delegate=self;
        _myScorllView.showsVerticalScrollIndicator=NO;
        _myScorllView.showsHorizontalScrollIndicator=NO;
    }
    return _myScorllView;
}
@end
