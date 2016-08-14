//
//  UIResponder+Router.m
//  EMall
//
//  Created by Luigi on 16/8/14.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)
- (void)routerEventName:(NSString *)event userInfo:(NSDictionary *)userInfo{
    [[self nextResponder] routerEventName:event userInfo:userInfo];
}
@end
