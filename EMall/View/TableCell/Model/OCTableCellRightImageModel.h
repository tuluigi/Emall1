//
//  OCTableCellRightImageModel.h
//  EMall
//
//  Created by Luigi on 16/8/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCTableCellModel.h"

@interface OCTableCellRightImageModel : OCTableCellModel
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,copy)NSString *placeholderImageUrl;
@property (nonatomic,strong)UIImage *image;
@end
