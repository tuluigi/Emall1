//
//  EMGoodsSpecView.m
//  EMall
//
//  Created by Luigi on 16/7/27.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsSpecView.h"
#import "EMGoodsModel.h"
#import "UITextField+HiddenKeyBoardButton.h"
#import "NSAttributedString+Price.h"
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
@property (nonatomic,assign)BOOL enable;
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
    _titleLabel.adjustsFontSizeToFitWidth=YES;
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
+ (CGSize)itemCellSizeWithTitle:(NSString *)title{
    CGSize aSize=[title boundingRectWithfont:[UIFont oc_systemFontOfSize:13] maxTextSize:CGSizeMake(OCWidth, 20)];
    aSize=CGSizeMake(OCUISCALE(aSize.width+30),OCUISCALE(35) );
    return aSize;
}
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    UICollectionViewLayoutAttributes *attributes=[super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    CGSize size=CGSizeMake(60,35 );
    
    if (![NSString isNilOrEmptyForString:_titleString]) {
        NSString *textString=[_titleString copy];
        CGSize aSize= [textString boundingRectWithSize:CGSizeMake(OCWidth, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont oc_systemFontOfSize:13],NSFontAttributeName, nil] context:nil].size;
        
        size=aSize;
    }
    
    attributes.size=size;
    return attributes;
}
- (void)setEnable:(BOOL)enable{
    _enable=enable;
    UIColor *textColor=kEM_LightDarkTextColor;
    if (_enable) {
        textColor=kEM_RedColro;
    }else{
        textColor=kEM_LightDarkTextColor;
    }
    _titleLabel.textColor=textColor;
    _titleLabel.layer.borderColor=textColor.CGColor;
    _titleLabel.layer.borderWidth=0.5;
}
@end



@protocol EMGoodsSpecCountCellDelegage <NSObject>

- (void)goodsSpecCountCellDidBuyCountValueChanged:(NSInteger)buyCount;

@end
@interface EMGoodsSpecCountCell : UICollectionViewCell<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *countTextField;
@property (nonatomic,strong)UIButton *plusButton, *minusButton;//选择按钮
@property (nonatomic,assign)NSInteger buyCount;
@property (nonatomic,weak)id <EMGoodsSpecCountCellDelegage>delegate;
+ (CGSize)specCountCellSize;
@end

