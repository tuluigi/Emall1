//
//  UIScrollView+OCRefresh.m
//  OpenCourse
//
//  Created by Luigi on 15/9/11.
//
//

#import "UIScrollView+OCRefresh.h"
#import "MJRefresh.h"
#import "OCNRefreshHeadView.h"
#import "OCNRefresheFootView.h"

static const void *kOpenCourseInfonitionScrollHandleBlcok = &kOpenCourseInfonitionScrollHandleBlcok;
@interface UIScrollView (OCNewRefresh)
- (void)setPullInfiniteScrollingHandler:(OpenCourseRefreshBlock)handle;
- (OpenCourseRefreshBlock)pullInfiniteScrollingHandler;
@end

@implementation UIScrollView (OCRefresh)
- (void)setPullInfiniteScrollingHandler:(OpenCourseRefreshBlock)handle{
    objc_setAssociatedObject(self, kOpenCourseInfonitionScrollHandleBlcok, handle, OBJC_ASSOCIATION_COPY);
}
- (OpenCourseRefreshBlock)pullInfiniteScrollingHandler{
    return objc_getAssociatedObject(self, kOpenCourseInfonitionScrollHandleBlcok);
}
#pragma mark -getter setter
- (void)addRefreshHeadViewWithTitle:(NSString *)title onHandler:(OpenCourseRefreshBlock)refreshBlock{
    OCNRefreshHeadView *headView=(OCNRefreshHeadView *)self.header;
    if (nil==headView) {
        UIColor *circleColor = RGB(229, 26, 30);
        CGFloat width=CGRectGetWidth(self.frame);
        if (!width) {
            width=CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds);
        }
        headView = [OCNRefreshHeadView headerWithCircleColor:circleColor title:title refreshingBlock:^{
            if (refreshBlock) {
                refreshBlock();
            }
        }];
        self.header=headView;
    }
}
/**
 *  添加下拉刷新
 *
 *  @param url    图片地址
 *  @param handle
 */
- (void)addOCPullDownResreshWithTitle:(NSString *)title onHandler:(OpenCourseRefreshBlock)handle{
    [self addRefreshHeadViewWithTitle:title onHandler:handle];
}

- (void)addOCPullDownResreshHandler:(OpenCourseRefreshBlock)handle{
       [self addRefreshHeadViewWithTitle:nil onHandler:handle];
}
- (void)setPullDownResfreshBackgroudImageUrl:(NSString *)url{
    
}
- (UIView *)refreshHeadView{
    return self.header;
}
- (void)startPullDownRefresh{
    if (self.footer.isRefreshing) {
        [self.footer endRefreshing];
    }
    [self.header beginRefreshing];
}
- (void)stopPullDownRefresh{
    [self.header endRefreshing];
    [self.footer endRefreshing];
    
}
#pragma mark - 上拉
- (void)startInfiniteScrolling{
    [self.footer beginRefreshing];
    if (self.header.isRefreshing) {
        [self.header endRefreshing];
    }
}
- (void)stopInfiniteScrolling{
     [self.header endRefreshing];
    [self.footer endRefreshing];
}
- (void)enableInfiniteScrolling:(BOOL)enable{
    if (!enable) {
        [self.footer endRefreshing];
        [self.footer endRefreshingWithNoMoreData];
    }else{
        [self.footer resetNoMoreData];
    }
}
- (void)endRefreshingWithMessage:(NSString *)msg eanbleRetry:(BOOL)enableRetry{
     [(OCNRefresheFootView *)self.footer endRefreshingWithMessage:msg eanbleRetry:enableRetry];
}

- (void)endRefreshingWithNoData {
//    self.contentSize = CGSizeMake(self.contentSize.width, self.contentSize.height + CGRectGetHeight(self.footer.frame)); //无效
    [self endRefreshingWithMessage:@"没有更多内容了" eanbleRetry:YES];
    UIEdgeInsets currentInsets = self.contentInset;
    currentInsets.bottom = - CGRectGetHeight(self.footer.frame);
    self.contentInset = currentInsets;

}
- (void)addOCPullInfiniteScrollingHandler:(OpenCourseRefreshBlock)handle{
    if (!self.footer) {
        [self setPullInfiniteScrollingHandler:handle];
        self.footer=[OCNRefresheFootView footerWithRefreshingBlock:^{
            if (handle) {
                handle();
            }
        }];
    }
}
- (UIView *)infiniteFootView{
    return self.footer;
}

/**
 *  停止下拉和上拉动画
 */
-(void)stopRefreshAndInfiniteScrolling{
    [self stopInfiniteScrolling];
    [self stopPullDownRefresh];
}

@end
