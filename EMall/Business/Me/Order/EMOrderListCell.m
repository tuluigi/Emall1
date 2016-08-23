//
//  EMOrderListCell.m
//  EMall
//
//  Created by Luigi on 16/7/17.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMOrderListCell.h"
#import "EMOrderModel.h"

@interface EMOrderListGoodsItemCell :UICollectionViewCell
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,copy)NSString *imageUrl;
@end
@implementation EMOrderListGoodsItemCell

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onIntiContentView];
    }
    return self;
}
- (void)onIntiContentView{
    _imageView=[UIImageView new];
    [self.contentView addSubview:_imageView];
    CGFloat padding=5;
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(padding, padding, padding, padding));
    }];
}
- (void)setImageUrl:(NSString *)imageUrl{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:EMDefaultImage ];
}
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    UICollectionViewLayoutAttributes *attributes=[super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    
    attributes.size=[EMOrderListGoodsItemCell orderGoodsListItemCellSize];
    return attributes;
}
+ (CGSize)orderGoodsListItemCellSize{
    return CGSizeMake(70, 70);
}
@end


@interface EMOrderListCell ()<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIImageView *checkImageView;
//goodsNameLabel,*countLabel,*goodsImageView,
@property (nonatomic,strong)UILabel *priceLabel,*orderNumLabel,*orderTimeLabel;
@property (nonatomic,strong)UIButton *reBuyButton,*detailButton;
@property (nonatomic,strong)UICollectionView *myCollectionView;

@end

@implementation EMOrderListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.accessoryType=UITableViewCellAccessoryNone;
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    self.contentView.backgroundColor=RGB(241, 243, 240);
    _bgView=[UIView new];
    _bgView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    WEAKSELF
    UIFont *font=[UIFont oc_systemFontOfSize:13];
    UIColor *color=[UIColor colorWithHexString:@"#272727"];
    
    

    _orderNumLabel=[UILabel labelWithText:@"" font:font textColor:color textAlignment:NSTextAlignmentLeft];
    _orderNumLabel.adjustsFontSizeToFitWidth=YES;
    [_bgView addSubview:_orderNumLabel];
    
    _orderTimeLabel=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"#949090"] textAlignment:NSTextAlignmentLeft];
    _orderTimeLabel.adjustsFontSizeToFitWidth=YES;
    _orderTimeLabel.textAlignment=NSTextAlignmentRight;
    [_bgView addSubview:_orderTimeLabel];
    
    [_bgView addSubview:self.myCollectionView];
    
    
    _checkImageView=[UIImageView new];
    _checkImageView.image=[UIImage imageNamed:@"arror_right"];
    [_bgView addSubview:_checkImageView];
    
   
    
    UIView *lineView0=[UIView new];
    lineView0.backgroundColor=RGB(225, 225, 225);
    [_bgView addSubview:lineView0];
    
    _priceLabel=[UILabel labelWithText:@"" font:font textColor:color textAlignment:NSTextAlignmentRight];
    [_bgView addSubview:_priceLabel];
    
    UIView *lineView1=[UIView new];
    lineView1.backgroundColor=RGB(225, 225, 225);
    [_bgView addSubview:lineView1];

    UIColor *rebuyColor=[UIColor colorWithHexString:@"#e51e0e"];
    _reBuyButton=[UIButton buttonWithTitle:@"  " titleColor:rebuyColor font:font];
    _reBuyButton.layer.cornerRadius=5.0;
    _reBuyButton.layer.masksToBounds=YES;
    _reBuyButton.layer.borderColor=[rebuyColor CGColor];
    _reBuyButton.layer.borderWidth=1.0;
    [_reBuyButton addTarget:self action:@selector(didReBuyButtonPressed ) forControlEvents:UIControlEventTouchUpInside];
    _reBuyButton.hidden=YES;
    [_bgView addSubview:_reBuyButton];
    
    _detailButton=[UIButton buttonWithTitle:@"查看订单" titleColor:color font:font];
    _detailButton.layer.cornerRadius=5.0;
    _detailButton.layer.masksToBounds=YES;
    _detailButton.layer.borderColor=[color CGColor];
    _detailButton.layer.borderWidth=1.0;
    [_detailButton addTarget:self action:@selector(didCheckOrderDetailButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_detailButton];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, OCUISCALE(5), 0));
    }];

    [_orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.bgView.mas_top).offset(5);
        make.left.mas_equalTo(weakSelf.bgView.mas_left).offset(kEMOffX);
        make.right.mas_equalTo(weakSelf.bgView.mas_centerX);
    }];
    [_orderTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.orderNumLabel.mas_right);
        make.top.mas_equalTo(weakSelf.orderNumLabel.mas_top);
        make.right.mas_equalTo(weakSelf.bgView.mas_right).offset(-kEMOffX);
    }];
    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.orderNumLabel.mas_left);
        make.top.mas_equalTo(weakSelf.orderNumLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(weakSelf.checkImageView.mas_left).offset(-10);
        make.height.mas_equalTo([EMOrderListGoodsItemCell orderGoodsListItemCellSize].height);
    }];
    [_checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.bgView.mas_right).offset(OCUISCALE(-13));
        make.centerY.mas_equalTo(weakSelf.myCollectionView.mas_centerY);
    }];
    
    [lineView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.bgView);
        make.top.mas_equalTo(weakSelf.myCollectionView.mas_bottom).offset(OCUISCALE(10));
        make.height.mas_equalTo(0.5);
    }];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.orderNumLabel.mas_left);
        make.right.mas_equalTo(weakSelf.orderTimeLabel.mas_right);
        make.top.mas_equalTo(lineView0.mas_bottom).offset(OCUISCALE(10));
    }];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.bgView);
        make.top.mas_equalTo(weakSelf.priceLabel.mas_bottom).offset(OCUISCALE(10));
        make.height.mas_equalTo(0.5);
    }];
    [_reBuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.checkImageView.mas_right);
        make.top.mas_equalTo(lineView1.mas_bottom).offset(OCUISCALE(10));
