//
//  OCPageLoadAnimationView.m
//  OpenCourse
//
//  Created by Luigi on 15/8/31.
//
//

#import "OCPageLoadAnimationView.h"
NSString *const OCPageLoadViewImageKey               =@"OCPageLoadingImageKey";
NSString *const OCPageLoadingAnimationImagesKey    =@"OCPageLoadingAnimationImagesKey";
NSString *const OCPageLoadingAnimationDurationKey  =@"OCPageLoadingAnimationDurationKey";
@interface OCPageLoadAnimationView ()
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIActivityIndicatorView *activityIndicatorView;
@property(nonatomic,strong)UILabel      *textLable;
@end

@implementation OCPageLoadAnimationView
+(OCPageLoadAnimationView *)defaultPageLoadView{
    OCPageLoadAnimationView *pageView=[[OCPageLoadAnimationView alloc]  init];
    return pageView;
}
-(void)onInitUI{
    [super onInitUI];
//    _imageView=[UIImageView new];
//    [self addSubview:_imageView];
//    
    _textLable=[[UILabel alloc]  init];
    _textLable.textAlignment=NSTextAlignmentCenter;
    _textLable.font=[UIFont oc_boldSystemFontOfSize:15];
    _textLable.textColor=[UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1];
    [self addSubview:_textLable];
    
    _activityIndicatorView=[[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.hidesWhenStopped=YES;
    [self addSubview:_activityIndicatorView];
    
    __weak OCPageLoadAnimationView *weakSelf=self;
//    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(weakSelf.mas_centerY).offset(-20);
//        make.centerX.mas_equalTo(weakSelf.mas_centerX);
//    }];
    [_activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY).offset(-20);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    }];
    [_textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_activityIndicatorView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.width.mas_lessThanOrEqualTo(300);
    }];
}

-(void)showLoadingData:(NSDictionary *)dic inView:(UIView *)aView delegate:(id)delegate{
    [super showLoadingData:dic inView:aView delegate:delegate];
    if (dic) {
        if ([dic objectForKey:OCPageLoadingAnimationImagesKey]) {
            /*
            self.imageView.image=nil;
            self.imageView.animationImages=[dic objectForKey:OCPageLoadingAnimationImagesKey];
            self.imageView.animationDuration=[[dic objectForKey:OCPageLoadingAnimationDurationKey] floatValue];
            [self.imageView startAnimating];
             */
            [self.activityIndicatorView startAnimating];
        }else if ([dic objectForKey:OCPageLoadViewImageKey]){
            /*
            [self.imageView stopAnimating];
            self.imageView.animationImages=nil;
            
            self.imageView.image=[dic objectForKey:OCPageLoadViewImageKey];
             */
            [self.activityIndicatorView stopAnimating];
        }
        self.textLable.text=[dic objectForKey:OCPageLoadViewTexKey];
    }
}
-(void)dismiss{
    [self.activityIndicatorView stopAnimating];
//    [self.imageView stopAnimating];
    [super dismiss];
}
@end
