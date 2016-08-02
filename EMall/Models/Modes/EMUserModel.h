//
//  EMUserModel.h
//  EMall
//
//  Created by Luigi on 16/7/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseModel.h"

@interface EMUserModel : OCBaseModel
@property(nonatomic,assign)NSInteger userID;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *avatar;
@property(nonatomic,copy)NSString *email,*tel,*nickName,*gender;
@property (nonatomic,assign)NSInteger level;
@property (nonatomic,strong)NSDate *birtadyDay;
@end
