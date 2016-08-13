//
//  EMOrderGoodsCell.m
//  EMall
//
//  Created by Luigi on 16/8/13.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMOrderGoodsCell.h"

@interface EMOrderGoodsItemCell :UICollectionViewCell
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,copy)NSString *imageUrl;
@end
@implementation EMOrderGoodsItemCell

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
    
    attributes.size=CGSizeMake(80, 80);
    return attributes;
}
@end

@interface EMOrderGoodsCell ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView *myCollectionView;
@end

@implementation EMOrderGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UICollectionView *)myCollectionView{
    if (nil==_myCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing=0;
        flowLayout.estimatedItemSize=CGSizeMake(1, 1);
        UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:flowLayout];
        mainView.backgroundColor = [UIColor clearColor];
        mainView.pagingEnabled = NO;
        mainView.showsHorizontalScrollIndicator = NO;
        mainView.showsVerticalScrollIndicator = NO;
        mainView.dataSource = self;
        mainView.delegate = self;
        _myCollectionView=mainView;
        [_myCollectionView registerClass:[EMOrderGoodsItemCell class] forCellWithReuseIdentifier:NSStringFromClass([EMOrderGoodsItemCell class])];
        
    }
    return _myCollectionView;
}
@end