@implementation EMGoodsSpecCountCell
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
    
    UIColor *color=[UIColor colorWithHexString:@"#272727"];
    _countTextField=[[UITextField alloc]  init];
    _countTextField.delegate=self;
    _countTextField.layer.borderColor=[[UIColor colorWithHexString:@"#e5e5e5"] CGColor];
    _countTextField.layer.borderWidth=0.8;
    _countTextField.font=[UIFont oc_systemFontOfSize:11];
    _countTextField.adjustsFontSizeToFitWidth=YES;
    _countTextField.multipleTouchEnabled=YES;
    _countTextField.keyboardType=UIKeyboardTypeNumberPad;
    [_countTextField addHiddenKeyBoardInputAccessView];
    [self.contentView addSubview:_countTextField];
    _minusButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _minusButton.frame=CGRectMake(0, 0, OCUISCALE(30), OCUISCALE(30));
    [_minusButton setTitle:@"-" forState:UIControlStateNormal];
    [_minusButton setTitleColor:color forState:UIControlStateNormal];
    _minusButton.userInteractionEnabled=YES;
    [_minusButton addTarget:self action:@selector(didSpecMinuseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _minusButton.layer.borderColor=[[UIColor colorWithHexString:@"#e5e5e5"] CGColor];
    _minusButton.layer.borderWidth=0.5;
    _countTextField.leftView=_minusButton;
    _countTextField.leftViewMode=UITextFieldViewModeAlways;
    _countTextField.textAlignment=NSTextAlignmentCenter;
    
    UIButton *plusButton=[UIButton buttonWithType:UIButtonTypeCustom];
    plusButton.userInteractionEnabled=YES;
    plusButton.frame=CGRectMake(0, 0, OCUISCALE(30), OCUISCALE(30));
    [plusButton setTitle:@"+" forState:UIControlStateNormal];
    [plusButton setTitleColor:color forState:UIControlStateNormal];
    plusButton.layer.borderColor=[[UIColor colorWithHexString:@"#e5e5e5"] CGColor];
    plusButton.layer.borderWidth=0.8;
    [plusButton addTarget:self action:@selector(didSpecPlusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _plusButton=plusButton;
    _countTextField.rightView=plusButton;
    _countTextField.rightViewMode=UITextFieldViewModeAlways;
    _countTextField.userInteractionEnabled=YES;
    self.contentView.userInteractionEnabled=YES;
    WEAKSELF
    [_countTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(5);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(5)
        ;
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(100), OCUISCALE(30)));
    }];
    
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    UICollectionViewLayoutAttributes *attributes=[super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    CGSize size=[EMGoodsSpecCountCell specCountCellSize];
    attributes.size=size;
    return attributes;
}
+ (CGSize)specCountCellSize{
    CGSize size=CGSizeMake(150,40 );
    return size;
}
- (void)setBuyCount:(NSInteger)buyCount{
    if (buyCount>=EMGoodsMaxBuyCount) {
        [self showOverMaxBuyCountMessage];
        return ;
    }
    _buyCount=buyCount;
    self.countTextField.text=[NSString stringWithFormat:@"%ld",_buyCount];
    if (buyCount<=1) {
        self.minusButton.enabled=NO;
    }else{
        self.minusButton.enabled=YES;
    }
    if (_delegate &&[_delegate respondsToSelector:@selector(goodsSpecCountCellDidBuyCountValueChanged:)]) {
        [_delegate goodsSpecCountCellDidBuyCountValueChanged:self.buyCount];
    }
}
- (void)updateBuyCount:(NSInteger)buyCount{
    if (buyCount>=EMGoodsMaxBuyCount) {
        [self showOverMaxBuyCountMessage];
        return ;
    }
    self.countTextField.text=[NSString stringWithFormat:@"%ld",buyCount];
    if (buyCount<=1) {
        self.minusButton.enabled=NO;
    }else{
        self.minusButton.enabled=YES;
    }
    if (_delegate &&[_delegate respondsToSelector:@selector(goodsSpecCountCellDidBuyCountValueChanged:)]) {
        [_delegate goodsSpecCountCellDidBuyCountValueChanged:self.buyCount];
    }
}
- (void)showOverMaxBuyCountMessage{
    [[UIApplication sharedApplication].keyWindow showHUDMessage:[NSString stringWithFormat:@"最多只能购买%d件",EMGoodsMaxBuyCount] yOffset:(0)];
}
- (void)didSpecPlusButtonPressed:(UIButton *)sender{
    self.buyCount=self.buyCount+1;
}
- (void)didSpecMinuseButtonPressed:(UIButton *)sender{
    self.buyCount=self.buyCount-1;
}

#pragma mark -textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *value=textField.text;
    value=[textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSInteger buyCount=value.integerValue;
    self.buyCount=buyCount;
    return NO;
}

@end

@interface EMGoodsSpecView ()<EMGoodsSpecCountCellDelegage,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UIImageView *goodsImageView;
@property (nonatomic,strong)UILabel *titleLabel,*priceLabel,*quantityLabel;
@property (nonatomic,strong)UIButton *submitButton,*closeButton;
@property (nonatomic,strong)UICollectionView *myCollectionView;
@property (nonatomic,strong)EMGoodsSpecViewDismissBlock dismissBlock;
@property (nonatomic,strong)EMGoodsDetailModel *detailModel;
@property (nonatomic,strong)NSMutableArray *keysArray;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,assign)NSInteger buyCount;

