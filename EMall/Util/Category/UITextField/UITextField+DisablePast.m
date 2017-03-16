//
//  UITextField+DisablePast.m
//  EMall
//
//  Created by Luigi on 16/7/19.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "UITextField+DisablePast.h"
#import <objc/runtime.h>
static char EnablePastKey;

@implementation UITextField (DisablePast)
- (void)setDisablePast:(BOOL)disablePast{
    objc_setAssociatedObject(self, &EnablePastKey, @(disablePast), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)disablePast{
    id enable= objc_getAssociatedObject(self, &EnablePastKey);
    return [(NSNumber *)enable boolValue];
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ([self disablePast]) {
        return NO;
        if (action == @selector(paste:)){
            return NO;
        }
        if (action == @selector(select:)){
            return NO;
        }
        if (action == @selector(selectAll:)){
            return NO;
        }
    }
    return [super canPerformAction:action withSender:sender];
}
@end
