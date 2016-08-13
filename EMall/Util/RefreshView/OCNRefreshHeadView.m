//
//  OCNRefreshHeadView.m
//  OpenCourse
//
//  Created by Luigi on 15/11/28.
//
//

#import "OCNRefreshHeadView.h"
#define SIZE 20.f  //circle size
#define DURATION 0.3
#define kRefreshAnimationDuration 1.5
#define fequalzero(a) (fabs(a) < FLT_EPSILON)
static const int kNumberOfCircles = 4;  //实际可以看到的个数是kNumberOfCircles - 1
@interface OCNRefreshHeadView ()
{
    UIImageView      *containerView_;
    CGFloat     offset_;
}
@property (strong, nonatomic) NSArray *circles;
@property (strong, nonatomic) CALayer *indicatorLayer;

@property (nonatomic,strong)UIActivityIndicatorView *activitIndicatorView;
@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UIImageView *animationImageView;



- (void)pullingWithSize:(CGFloat)size;
- (void)cancelPulling;
- (void)beginLoadingAnimation;
- (void)stopLoadingAnimation;
@end

@implementation OCNRefreshHeadView
- (UIImageView *)bgImageView{
    if (nil==_bgImageView) {
        _bgImageView=[[UIImageView alloc]  init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.backgroundColor=[UIColor clearColor];
    }
    return _bgImageView;
}
#pragma mark - 构造方法
+ (instancetype)headerWithCircleColor:(UIColor *)circleCorlor url:(NSString *)url refreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    OCNRefreshHeadView *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    [cmp onInitContentViewWithUrl:url circleColor:circleCorlor];
    return cmp;
}
- (void)setBackgroundImageWithUrl:(NSString *)url{
    if ((!_bgImageView.superview)||(!_bgImageView)) {
        [self addSubview:self.bgImageView];
        __weak OCNRefreshHeadView *weakSelf=self;
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(weakSelf);
            make.bottom.mas_equalTo(weakSelf.mas_top).offset(-20);
        }];
    }
    [_bgImageView setImageName:url placeholderImageName:nil original:YES animated:NO success:^(UIImage *image) {
          
    }];
}
- (void)prepare{
    [super prepare];
    // 设置控件的高度
    self.mj_h = 85;
    self.backgroundColor = [UIColor clearColor];
}
- (void)onInitContentViewWithUrl:(NSString *)url circleColor:(UIColor *)circleColor{
    containerView_ = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - SIZE, self.frame.size.height/2 - SIZE, 2*SIZE, 2*SIZE)];
    [containerView_ setBackgroundColor:[UIColor clearColor]];
    [self addSubview:containerView_];

    WEAKSELF