@property (nonatomic,strong)NSMutableDictionary *enableSpecDic,*selectSpecDic;//所有可以用的规格dic.， 和已选中的specDic
@property (nonatomic,strong)NSMutableDictionary *selectInfoDic;//所有选中的明细dic

@end

@implementation EMGoodsSpecView

@synthesize selectInfoDic=_selectInfoDic;

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
-(NSMutableArray *)keysArray{
    if (nil==_keysArray) {
        _keysArray=[NSMutableArray new];
    }
    return _keysArray;
}
-(NSMutableDictionary *)enableSpecDic{
    if (nil==_enableSpecDic) {
        _enableSpecDic=[NSMutableDictionary new];
    }
    return _enableSpecDic;
}
-(NSMutableDictionary *)selectInfoDic{
    if (nil==_selectInfoDic) {
        _selectInfoDic=[NSMutableDictionary new];
    }
    return _selectInfoDic;
}
-(NSMutableDictionary *)selectSpecDic{
    if (nil==_selectSpecDic) {
        _selectSpecDic=[NSMutableDictionary new];
    }
    return _selectSpecDic;
}
- (void)setSelectInfoDic:(NSMutableDictionary *)selectInfoDic{
    _selectInfoDic=selectInfoDic;
    if (_selectInfoDic.allValues.count) {
        [self reSetGoodsPriceWithGoodsInfoModel:[_selectInfoDic.allValues firstObject]];
    }
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
    self.buyCount=1;
    UIColor *textColor=[UIColor colorWithHexString:@"#272727"];
    
    _goodsImageView=[UIImageView new];
    _goodsImageView.contentMode=UIViewContentModeScaleAspectFill;
    _goodsImageView.clipsToBounds=YES;
    [self addSubview:_goodsImageView];
    
    _titleLabel=[UILabel labelWithText:@"" font:[UIFont oc_boldSystemFontOfSize:13] textAlignment:NSTextAlignmentLeft];
    _titleLabel.textColor=textColor;
    [self addSubview:_titleLabel];
    
    _priceLabel=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:13] textAlignment:NSTextAlignmentLeft];
    _priceLabel.textColor=[UIColor colorWithHexString:@"#e51e0e"];
    [self addSubview:_priceLabel];
    _quantityLabel=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:13] textAlignment:NSTextAlignmentRight];
    _quantityLabel.textColor=textColor;
    _quantityLabel.adjustsFontSizeToFitWidth=YES;
    [self addSubview:_quantityLabel];
    
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
    
    //    _submitButton.enabled=NO;
    [self addSubview:_submitButton];
    
    WEAKSELF
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(weakSelf).offset(kEMOffX);
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(80), OCUISCALE(50)));
    }];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.goodsImageView.mas_top);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-kEMOffX);
        make.width.mas_lessThanOrEqualTo(40);
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
    [_quantityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.mas_right).offset(OCUISCALE(-10));
        make.top.mas_equalTo(weakSelf.priceLabel);
        make.width.mas_lessThanOrEqualTo(OCUISCALE(120));
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
    
    [self.myCollectionView reloadData];
}
- (void)didActionButtonPressed:(UIButton *)sender{
    WEAKSELF
    if (sender==self.submitButton) {
        if (self.buyCount<=0) {
            [self showHUDMessage:@"请填写购买数量"];
            return;
        }
        if (self.selectInfoDic.allValues.count>1 ||self.selectInfoDic.allValues.count<1 ) {
            [self showHUDMessage:@"请先选择其他规格哦"];
        }else{
            EMGoodsInfoModel *infoModel=[self.selectInfoDic.allValues firstObject];
            NSInteger count=self.buyCount;
            if (nil==infoModel) {
                count=0;
                [self showHUDMessage:@"商品数据错误"];
                return;
            }
            if (count>infoModel.quantity) {
                [self showHUDMessage:@"库存不足"];
                return;
            }
            if (self.dismissBlock) {
                self.dismissBlock(weakSelf, YES,weakSelf.detailModel.goodsModel.goodsID, count,infoModel.infoID);
            }
        }
    }else if (sender==self.closeButton){
        if (self.dismissBlock) {
            self.dismissBlock(weakSelf, NO,0,0,0);
        }
    }
}

