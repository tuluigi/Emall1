//
//  EMSystemConfigModel.h
//  EMall
//
//  Created by Luigi on 16/8/23.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseModel.h"

@interface EMSystemConfigModel : OCBaseModel
@property (nonatomic,copy)NSString *bsb;
@property (nonatomic,copy)NSString *acc;
@property (nonatomic,copy)NSString *accName;
@property (nonatomic,copy)NSString *serviceTel;
@property (nonatomic,copy)NSString *qrCodeUrl;
@end
