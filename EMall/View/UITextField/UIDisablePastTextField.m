//
//  UIDisablePastTextField.m
//  EMall
//
//  Created by Luigi on 16/7/19.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "UIDisablePastTextField.h"

@implementation UIDisablePastTextField
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:)){
        return NO;
    }
    if (action == @selector(select:)){
        return NO;
    }
    if (action == @selector(selectAll:)){
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
