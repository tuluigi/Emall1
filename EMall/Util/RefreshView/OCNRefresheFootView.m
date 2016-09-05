//
//  OCNRefresheFootView.m
//  OpenCourse
//
//  Created by Luigi on 15/12/14.
//
//

#import "OCNRefresheFootView.h"
#define kLoadMoreAnimationDuration 1.4
#define kLoadMoreRefreshFootViewHeight  48
@interface OCNRefresheFootView ()
@property (nonatomic, assign) BOOL enableLoadingMoreData;//是否不能加载更多
@property (nonatomic, strong) UIImageView *animationImageView;
@property (nonatomic,strong)UIActivityIndicatorView *activitIndicatorView;
@property (nonatomic, strong) UILabel     *titleLable;
@property (nonatomic, strong) UITapGestureRecognizer *retryGesture;
@property (nonatomic,assign,readwrite) OCNRefreshState ocNRefreshState;


@end

@implementation OCNRefresheFootView

+ (instancetype)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    
    OCNRefresheFootView *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    cmp.backgroundColor = [UIColor clearColor];
//    cmp.backgroundColor=[UIColor colorWithHexString:@"#f0eff5"];
    return cmp;
}

- (void)prepare
{
    self.enableLoadingMoreData=YES;
    [super prepare];
    self.mj_h = kLoadMoreRefreshFootViewHeight;
    /*
    _animationImageView=[[UIImageView alloc]  init];
    [self addSubview:_animationImageView];
    NSMutableArray *imageArray=[[NSMutableArray alloc]  init];
    for (NSInteger i=0; i<15; i++) {
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"loading4_000%ld",31+i]];
        if (image) {
            [imageArray addObject:image];
        }
    }
    for (NSInteger i=0; i<15; i++) {
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"loading4_000%ld",45-i]];
        if (image) {
            [imageArray addObject:image];
        }
    }
    _animationImageView.animationImages=imageArray;
    _animationImageView.animationDuration=kLoadMoreAnimationDuration;
    */
    
    
    _titleLable=[[UILabel alloc]  init];
    _titleLable.textAlignment=NSTextAlignmentCenter;
    _titleLable.font=[UIFont oc_systemFontOfSize:11];
    _titleLable.textColor=[UIColor colorWithHexString:@"444444"];
    [self addSubview:_titleLable];
    
    WEAKSELF
    /*
    [_animationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.top.mas_equalTo(weakSelf.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    */
    _activitIndicatorView=[[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activitIndicatorView.hidesWhenStopped=YES;
    [self addSubview:_activitIndicatorView];
    
    [_activitIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
      make.top.mas_equalTo(weakSelf.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];

    
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.activitIndicatorView.mas_bottom);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-5);
    }];
}
- (void)placeSubviews{
    [super placeSubviews];
  
}
- (void)endRefreshing{
    if (self.isRefreshing) {
        return;
    }
    [super endRefreshing];
//    [self.animationImageView stopAnimating];
//    self.animationImageView.hidden=YES;
    [self.activitIndicatorView stopAnimating];
    self.titleLable.hidden=YES;
}
- (void)beginRefreshing{
//    self.animationImageView.hidden=NO;
    if (!self.enableLoadingMoreData) {
        return;
    }
    self.titleLable.hidden=NO;
    if (self.isRefreshing) {
        return;
    }
    [super beginRefreshing];
//    [self.animationImageView startAnimating];
    [self.activitIndicatorView startAnimating];
}


