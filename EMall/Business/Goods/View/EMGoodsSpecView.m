//
//  EMGoodsSpecView.m
//  EMall
//
//  Created by Luigi on 16/7/27.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsSpecView.h"
#import "EMGoodsModel.h"


@interface EMGoodsSepcHeadView : UICollectionReusableView
@property (nonatomic,strong)UILabel *titleLabel;
@end

@implementation EMGoodsSepcHeadView
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onInitContentView];
    }
    return self;
}

- (void)onInitContentView{
    _titleLabel=[UILabel labelWithText:@"颜色" font:[UIFont oc_systemFontOfSize:14] textAlignment:NSTextAlignmentLeft];
    _titleLabel.textColor=kEM_GrayDarkTextColor;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
}


@end
@interface EMGoodsSpecCell : UICollectionViewCell
@property (nonatomic,strong)UIButton *titleButton;
@property (nonatomic,copy)NSString *titleString;
@property (nonatomic,strong)UILabel *titleLabel;
@end

@implementation EMGoodsSpecCell
-(instancetype)init{
    self=[self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    
    
    UIColor *textColor=kEM_LightDarkTextColor;
    _titleLabel=[UILabel labelWithText:@"颜色" font:[UIFont oc_systemFontOfSize:13] textAlignment:NSTextAlignmentCenter];
    _titleLabel.textColor=kEM_GrayDarkTextColor;
    _titleLabel.layer.cornerRadius=3;
    _titleLabel.layer.masksToBounds=YES;
    _titleLabel.layer.borderColor=textColor.CGColor;
    _titleLabel.layer.borderWidth=0.5;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
    }];

/*
    _titleButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_titleButton setTitleColor:textColor forState:UIControlStateNormal];
    [_titleButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _titleButton.layer.cornerRadius=3;
    _titleButton.layer.masksToBounds=YES;
    _titleButton.layer.borderColor=textColor.CGColor;
    _titleButton.layer.borderWidth=0.5;
    _titleButton.titleLabel.font=[UIFont oc_systemFontOfSize:13];
    [_titleButton setTitle:@"浅白色" forState:UIControlStateNormal];
    [self.contentView addSubview:self.titleButton];
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
 */
}
- (void)setTitleString:(NSString *)titleString{
    _titleString=titleString;
    self.titleLabel.text=_titleString;
//    [self.titleButton setTitle:_titleString forState:UIControlStateNormal];
}
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    UICollectionViewLayoutAttributes *attributes=[super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    NSString *textString=_titleString;
    CGSize aSize=[textString boundingRectWithfont:[UIFont oc_systemFontOfSize:13] maxTextSize:CGSizeMake(OCWidth, 20)];
    CGSize size=CGSizeMake(aSize.width+20,35 );
    attributes.size=size;
    return attributes;
}
@end


@interface EMGoodsSpecView ()
<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UIImageView *goodsImageView;
@property (nonatomic,strong)UILabel *titleLabel,*priceLabel;
@property (nonatomic,strong)UIButton *submitButton,*closeButton;
@property (nonatomic,strong)UICollectionView *myCollectionView;
@property (nonatomic,strong)EMGoodsSpecViewDismissBlock dismissBlock;
@property (nonatomic,strong)EMGoodsDetailModel *detailModel;
@property (nonatomic,strong)NSArray *keysArray;
@property (nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation EMGoodsSpecView
- (void)dealloc{
    NSLog(@"EMGoodsSpecView is dealloc");
}
+ (CGRect)specFrame{
    CGFloat height=OCHeight*0.7;
    CGRect rect=CGRectMake(0, OCHeight-height, OCWidth, height);
    return rect;
}
+(EMGoodsSpecView *)specGoodsViewWithGoodInfo:(id)goodInfo onDismsiBlock:(EMGoodsSpecViewDismissBlock)dismisBlock{
    CGRect frame=[EMGoodsSpecView specFrame];
    frame.origin.y=OCHeight;
    
    EMGoodsSpecView *aView=[[EMGoodsSpecView alloc]  initWithFrame:frame];
    aView.detailModel=goodInfo;
    aView.dismissBlock=dismisBlock;
    return aView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onInitContentView];
    }
    return self;
}

