//
//  EMGoodsWebViewController.m
//  EMall
//
//  Created by Luigi on 16/8/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsWebViewController.h"

@interface EMGoodsWebViewController ()<UIWebViewDelegate,OCPageLoadViewDelegate>
@property (nonatomic,strong)NSString *url,*htmlString;
@property (nonatomic,strong)UIWebView *webView;
@end

@implementation EMGoodsWebViewController
- (instancetype)initWithUrl:(NSString *)url{
    if (self=[super init]) {
        _url=url;
    }
    return self;
}
- (instancetype)initWithHtmlString:(NSString *)htmlString{
    if (self=[super init]) {
        _htmlString=htmlString;
    }
    return self;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"商品介绍";
    [self.view addSubview:self.webView];
    _url=@"https://item.jd.com/10122988596.html";
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self loadData];
}
- (void)loadData{
    if (![NSString isNilOrEmptyForString:self.htmlString]) {
        [self.webView loadHTMLString:self.htmlString baseURL:nil];
    }else{
          [self.webView showPageLoadedMessage:@"暂无介绍" delegate:nil];
//        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    }
}
-(UIWebView *)webView{
    if (nil==_webView) {
        _webView=[[UIWebView alloc]  init];
        _webView.delegate=self;
    }
    return _webView;
}
-(void)ocPageLoadedViewOnTouced{
    [self loadData];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.webView showPageLoadingView];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.webView dismissPageLoadView];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [self.webView showPageLoadedMessage:@"加载失败,点击重试" delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
