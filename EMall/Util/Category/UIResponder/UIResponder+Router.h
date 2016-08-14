//
//  UIResponder+Router.h
//  EMall
//
//  Created by Luigi on 16/8/14.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Router)
- (void)routerEventName:(NSString *)event userInfo:(NSDictionary *)userInfo;
@end