- (void)setDetailModel:(EMGoodsDetailModel *)detailModel{
    _detailModel=detailModel;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:_detailModel.goodsModel.goodsImageUrl] placeholderImage:EMDefaultImage];
    _titleLabel.text=stringNotNil(_detailModel.goodsModel.goodsName);
    
    [self.keysArray removeLastObject];
    [self.keysArray addObjectsFromArray:[_detailModel.specDic allKeys]];
    [self.keysArray addObject:@"数量"];
    [self.selectInfoDic setObject:_detailModel.defaultGoodsInfo forKey:@(_detailModel.defaultGoodsInfo.infoID)];
    
    self.enableSpecDic=[[NSMutableDictionary alloc]  initWithDictionary:_detailModel.defaultGoodsInfo.specsDic];
    for (EMSpecModel *specModel in [self.enableSpecDic allValues]) {
        [self.selectSpecDic setObject:specModel forKey:specModel.pName];
    }
    [self reSetGoodsPriceWithGoodsInfoModel:_detailModel.defaultGoodsInfo];
    
    [self.myCollectionView reloadData];
    //    self.submitButton.enabled=_detailModel.goodsInfoArray.count;
}

- (void)reSetGoodsPriceWithGoodsInfoModel:(EMGoodsInfoModel *)infoModel{
    
    _priceLabel.attributedText=[NSAttributedString goodsPriceAttrbuteStringWithPrice:infoModel.goodsPrice promotePrice:infoModel.promotionPrice];
    if (infoModel.quantity<=0) {
        _quantityLabel.text=@"无货";
    }else if (infoModel.quantity<10) {//小于20件才有提示
        _quantityLabel.text=[NSString stringWithFormat:@"库存:%ld件",infoModel.quantity];
    }else{
        _quantityLabel.text=@"";
    }
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.keysArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger row=0;
    if (section<self.keysArray.count-1) {
        NSString *key=[self.keysArray objectAtIndex:section];
        NSDictionary *dic=[self.detailModel.specDic objectForKey:key];
        row=[dic allKeys].count;
    }else{
        row=1;
    }
    return row;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *aCell;
    if (indexPath.section<self.keysArray.count-1) {
        EMGoodsSpecCell *cell=(EMGoodsSpecCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EMGoodsSpecCell class]) forIndexPath:indexPath];
        
        NSString *key=[self.keysArray objectAtIndex:indexPath.section];
        // NSArray *valueArray=[self.detailModel.specDic objectForKey:key];
        NSDictionary *specDic=[self.detailModel.specDic objectForKey:key];
        NSArray *valueArray=[specDic allValues];
        EMSpecModel *specModel=[valueArray objectAtIndex:indexPath.row];
        
        cell.titleString=specModel.name;
        EMSpecModel *selectSpecModel=[self.selectSpecDic objectForKey:specModel.pName];
        
        BOOL isEnable=NO;
        if (selectSpecModel&&selectSpecModel.specID==specModel.specID && [selectSpecModel.name isEqualToString:specModel.name]) {
            isEnable=YES;
        }
        cell.enable=isEnable;
        aCell=cell;
    }else{
        EMGoodsSpecCountCell *cell=(EMGoodsSpecCountCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EMGoodsSpecCountCell class]) forIndexPath:indexPath];
        cell.userInteractionEnabled=YES;
        cell.delegate=self;
        cell.buyCount=self.buyCount;
        aCell=cell;
    }
    
    return aCell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section<collectionView.numberOfSections-1) {
        NSString *key=[self.keysArray objectAtIndex:indexPath.section];
        NSDictionary *specDic=[self.detailModel.specDic objectForKey:key];
        NSArray *valueArray=[specDic allValues];
        EMSpecModel *specModel=[valueArray objectAtIndex:indexPath.row];
        
        
        CGSize aSize=[EMGoodsSpecCell itemCellSizeWithTitle:specModel.name];
        return aSize;
    }else{
        CGSize size=[EMGoodsSpecCountCell specCountCellSize];
        return size;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size=CGSizeMake(OCWidth, OCUISCALE(30));
    //    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    //    size=flowLayout.headerReferenceSize;
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
    if (section+1==[collectionView numberOfSections]) {
        size=CGSizeMake(OCWidth, 15);
    }
    return size;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section<collectionView.numberOfSections-1) {
        NSString *key=[self.keysArray objectAtIndex:indexPath.section];
        // NSArray *valueArray=[self.detailModel.specDic objectForKey:key];
        NSDictionary *specDic=[self.detailModel.specDic objectForKey:key];
        NSArray *valueArray=[specDic allValues];
        EMSpecModel *specModel=[valueArray objectAtIndex:indexPath.row];
        [self.selectSpecDic setObject:specModel forKey:specModel.pName];
        NSMutableDictionary *aInfoDic;
        self.enableSpecDic=[EMGoodsSpecView enableSpecDicWithAlreadySelectSpecDic:self.selectSpecDic infoArrays:self.detailModel.goodsInfoArray infoDic:&aInfoDic];
        [self.selectInfoDic removeAllObjects];
        self.selectInfoDic=aInfoDic;
        [collectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, collectionView.numberOfSections-1)]];
    }
}

