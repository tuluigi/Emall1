//
//  EMAdModel.h
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseModel.h"

@interface EMAdModel : OCBaseModel
@property (nonatomic,copy)NSString *adID;
@property (nonatomic,copy)NSString *adTitle;
@property (nonatomic,copy)NSString *adImageUrl;
@property (nonatomic,copy)NSString *adUrl;
@end
