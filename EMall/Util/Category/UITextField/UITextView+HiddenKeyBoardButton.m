//
//  UITextView+HiddenKeyBoardButton.m
//  EMall
//
//  Created by Luigi on 16/8/16.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "UITextView+HiddenKeyBoardButton.h"

@implementation UITextView (HiddenKeyBoardButton)
- (void)addHiddenKeyBoardInputAccessView{
    CGFloat width=[[UIScreen mainScreen] bounds].size.width;
    UIInterfaceOrientation interfaceOrientataion = [[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientataion== UIInterfaceOrientationLandscapeLeft || interfaceOrientataion == UIInterfaceOrientationLandscapeRight) {
        width=([UIScreen mainScreen].bounds.size.height);
    }else{
        width=([UIScreen mainScreen].bounds.size.width);
    }
    
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(resignFirstResponder)];
    doneButton.tintColor=RGB(229, 26, 30);
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] ;
    
    UIBarButtonItem *cancleButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(resignFirstResponder)];
    cancleButton.tintColor=[UIColor colorWithHexString:@"#272727"];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, width, 44)] ;
    toolbar.items = [NSArray arrayWithObjects:cancleButton,spaceButton,doneButton,nil];
    
    self.inputAccessoryView = toolbar;
}

@end
