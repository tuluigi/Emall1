//
//  EMMEHeadView.h
//  EMall
//
//  Created by Luigi on 16/6/22.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMMEHeadView : UIView
- (void)setUserName:(NSString *)userName headImageUrl:(NSString *)headImageUrl level:(NSInteger)level;
+ (EMMEHeadView *)meHeadView;
@end
