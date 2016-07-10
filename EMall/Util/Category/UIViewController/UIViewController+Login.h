//
//  UIViewController+Login.h
//  EMall
//
//  Created by Luigi on 16/7/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EMLoginResultBlock)(BOOL isSucceed);

@interface UIViewController (Login)
- (void)loginOnController:(UIViewController *)aController onCompletionBlock:(EMLoginResultBlock)completionBlock;
@end
