//
//  UIViewController+OCTopBarMessage.m
//  OpenCourse
//
//  Created by 姜苏珈 on 15/12/4.
//
//

#import "UIViewController+OCTopBarMessage.h"
#import <objc/runtime.h>
#import "OCTopWarningView.h"
@implementation UIViewController (OCTopBarMessage)
static char TopWarningKey;

- (void)showTopMessage:(NSString *)message dismissDelay:(CGFloat)delay withTapBlock:(dispatch_block_t)tapHandler
{
    [self showMessage:message color:@"#eeeeee" dismissDelay:delay withTapBlock:tapHandler];
}

- (void)showRefreshMessage:(NSString *)message dismissDelay:(CGFloat)delay withTapBlock:(dispatch_block_t)tapHandler
{
    [self showMessage:message color:@"#ffffff" dismissDelay:delay withTapBlock:tapHandler];
}

- (void)showTopMessage:(NSString *)message dismissDelay:(CGFloat)delay startOffset:(NSInteger)startOffset upView:(UIView *)upView withTapBlock:(dispatch_block_t)tapHandler
{
    [self showMessage:message color:@"#eeeeee" dismissDelay:delay startOffset:startOffset withTapBlock:nil];
    [self.view bringSubviewToFront:upView];

}

- (void)showTopMessage:(NSString *)message dismissDelay:(CGFloat)delay startOffset:(NSInteger)startOffset withTapBlock:(dispatch_block_t)tapHandler
{
    [self showMessage:message color:@"#eeeeee" dismissDelay:delay startOffset:startOffset withTapBlock:tapHandler];
}

- (void)showMessage:(NSString *)message color:(NSString *)color  dismissDelay:(CGFloat)delay withTapBlock:(dispatch_block_t)tapHandler
{
    [self showMessage:message color:color dismissDelay:delay startOffset:0 withTapBlock:tapHandler];
}

- (void)showMessage:(NSString *)message color:(NSString *)color  dismissDelay:(CGFloat)delay startOffset:(NSInteger)startOffset withTapBlock:(dispatch_block_t)tapHandler

{
    OCTopWarningView *topV = objc_getAssociatedObject(self, &TopWarningKey);
    CGFloat topBarHeight = [OCTopWarningView sizeOfwarningView].height;
    if (!topV) {
        topV = [[OCTopWarningView alloc] initWithFrame:CGRectMake(0, startOffset, OCWidth, topBarHeight)];
        objc_setAssociatedObject(self, &TopWarningKey, topV, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    CGFloat startY = 20.0;//状态栏的高度
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        switch (self.edgesForExtendedLayout) {
            case UIRectEdgeTop:
            case UIRectEdgeAll:
                if (self.navigationController.navigationBar.translucent) {
                    startY = 64.0 + startOffset;
                }
                break;
            case UIRectEdgeBottom:
            case UIRectEdgeLeft:
            case UIRectEdgeNone:
            case UIRectEdgeRight:
                startY = 20.0 + startOffset;
                break;
            default:
                break;
        }
    }
    topV.frame = CGRectMake(0, startY, OCWidth, topBarHeight);
    topV.warningText = message;
    topV.tapHandler = tapHandler;
    topV.dismissDelay = delay;
    topV.textColor = color;
    [self.view addSubview:topV];

}

@end
