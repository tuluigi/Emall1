//
//  UIView+OCPageLoad.m
//  OpenCourse
//
//  Created by Luigi on 15/8/31.
//
//

#import "UIView+OCPageLoad.h"
#import "OCPageLoadAnimationView.h"
#import "OCPageLoadView.h"
#import "SVProgressHUD.h"
static NSString * const OCPageLoadingViewPropertyKey = @"__OCPageLoadingViewPropertyKey";
@implementation UIView (OCPageLoad)
-(void)showPageLoadingData:(NSDictionary  *)dic{

}
-(void)showPageLoadingView:(CGRect)frame{
    NSMutableArray *imageArray=[[NSMutableArray alloc]  init];
    for (NSInteger i=0; i<31; i++) {
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"loading_000%ld",48+i]];
        if (image) {
            [imageArray addObject:image];
        }
    }
    NSDictionary *dic=@{OCPageLoadingAnimationImagesKey:imageArray,OCPageLoadingAnimationDurationKey:@(1.6),OCPageLoadViewTexKey:@"正在加载..."};
    [self showOCPageLoadViewData:dic frame:frame  delegate:nil];
    
}
-(void)showOCPageLoadViewData:(NSDictionary *)dic frame:(CGRect)frame delegate:(id)delegate{
     OCPageLoadAnimationView *pageLoadView=[self pageLoadView];
    if (CGRectEqualToRect(CGRectZero, pageLoadView.frame)||CGRectIsEmpty(pageLoadView.frame)) {
        if (CGRectIsEmpty(frame)||CGRectEqualToRect(CGRectZero, frame)) {
            if (pageLoadView.superview) {
                pageLoadView.frame=pageLoadView.superview.bounds;
            }
        }else{
            pageLoadView.frame=frame;
        }
    }
    [pageLoadView showLoadingData:dic inView:self delegate:delegate];
    
}
-(void)showPageLoadView:(UIView *)customeView frame:(CGRect)frame delegate:(id)delegate{
    if (CGRectIsEmpty(frame)||CGRectEqualToRect(CGRectZero, frame)) {
        frame=self.bounds;
    }
     customeView.frame=frame;
    if ([customeView isKindOfClass:[OCPageLoadView class]]) {
        [(OCPageLoadView *)customeView showLoadingViewInView:self delegate:delegate];
    }
}
/**
 *  显示默认的加载动画页面
 */
-(void)showPageLoadingView{
    [self showPageLoadingView:CGRectZero];
}

/**
 *  带有提示的页面
 *
 *  @param message  提示内容
 *  @param delegate delegate
 */

- (void)showPageLoadedMessage:(NSString *)message failureCode:(OCCodeState)codeState delegate:(id)delegate
{
    if (codeState == OCCodeStateNetworkFailure) {
        if ([message isEqualToString:@"网络不给力，请稍后重试"]) {
            message = @"网络不给力，请点击重试";
        }
        [self showPageLoadedMessage:message delegate:delegate];
    }else if (codeState != OCCodeStateSuccess)
    {
        [self showPageNilDataDelegate:delegate];
    }
}

-(void)showPageLoadedMessage:(NSString *)message delegate:(id)delegate{
    UIImage *image=[UIImage imageNamed:@"loading_connectFailed"];
    [self showPageLoadedMessage:message frame:CGRectZero image:image delegate:delegate];
}
-(void)showPageLoadedMessage:(NSString *)message frame:(CGRect)frame delegate:(id)delegate{
    UIImage *image=[UIImage imageNamed:@"loading_connectFailed"];
    [self showPageLoadedMessage:message frame:frame image:image delegate:delegate];
}
- (void)showPageLoadedMessage:(NSString *)message image:(UIImage *)image delegate:(id)delegate{
    [self showPageLoadedMessage:message frame:CGRectZero image:image  delegate:delegate];
}

- (void)showPageNilDataDelegate:(id)delegate
{
    [self showPageLoadedMessage:@"数据跑丢了，请点击重试" frame:CGRectZero image:[UIImage imageNamed:@"loading_data_nil"] delegate:delegate];
}

- (void)showFilterPageNilDataDelegate:(id)delegate
{
    [self showPageLoadedMessage:@"暂无相关课程" frame:CGRectZero image:[UIImage imageNamed:@"loading_data_nil"] delegate:delegate];
}

- (void)showPageLoadedMessage:(NSString *)message  frame:(CGRect)frame image:(UIImage *)image delegate:(id)delegate{
    if (nil==message) {
        message=@"网络开小差,请稍后重试";
    }
    NSDictionary *dic;
    if (image) {
        dic=@{OCPageLoadViewImageKey:image,OCPageLoadViewTexKey:message};
    }else{
        dic=@{OCPageLoadViewTexKey:message};
    }
    [self showOCPageLoadViewData:dic frame:frame  delegate:delegate];
}
- (void)showPageLoadCustomeView:(UIView *)loadView{
    [self showPageLoadView:loadView frame:CGRectZero delegate:nil];
}
/**
 *  隐藏delegate
 */
-(void)dismissPageLoadView{
    OCPageLoadAnimationView *pageView=(OCPageLoadAnimationView *)[self currentPageLoadView];
    if (pageView) {
        [pageView dismiss];
    }
}
-(OCPageLoadAnimationView *)pageLoadView{
   __block OCPageLoadAnimationView *pageView;
    pageView=(OCPageLoadAnimationView *)[self currentPageLoadView];
    if (nil==pageView) {
        pageView=[OCPageLoadAnimationView defaultPageLoadView];
    }
    return pageView;
}
-(OCPageLoadView *)currentPageLoadView{
    __block OCPageLoadAnimationView *pageView;
    [self.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[OCPageLoadView class]]) {
            pageView=obj;
            return ;
        }
    }];
    return pageView;
}
- (MBProgressHUD *)hudView{
    MBProgressHUD *hud=[MBProgressHUD HUDForView:self];
    if (nil==hud) {
        hud =  [[MBProgressHUD alloc]  initWithView:self];
        hud.removeFromSuperViewOnHide = YES;
        [self addSubview:hud];
    }
    return hud;
}
-(void)showHUDMessage:(NSString *)message yOffset:(CGFloat)yOffset{
    [[self hudView] setLabelText:message];
     [[self hudView] show:YES];
}
-(void)showHUDMessage:(NSString *)message{
    [self showHUDMessage:message yOffset:0];
}
-(void)showHUDLoading{
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
//    [MBProgressHUD showExcutingHUDForView:self labelText:@"请稍后..." detailLabelText:nil yOffset:0 delegate:nil];
}
-(void)showHUDLoadingWithMessage:(NSString *)message{
[SVProgressHUD showWithStatus:message maskType:SVProgressHUDMaskTypeNone];
}
-(void)dismissHUDLoading{
    [SVProgressHUD dismiss];
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
}
-(void)dismissHUDLoadingAnimated:(CGFloat)animated{
    [SVProgressHUD dismiss];
   [MBProgressHUD hideAllHUDsForView:self animated:YES];
}
@end
