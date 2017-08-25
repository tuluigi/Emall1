//
//  EMHomeHeadReusableView.h
//  EMall
//
//  Created by Luigi on 16/7/4.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,EMHomeReusableViewType) {//商品接口对应的value
    EMHomeReusableViewTypeGreat     =1,//精品
    EMHomeReusableViewTypeHot       =2,//热品
};

@protocol EMHomeHeadReusableViewDelegate <NSObject>

- (void)homeHeadReusableViewDidSelect:(EMHomeReusableViewType)type;

@end


@interface EMHomeHeadReusableView : UICollectionReusableView
@property (nonatomic,assign)EMHomeReusableViewType type;
+ (CGFloat)homeHeadReusableViewHeight;
@property (nonatomic,weak)id <EMHomeHeadReusableViewDelegate> delegate;
@end
