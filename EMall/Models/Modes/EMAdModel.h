//
//  EMAdModel.h
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseModel.h"

typedef NS_ENUM(NSInteger,EMADType) {
    EMADTypeHome        =1,//首页的
};

@interface EMAdModel : OCBaseModel
@property (nonatomic,assign)NSInteger adID;
@property (nonatomic,copy)NSString *adTitle;
@property (nonatomic,copy)NSString *adImageUrl;
@property (nonatomic,copy)NSString *adUrl;
@property (nonatomic,assign)EMADType type;
@end