- (void)onInitContentView{
    self.backgroundColor=[UIColor whiteColor];
    
    UIColor *textColor=[UIColor colorWithHexString:@"#272727"];
    
    _goodsImageView=[UIImageView new];
    _goodsImageView.contentMode=UIViewContentModeScaleAspectFill;
    _goodsImageView.clipsToBounds=YES;
    [self addSubview:_goodsImageView];
    
    _titleLabel=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:13] textAlignment:NSTextAlignmentLeft];
    _titleLabel.textColor=textColor;
    [self addSubview:_titleLabel];
    
    _priceLabel=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:13] textAlignment:NSTextAlignmentLeft];
    _priceLabel.textColor=[UIColor colorWithHexString:@"#e51e0e"];
    [self addSubview:_priceLabel];
    
    UIView *lineView0=[UIView new];
    lineView0.backgroundColor=RGB(201, 201, 201);
    [self addSubview:lineView0];
    
    [self addSubview:self.myCollectionView];
    
    _closeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton addTarget:self action:@selector(didActionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setImage:[UIImage imageNamed:@"goods_closeBtn"] forState:UIControlStateNormal];
    [self addSubview:_closeButton];
    
    _submitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.backgroundColor=RGB(229, 26, 30);
    _submitButton.titleLabel.adjustsFontSizeToFitWidth=YES;
    [_submitButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitButton.titleLabel.font=[UIFont oc_boldSystemFontOfSize:17];
    [_submitButton addTarget:self action:@selector(didActionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_submitButton];

    WEAKSELF
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(weakSelf).offset(kEMOffX);
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(80), OCUISCALE(50)));
    }];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.goodsImageView.mas_top);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-kEMOffX);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.goodsImageView.mas_right).offset(5);
        make.top.mas_equalTo(weakSelf.goodsImageView);
        make.right.mas_equalTo(weakSelf.closeButton.mas_left).offset(-kEMOffX);
    }];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.titleLabel);
        make.bottom.mas_equalTo(weakSelf.goodsImageView.mas_bottom);
    }];
   
    [lineView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.goodsImageView.mas_bottom).offset(kEMOffX);
        make.height.mas_equalTo(0.5);
    }];
 
    
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).priorityHigh();
    }];
    [_myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).offset(kEMOffX);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-kEMOffX);
        make.top.mas_equalTo(lineView0.mas_bottom);
        make.bottom.mas_equalTo(weakSelf.submitButton.mas_top);
    }];
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img12.360buyimg.com/cms/jfs/t3040/77/579714529/106419/49e07450/57a7db82N076f7c59.jpg"] placeholderImage:EMDefaultImage];
    _titleLabel.text=@"太平鸟女装2016秋装新品圆领镂空针织衫A4DC63201";
    _priceLabel.text=@"￥120";
    [self.myCollectionView reloadData];
}
- (void)didActionButtonPressed:(UIButton *)sender{
    if (sender==self.submitButton) {

    }else if (sender==self.closeButton){
        WEAKSELF
        if (self.dismissBlock) {
            self.dismissBlock(weakSelf, NO,0,0,0);
        }
    }
    
}
- (void)setDetailModel:(EMGoodsDetailModel *)detailModel{
    _detailModel=detailModel;
    self.keysArray=[_detailModel.specDic allKeys];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.keysArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSString *key=[self.keysArray objectAtIndex:section];
    NSArray *valueArray=[self.detailModel.specDic objectForKey:key];
    return valueArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key=[self.keysArray objectAtIndex:indexPath.section];
    NSArray *valueArray=[self.detailModel.specDic objectForKey:key];
    EMGoodsSpecCell *cell=(EMGoodsSpecCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EMGoodsSpecCell class]) forIndexPath:indexPath];
    EMSpecModel *specModel=[valueArray objectAtIndex:indexPath.row];
    cell.titleString=specModel.name;
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    CGSize size = flowLayout.itemSize;
    return size;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size=CGSizeMake(OCWidth, OCUISCALE(30));
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView;
    if (kind==UICollectionElementKindSectionHeader) {
       reusableView =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([EMGoodsSepcHeadView class]) forIndexPath:indexPath];
        EMGoodsSepcHeadView *specHeadView=(EMGoodsSepcHeadView *)reusableView;
        NSString *title=[NSString stringWithFormat:@"请选择%@:", [self.keysArray objectAtIndex:indexPath.section]];
        specHeadView.titleLabel.text=title;
    }else if (kind==UICollectionElementKindSectionFooter){
        reusableView =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size=CGSizeZero;
    if (section==2) {
        size=CGSizeMake(OCWidth, 15);
    }
    return size;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}
- (UICollectionView *)myCollectionView{
    if (nil==_myCollectionView) {
        UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing=0;
        flowLayout.estimatedItemSize=CGSizeMake(1, 1);
        flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
        
        UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        mainView.backgroundColor = [UIColor clearColor];
        mainView.pagingEnabled = NO;
        mainView.showsHorizontalScrollIndicator = NO;
        mainView.showsVerticalScrollIndicator = NO;
        mainView.dataSource = self;
        mainView.delegate = self;
        mainView.userInteractionEnabled=YES;
        mainView.alwaysBounceVertical=YES;
        
        _myCollectionView=mainView;
        [_myCollectionView registerClass:[EMGoodsSpecCell class] forCellWithReuseIdentifier:NSStringFromClass([EMGoodsSpecCell class])];
        [_myCollectionView registerClass:[EMGoodsSepcHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([EMGoodsSepcHeadView class])];
         [_myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
    }
    return _myCollectionView;
}
@end
