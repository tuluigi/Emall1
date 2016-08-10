//
//  EMAreaModel.h
//  EMall
//
//  Created by Luigi on 16/8/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseModel.h"

@interface EMAreaModel : OCBaseModel
@property (nonatomic,copy)NSString *areaName,*shortname;
@property (nonatomic,assign)NSInteger parentID,areaID;
@property (nonatomic,copy)NSString *lng,*lat;
@end
