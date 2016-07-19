//
//  EMCartBottomView.m
//  EMall
//
//  Created by Luigi on 16/7/19.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMCartBottomView.h"

@interface EMCartBottomView ()
@property (nonatomic,strong)UIButton *checkMarkButton;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UIButton *submitButton;
@end

@implementation EMCartBottomView
-(instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)updateCartBottomWithSelectItemCount:(NSInteger)count totalItems:(NSInteger)totalItems totalPrice:(CGFloat)totalPrice{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
