//
//  EMLoginViewController.h
//  EMall
//
//  Created by Luigi on 16/7/8.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseTableViewController.h"

@class EMUserModel;

typedef void(^EMLoginCompletionBlock)(EMUserModel *userModel);
typedef void(^EMRegisterCompletionBlock)(EMUserModel *userModel);
@interface EMLoginViewController : OCBaseTableViewController

+ (EMLoginViewController *)loginViewControllerOnCompletionBlock:(EMLoginCompletionBlock)competionBlock;

+ (EMLoginViewController *)registerViewControlerOnCompletionBlock:(EMRegisterCompletionBlock)competionBlock;

@end