//        make.size.mas_equalTo(CGSizeMake(OCUISCALE(66), OCUISCALE(21)));
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(0), OCUISCALE(0)));
      
    }];
    [_detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(66), OCUISCALE(21)));
              make.top.mas_equalTo(lineView1.mas_bottom).offset(OCUISCALE(10));
            make.right.mas_equalTo(weakSelf.reBuyButton.mas_left).offset(OCUISCALE(-12));
          make.bottom.mas_equalTo(weakSelf.bgView.mas_bottom).offset(OCUISCALE(-10)).priorityHigh();
    }];
}

-(void)setOrderModel:(EMOrderModel *)orderModel{
    _orderModel=orderModel;
    if (_orderModel.orderState==EMOrderStateUnSigned) {
        if (_reBuyButton.hidden) {
            WEAKSELF
            [_reBuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.removeExisting=YES;
                make.right.mas_equalTo(weakSelf.checkImageView.mas_right);
                make.top.mas_equalTo(weakSelf.detailButton.mas_top);
                make.size.mas_equalTo(CGSizeMake(OCUISCALE(66), OCUISCALE(21)));
            }];
            [_reBuyButton setTitle:@"确认收货" forState:UIControlStateNormal];
            _reBuyButton.hidden=NO;
        }
    }
    [self.myCollectionView reloadData];
    self.orderNumLabel.text=_orderModel.orderNumber;
    _orderTimeLabel.text=_orderModel.subitTime;
    NSInteger buyCount=0;
    for (EMOrderGoodsModel *goodsModel in _orderModel.goodsArray) {
        buyCount+=goodsModel.buyCount;
    }
    NSString *priceText=[NSString stringWithFormat:@"共%ld件商品，合计$%.1f",buyCount,_orderModel.payPrice-_orderModel.discountPrice];
    if (orderModel.discountPrice) {
        priceText=[priceText stringByAppendingString:[NSString stringWithFormat:@"(已优惠$%.1f)",_orderModel.discountPrice]];
    }
    self.priceLabel.text=priceText;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count=self.orderModel.goodsArray.count;
    return count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *aCell;
    EMOrderListGoodsItemCell *cell=(EMOrderListGoodsItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EMOrderListGoodsItemCell class]) forIndexPath:indexPath];
    EMOrderGoodsModel *goodsModel=self.orderModel.goodsArray[indexPath.row];
    cell.imageUrl=goodsModel.goodsImageUrl;
    aCell=cell;
    return aCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    CGSize size = flowLayout.itemSize;
    return size;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}


- (void)didReBuyButtonPressed{
//        [[NSNotificationCenter defaultCenter] postNotificationName:kEMOrderShoudBuyAgainEvent object:self.orderModel];
//    [[self nextResponder]routerEventName:kEMOrderShoudBuyAgainEvent userInfo:@{kEMOrderShoudBuyAgainEvent:self.orderModel}];
    if (self.orderModel.orderState==EMOrderStateUnSigned) {
        if (_delegate&&[_delegate respondsToSelector:@selector(updateOrderState:state:)]) {
            [_delegate updateOrderState:self.orderModel state:EMOrderStateFinished];
        }
    }
  
}

- (void)didCheckOrderDetailButtonPressed{
    [[NSNotificationCenter defaultCenter] postNotificationName:kEMOrderGotoOrderDetailEvent object:self.orderModel];
//     [[self nextResponder]routerEventName:kEMOrderGotoOrderDetailEvent userInfo:@{kEMOrderShoudBuyAgainEvent:self.orderModel}];
//    if (_delegate&&[_delegate respondsToSelector:@selector(orderListCellShouldCheckOrderDetail)]) {
//        [_delegate orderListCellShouldCheckOrderDetail];
//    }
}
- (UICollectionView *)myCollectionView{
    if (nil==_myCollectionView) {
        UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing=0;
        
        flowLayout.estimatedItemSize=CGSizeMake(1, 1);
        UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 100, 20) collectionViewLayout:flowLayout];
        mainView.backgroundColor = [UIColor clearColor];
        mainView.pagingEnabled = NO;
        mainView.showsHorizontalScrollIndicator = NO;
        mainView.showsVerticalScrollIndicator = NO;
        mainView.dataSource = self;
        mainView.delegate = self;
//        mainView.alwaysBounceHorizontal=YES;
        _myCollectionView=mainView;
        [_myCollectionView registerClass:[EMOrderListGoodsItemCell class] forCellWithReuseIdentifier:NSStringFromClass([EMOrderListGoodsItemCell class])];
    }
    return _myCollectionView;
}
@end
