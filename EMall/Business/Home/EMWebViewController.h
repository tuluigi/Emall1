//
//  EMWebViewController.h
//  EMall
//
//  Created by Luigi on 16/8/15.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseViewController.h"

@interface EMWebViewController : OCBaseViewController
- (instancetype)initWithUrl:(NSString *)url title:(NSString *)title;
- (instancetype)initWithHtmlString:(NSString *)htmlString title:(NSString *)title;
@end