#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    if (self.enableLoadingMoreData) {
        MJRefreshCheckState;
     self.titleLable.text=@"正在加载...";
 
    switch (state) {
        case MJRefreshStateIdle:{
            self.ocNRefreshState=OCNRefreshStateNormal;
            [self.activitIndicatorView stopAnimating];
//            if ([self.animationImageView isAnimating]) {
//                [self.animationImageView stopAnimating];
//                if ([self.animationImageView.animationImages count]) {
//                    self.animationImageView.image=[self.animationImageView.animationImages firstObject];
//                }
//            }
        }
            break;
        case MJRefreshStatePulling:
             self.ocNRefreshState=OCNRefreshStatePulling;
            if (!self.mj_h) {
                self.mj_h=kLoadMoreRefreshFootViewHeight;
            }
            [self.activitIndicatorView stopAnimating];
//            if ([self.animationImageView isAnimating]) {
//                [self.animationImageView stopAnimating];
//            }
            break;
        case MJRefreshStateRefreshing:{
            self.ocNRefreshState=OCNRefreshStateRefreshing;
            self.titleLable.text=@"正在加载...";
            [self.activitIndicatorView startAnimating];
//            if (![self.animationImageView isAnimating]) {
//                [self.animationImageView startAnimating];
//            }
        }
              break;
        case MJRefreshStateWillRefresh:{
            self.ocNRefreshState=OCNRefreshStateWillRefreh;
        }break;
        case MJRefreshStateNoMoreData:{
            self.ocNRefreshState=OCNRefreshStateNoMoreData;
        }break;
        default:{
        }
            break;
    }
}

}
- (void)executeRefreshingCallback{
    if (self.enableLoadingMoreData) {//支持加载更多则接收回调
               [super executeRefreshingCallback];
    }else{//否则不接受回调
        
    }
}
- (void)setEnableLoadingMoreData:(BOOL)enableLoadingMoreData{
    if (self.ocNRefreshState!=OCNRefreshStateRetry) {
    if (_enableLoadingMoreData!=enableLoadingMoreData) {
        _enableLoadingMoreData=enableLoadingMoreData;
        if (!_enableLoadingMoreData) {
            [self.activitIndicatorView stopAnimating];;
            self.animationImageView.hidden=YES;
            self.titleLable.hidden=YES;
            self.hidden=YES;
            WEAKSELF
//            [_animationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.removeExisting=YES;
//                make.centerX.mas_equalTo(weakSelf.mas_centerX);
//                make.top.mas_equalTo(weakSelf.mas_top).offset(0);
//                make.size.mas_equalTo(CGSizeMake(70, 0));
//            }];
            [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.removeExisting=YES;
                make.top.mas_equalTo(weakSelf.activitIndicatorView.mas_bottom);
                make.centerX.mas_equalTo(weakSelf.mas_centerX);
                make.height.mas_equalTo(0);
            }];
        }else{
//            self.animationImageView.hidden=NO;
            [self.activitIndicatorView stopAnimating];
            self.titleLable.hidden=NO;
            self.hidden=NO;
            self.titleLable.text=@"";
             _titleLable.font=[UIFont oc_systemFontOfSize:11];
            WEAKSELF
//            [_animationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.removeExisting=YES;
//                make.centerX.mas_equalTo(weakSelf.mas_centerX);
//                make.top.mas_equalTo(weakSelf.mas_top).offset(0);
//                make.size.mas_equalTo(CGSizeMake(70, 30));
//            }];
            [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.removeExisting=YES;
                make.top.mas_equalTo(weakSelf.activitIndicatorView.mas_bottom);
                make.centerX.mas_equalTo(weakSelf.mas_centerX);
                make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-5);
            }];
            
        }
    }
    }
}
- (void)endRefreshingWithNoMoreData{
    [super endRefreshingWithNoMoreData];
    self.enableLoadingMoreData=NO;
}
- (void)resetNoMoreData{
    self.enableLoadingMoreData=YES;
    [super resetNoMoreData];
}
-(void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
}

- (void)endRefreshingWithMessage:(NSString *)message eanbleRetry:(BOOL)enableRetry{
    self.enableLoadingMoreData=NO;
    self.state=OCNRefreshStateRetry;
    if (!message) {
        message=@"加载失败，请点击重试";
    }
    NSString *restryMessage=message;
    self.hidden=NO;
    
    [self.activitIndicatorView stopAnimating];
    self.activitIndicatorView.hidden=YES;
    self.titleLable.hidden=NO;
//    WEAKSELF
//    [_animationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.removeExisting=YES;
//        make.centerX.mas_equalTo(weakSelf.mas_centerX);
//        make.top.mas_equalTo(weakSelf.mas_top).offset(0);
//        make.size.mas_equalTo(CGSizeMake(70, 0));
//    }];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting=YES;
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    _titleLable.font=[UIFont oc_systemFontOfSize:14];
    _titleLable.text=restryMessage;
    if (enableRetry) {
       [self addGestureRecognizer:self.retryGesture];
    }
}

- (UITapGestureRecognizer *)retryGesture{
    if (nil==_retryGesture) {
        _retryGesture=[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(handleRetryGeture:)];
    }
    return _retryGesture;
}
- (void)handleRetryGeture:(UITapGestureRecognizer *)tap{
    self.enableLoadingMoreData=YES;
    [self beginRefreshing];
    self.state=MJRefreshStateRefreshing;
    for (UITapGestureRecognizer *gesure in self.gestureRecognizers) {
        if (gesure==self.retryGesture) {
            [self removeGestureRecognizer:self.retryGesture];
            self.enableLoadingMoreData=YES;
            break;
        }
    }
    [self executeRefreshingCallback];
}
@end
