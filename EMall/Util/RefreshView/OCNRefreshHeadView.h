//
//  OCNRefreshHeadView.h
//  OpenCourse
//
//  Created by Luigi on 15/11/28.
//
//

#import <MJRefresh/MJRefresh.h>

@interface OCNRefreshHeadView : MJRefreshHeader
+ (instancetype)headerWithCircleColor:(UIColor *)circleCorlor title:(NSString *)title refreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;
- (void)setBackgroundImageWithUrl:(NSString *)url;
@end