+(NSMutableDictionary *)enableSpecDicWithAlreadySelectSpecDic:(NSMutableDictionary *)alreadyDic infoArrays:(NSArray *)infoArray infoDic:(NSMutableDictionary **)goodsInfoDic{
    NSMutableDictionary *enableSpecDic=[NSMutableDictionary new];
    
    if (nil==*goodsInfoDic) {
        *goodsInfoDic=[NSMutableDictionary new];
    }
    [*goodsInfoDic removeAllObjects];
    
    NSMutableArray *selectSpectArray=[NSMutableArray new];
    for (EMSpecModel *specModel in [alreadyDic allValues]) {
        [selectSpectArray addObject:specModel.name];
    }
    for (EMGoodsInfoModel *infoModel in infoArray) {
        //按照pame进行逐个比较该明细中是否包含选中的名字
        NSArray *infoKeyArray=[[infoModel specsDic] allKeys];
        NSArray *alreadyKeyAary=selectSpectArray;
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(SELF in %@)",alreadyKeyAary];
        NSArray *tempArray=[infoKeyArray filteredArrayUsingPredicate:predicate];
        if (tempArray.count==infoKeyArray.count) {
            [*goodsInfoDic setObject:infoModel forKey:@(infoModel.infoID)];//添加当条明细
            [enableSpecDic setValuesForKeysWithDictionary:infoModel.specsDic];//添加该明细中所有的规格
        }
    }
    return enableSpecDic;
}

#pragma mark - CellCount Delegate
- (void)goodsSpecCountCellDidBuyCountValueChanged:(NSInteger)buyCount{
    self.buyCount=buyCount;
}
- (UICollectionView *)myCollectionView{
    if (nil==_myCollectionView) {
        UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing=0;
        //        flowLayout.estimatedItemSize=CGSizeMake(50, 35);
        //        flowLayout.itemSize=CGSizeMake(1, 1);
        //        flowLayout.headerReferenceSize=CGSizeMake(OCWidth, OCUISCALE(30));
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
        [_myCollectionView registerClass:[EMGoodsSpecCountCell class] forCellWithReuseIdentifier:NSStringFromClass([EMGoodsSpecCountCell class])];
        [_myCollectionView registerClass:[EMGoodsSepcHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([EMGoodsSepcHeadView class])];
        [_myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
    }
    return _myCollectionView;
}
@end
