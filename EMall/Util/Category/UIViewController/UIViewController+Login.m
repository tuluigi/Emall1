//
//  UIViewController+Login.m
//  EMall
//
//  Created by Luigi on 16/7/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "UIViewController+Login.h"
#import "EMLoginViewController.h"
@implementation UIViewController (Login)
- (void)showLoginControllerOnCompletionBlock:(EMLoginResultBlock)completionBlock{
    EMLoginViewController *loginController=[EMLoginViewController loginViewControllerOnCompletionBlock:^(EMUserModel *userModel) {
        if (completionBlock) {
            BOOL isSucceed=NO;
            if (userModel) {
                isSucceed=YES;
            }
            completionBlock(isSucceed);
        }
    }];
    UINavigationController *navController=[[UINavigationController alloc]  initWithRootViewController:loginController];
    [self.navigationController presentViewController:navController animated:YES completion:^{
        
    }];
}
@end
