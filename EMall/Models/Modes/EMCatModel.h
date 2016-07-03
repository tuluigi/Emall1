//
//  EMCatModel.h
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseModel.h"

@interface EMCatModel : OCBaseModel
@property (nonatomic,copy)NSString *catID;
@property (nonatomic,copy)NSString *catName;
@property (nonatomic,copy)NSString *catImageUrl;
@end
