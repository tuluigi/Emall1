//
//  OCNRefresheFootView.h
//  OpenCourse
//
//  Created by Luigi on 15/12/14.
//
//

#import <MJRefresh/MJRefresh.h>

typedef NS_ENUM(NSUInteger,OCNRefreshState) {
    OCNRefreshStateNormal        =MJRefreshStateIdle ,//没有更多数据
    OCNRefreshStatePulling       = MJRefreshStatePulling,//不可用
    OCNRefreshStateRefreshing    = MJRefreshStateRefreshing,
    OCNRefreshStateWillRefreh    = MJRefreshStateWillRefresh,
    OCNRefreshStateNoMoreData   =MJRefreshStateNoMoreData,//没有更多数据
    OCNRefreshStateRetry         =  100,//加载失败，点击重试
};

@interface OCNRefresheFootView : MJRefreshAutoFooter
@property (nonatomic,assign,readonly) OCNRefreshState ocNRefreshState;
- (void)endRefreshingWithMessage:(NSString *)message eanbleRetry:(BOOL)enableRetry;
@end
