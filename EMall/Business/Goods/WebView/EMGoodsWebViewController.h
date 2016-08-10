//
//  EMGoodsWebViewController.h
//  EMall
//
//  Created by Luigi on 16/8/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseViewController.h"

@interface EMGoodsWebViewController : OCBaseViewController
- (instancetype)initWithUrl:(NSString *)url;
- (instancetype)initWithHtmlString:(NSString *)htmlString;
@end