//    _animationImageView=[[UIImageView alloc]  initWithFrame:CGRectMake(self.frame.size.width/2 - 60, 0 , 120, 85)];
    /*
    _animationImageView=[[UIImageView alloc]  init];
    NSMutableArray *imageArray=[[NSMutableArray alloc]  init];
    for (NSInteger i=0; i<27; i++) {
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"pull_000%ld",32+i]];
        if (image) {
            [imageArray addObject:image];
        }
    }
    _animationImageView.animationImages=imageArray;
    _animationImageView.animationDuration=kRefreshAnimationDuration;
    _animationImageView.hidden=YES;
    [self addSubview:_animationImageView];
    
    [_animationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(120, 85));
    }];
    _animationImageView.backgroundColor=[UIColor clearColor];
    */
    _activitIndicatorView=[[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activitIndicatorView.hidesWhenStopped=YES;
    _activitIndicatorView.color=RGB(229, 26, 30);
    [self addSubview:_activitIndicatorView];
    [_activitIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    
    NSMutableArray *circles = [NSMutableArray arrayWithCapacity:kNumberOfCircles];
    for (int i = 0; i < kNumberOfCircles; ++i) {
        CALayer *circle = [CALayer new];
        circle.frame = CGRectMake(SIZE / 2, SIZE / 2, SIZE, SIZE);
        circle.backgroundColor = circleColor.CGColor;
        circle.cornerRadius = SIZE / 2;
        circle.opacity = 0;
        [containerView_.layer addSublayer:circle];
        [circles addObject:circle];
    }
    self.circles = [NSArray arrayWithArray:circles];
    
    _indicatorLayer = self.circles[0];
    if (url) {
        [self setBackgroundImageWithUrl:url];
    }
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    containerView_.center=self.center;
//    _animationImageView.center=self.center;
//    CGFloat bgImageHeight=self.bounds.size.width/2;
//    self.bgImageView.bounds = CGRectMake(0, -self.mj_h-bgImageHeight, self.bounds.size.width, bgImageHeight);
//    self.bgImageView.center = CGPointMake(self.mj_w * 0.5, - self.bgImageView.mj_h + 20);

}

- (void)beginRefreshing{
    [super beginRefreshing];
    [self beginLoadingAnimation];
}
#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    offset_=self.scrollView.contentOffset.y+self.scrollView.contentInset.top;
    if ((self.state == MJRefreshStateIdle || self.state == MJRefreshStateWillRefresh) && (offset_ <0) && (offset_ > -self.mj_h)) {
        [self pullingWithSize:(offset_*-1)];
    }
    [super scrollViewContentOffsetDidChange:change];
//    CGFloat offsetY = self.scrollView.mj_offsetY;
//    // 头部控件刚好出现的offsetY
//    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
//    if (offsetY > happenOffsetY) return;
//    
//    // 普通 和 即将刷新 的临界点
//    CGFloat normal2pullingOffsetY = happenOffsetY - self.mj_h;
//    if (self.state == MJRefreshStateIdle && offsetY <= normal2pullingOffsetY) {
//        // 转为即将刷新状态
//        self.state = MJRefreshStatePulling;
//    }
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
    if (self.state != MJRefreshStateIdle) return;
    
    if (_scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {// 手松开
        if(self.scrollView.contentOffset.y > - self.mj_h && self.scrollView.contentOffset.y < 0 && ![self isRefreshing])
        {
            [self cancelPulling];
        }
    }
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    switch (state) {
        case MJRefreshStateIdle:{
        }
            break;
        case MJRefreshStatePulling:

            break;
        case MJRefreshStateRefreshing:{
            [self beginLoadingAnimation];
        }
            break;
        default:
            break;
    }
    MJRefreshCheckState;
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
}
-(void)endRefreshing{
    [self stopLoadingAnimation];
    [super endRefreshing];
}


#pragma mark - private method
- (void)pullingWithSize:(CGFloat)size  //offset
{
    float finalSize = MIN(size - ((self.frame.size.height - SIZE) / 2), SIZE);
    _indicatorLayer.transform = CATransform3DMakeScale(finalSize/SIZE, finalSize/SIZE, 1);
    _indicatorLayer.opacity = 1 - 0.3 * finalSize/self.frame.size.height;  //final .7
    containerView_.layer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (void)cancelPulling
{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.001, 0.001, 1)];
    animation.duration = 0.3;
    [_indicatorLayer addAnimation:animation forKey:@"animationKey"];
    animation.delegate = self;
    
}


- (void)beginLoadingAnimation
{
    containerView_.hidden=YES;
    [self.activitIndicatorView startAnimating];
    
    /*
    self.animationImageView.hidden=!containerView_.hidden;
//    self.animationImageView.center=containerView_.center;
    [ self.animationImageView startAnimating];
    */
    
    
    /*
    containerView_.layer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _indicatorLayer.opacity = 0;
    _indicatorLayer.transform = CATransform3DIdentity;
    
    CFTimeInterval currentTime = CACurrentMediaTime();
    CFTimeInterval currentTimeInSuperLayer = [containerView_.layer convertTime:currentTime
                                                                     fromLayer:nil];
    CALayer *circle = nil;
    for (int i = 0; i < kNumberOfCircles; ++i) {
        circle = self.circles[i];
        [circle removeAllAnimations];
        CFTimeInterval currentTimeInCircle = [circle convertTime:currentTimeInSuperLayer fromLayer:containerView_.layer];
        CAAnimationGroup *animGroup = [self circleAnimationAtIndex:i fromBeginTime:currentTimeInCircle];
        animGroup.delegate = self;
        [circle addAnimation:animGroup forKey:nil];
    }
    */
}

- (CAAnimationGroup *)circleAnimationAtIndex:(NSInteger)index fromBeginTime:(NSTimeInterval)beginTime {
    float duration = kNumberOfCircles * .5;
    CAKeyframeAnimation *opacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.removedOnCompletion = NO;
    opacityAnim.fillMode = kCAFillModeForwards;
    opacityAnim.beginTime = 0;
    opacityAnim.duration = duration;
    
    CAKeyframeAnimation *scaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnim.removedOnCompletion = NO;
    scaleAnim.fillMode = kCAFillModeForwards;
    scaleAnim.beginTime = 0;
    scaleAnim.duration = duration;
    
    NSMutableArray *keyTimes = [NSMutableArray arrayWithCapacity:kNumberOfCircles + 1];
    NSMutableArray *scaleValues = [NSMutableArray arrayWithCapacity:kNumberOfCircles];
    NSMutableArray *opacityValues = [NSMutableArray arrayWithCapacity:kNumberOfCircles];
    NSMutableArray *timeFuntions = [NSMutableArray arrayWithCapacity:kNumberOfCircles];
    [keyTimes addObject:@0];
    double keyTime = 0;
    CATransform3D t = CATransform3DIdentity;
    float scale = 0;
    float opacity = 0;
    float kMaxScale = 1.5;
    for (int i = 1; i < kNumberOfCircles + 1; ++i) {
        //        if (i == 1) {
        //            opacity = 1;
        //            scale = 0;
        //            keyTime = 0;
        //        }
        //        else if (i == 2) {
        //            opacity = .66;
        //            scale = 0.5;
        //            keyTime = 0.33;
        //        }
        //        else if (i == 3) {
        //            opacity = .33;
        //            scale = 1;
        //            keyTime = 2 / 3.0;
        //        }
        //        else if (i == 4) {
        //            opacity = 0;
        //            scale = 1.5;
        //            keyTime = 1;
        //        }
        
        float multiple = (1.0 / (kNumberOfCircles - 1)) * (i - 1);
        opacity = 1 - multiple;
        scale = multiple * kMaxScale;
        keyTime = multiple;
        
        [keyTimes addObject:@(keyTime)];
        [opacityValues addObject:@(opacity)];
        t = CATransform3DScale(CATransform3DIdentity, scale, scale, 1);
        [scaleValues addObject:[NSValue valueWithCATransform3D:t]];
        [timeFuntions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    }
    
    opacityAnim.keyTimes = keyTimes;
    opacityAnim.values = opacityValues;
    opacityAnim.timingFunctions = timeFuntions;
    scaleAnim.keyTimes = keyTimes;
    scaleAnim.values = scaleValues;
    scaleAnim.timingFunctions = timeFuntions;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.duration = scaleAnim.duration;
    animGroup.beginTime = beginTime - 65536 * duration + index * (duration / kNumberOfCircles);
    animGroup.repeatCount = HUGE_VALF;
    animGroup.animations = @[opacityAnim, scaleAnim];
    animGroup.removedOnCompletion = NO;
    animGroup.fillMode = kCAFillModeForwards;
    animGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    return animGroup;
}

- (CAAnimationGroup *)circleFadeAnimation {
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = @.7;
    opacityAnim.toValue = 0;
    opacityAnim.removedOnCompletion = NO;
    opacityAnim.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1)];
    scaleAnim.removedOnCompletion = NO;
    scaleAnim.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.duration = .3;
    animGroup.animations = @[opacityAnim, scaleAnim];
    animGroup.removedOnCompletion = NO;
    animGroup.fillMode = kCAFillModeRemoved;
    animGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return animGroup;
}

- (void)stopLoadingAnimation
{
    
    containerView_.hidden=NO;
    /*
    self.animationImageView.hidden=!containerView_.hidden;
    [self.animationImageView stopAnimating];
     */
    [self.activitIndicatorView stopAnimating];
    CALayer *circle = nil;
    for (int i = 0; i < kNumberOfCircles; ++i) {
        circle = self.circles[i];
        [circle removeAllAnimations];
    }
    
    CAAnimationGroup *animGroup = [self circleFadeAnimation];
    animGroup.delegate = self;
    [_indicatorLayer addAnimation:animGroup forKey:@"fade-anim"];
    [self loadingViewHasStop];
}
- (void)loadingViewHasStop
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:.3];
//    UIEdgeInsets contentInset=scrollview_.contentInset;
//    contentInset.top=0;
//    scrollview_.contentInset =contentInset;
    [UIView commitAnimations];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim == [_indicatorLayer animationForKey:@"fade-anim"]) {
        _indicatorLayer.opacity = 0;
        _indicatorLayer.transform = CATransform3DIdentity;
    }
}

@end
