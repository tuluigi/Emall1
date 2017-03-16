//
//  EMCatModel.h
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseModel.h"

@interface EMCatModel : OCBaseModel
@property (nonatomic,assign)NSInteger catID;
@property (nonatomic,assign)NSInteger pid;//父类别ID
@property (nonatomic,copy)NSString *catName;
@property (nonatomic,copy)NSString *catImageUrl;
@property (nonatomic,strong)__block NSMutableArray *childCatArray;
@end
