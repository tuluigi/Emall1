//
//  OCTopWarningView.m
//  OpenCourse
//
//  Created by 姜苏珈 on 15/12/4.
//
//

#import "OCTopWarningView.h"

static CGFloat kDefaultDissmissDelay = 2.0f;
@interface OCTopWarningView()
@property (nonatomic, strong) NSTimer *dismissTimer;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *warningLabel;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@end

@implementation OCTopWarningView
- (void)dealloc
{
    [self.dismissTimer invalidate];
    self.dismissTimer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBlurEnabled:NO];
        [self buildUI];
        [self subViewsLayout];

    }
    return self;
}

- (void)buildUI
{
    self.backgroundColor = [UIColor clearColor];

    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    backImageView.alpha = 0.7;
    [self addSubview:backImageView];
    self.backImageView = backImageView;
    
    
    UILabel *warningLabel = [UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:12] textColor:[UIColor colorWithHexString:self.textColor] textAlignment:NSTextAlignmentCenter];
    [self addSubview:warningLabel];
    self.warningLabel = warningLabel;

}

- (void)subViewsLayout
{
    WEAKSELF
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.backImageView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.warningLabel.textColor = [UIColor colorWithHexString:self.textColor];
    [self.warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];

}

- (void)setWarningText:(NSString *)warningText
{
    _warningText = warningText;
    self.warningLabel.text = warningText;
}

- (void)setTextColor:(NSString *)textColor
{
    _textColor = textColor;
    self.warningLabel.textColor = [UIColor colorWithHexString:textColor];
}

- (void)tapNow
{
    if (self.tapHandler) {
        self.tapHandler();
    }
}

- (void)dismiss
{
    CGRect selfFrame = self.frame;
    selfFrame.origin.y = CGRectGetHeight(selfFrame);
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = selfFrame;
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        self.alpha = 1;
        CGRect selfFrame = self.frame;
        CGFloat originY = self.frame.origin.y;
        selfFrame.origin.y -= CGRectGetHeight(selfFrame);
        self.frame = selfFrame;
        selfFrame.origin.y = originY;
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frame = selfFrame;
        } completion:^(BOOL finished) {
            [super willMoveToSuperview:newSuperview];
        }];
        
        [self.dismissTimer invalidate];
        self.dismissTimer = nil;
        self.dismissTimer = [NSTimer scheduledTimerWithTimeInterval:MAX(self.dismissDelay, kDefaultDissmissDelay) target:self selector:@selector(dismiss) userInfo:nil repeats:0];
    }
    else
    {
        [self.dismissTimer invalidate];
        self.dismissTimer = nil;
        [super willMoveToSuperview:newSuperview];
    }
    
}

+ (CGSize)sizeOfwarningView
{
    return CGSizeMake(OCWidth, 30);
}

@end
