//
//  OCUTableViewBadgeCell.m
//  OpenCourse
//
//  Created by Luigi on 15/11/25.
//
//

#import "OCUTableViewBadgeCell.h"
#import "OCTableCellBadgeModel.h"
#import  "JSBadgeView.h"
@interface OCUTableViewBadgeCell ()
@property (nonatomic,strong)UILabel *badgeLable;
@property (nonatomic,strong)UIImageView *badgeControl;
@property (nonatomic,strong) JSBadgeView *badgeView;
@end

@implementation OCUTableViewBadgeCell
-(void)onInitContentView{
    [super onInitContentView];
    [self.contentView addSubview:self.badgeView];
    WEAKSELF
    [self.badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(21, 21));
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-13);
    }];
    self.badgeView.layer.cornerRadius=21/2.0;
    self.badgeView.layer.masksToBounds=YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    WEAKSELF
    [self.badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(21, 21));
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-13);
    }];
    
}

-(void)setCellModel:(OCTableCellModel *)cellModel{
    [super setCellModel:cellModel];
    NSString *badageValue = [(OCTableCellBadgeModel *)cellModel badgeVaule];
    self.badgeView.badgeText=badageValue;
    if (badageValue&&badageValue.length) {
        self.badgeView.hidden=NO;
    }else{
        self.badgeView.hidden=YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
-(UILabel *)badgeLable{
    if (nil==_badgeLable) {
        
        _badgeLable=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:11] textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
        _badgeLable.enabled=NO;
        _badgeLable.adjustsFontSizeToFitWidth=YES;
    }
    return _badgeLable;
}
- (JSBadgeView *)badgeView{
    if (nil==_badgeView) {
        UIColor *bgColo=[UIColor colorWithHexString:@"#f8b551"];
        _badgeView=[[JSBadgeView alloc]  init];
        _badgeView.badgeTextColor=[UIColor whiteColor];
        _badgeView.backgroundColor=bgColo;
    }
    return _badgeView;
}

@end
