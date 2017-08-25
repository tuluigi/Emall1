//
//  EMHomeImageCell.m
//  EMall
//
//  Created by netease on 2017/8/14.
//  Copyright © 2017年 Luigi. All rights reserved.
//

#import "EMHomeImageCell.h"

@interface EMHomeImageCell ()
@property (nonatomic,strong)UIImageView *imageView;
@end

@implementation EMHomeImageCell
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onInitContentView];
    }
    return self;
}


- (void)onInitContentView{
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    _imageView.layer.borderColor= [UIColor whiteColor].CGColor;
    _imageView.layer.borderWidth=2.0;
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setImageUrl:(NSString *)url{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:EMDefaultImage];
}
- (void)setImage:(UIImage *)image{
    self.imageView.image= image;
}
@end
