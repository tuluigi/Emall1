//
//  EMWebViewController.m
//  EMall
//
//  Created by Luigi on 16/8/15.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMWebViewController.h"

@interface EMWebViewController ()
<UIWebViewDelegate,OCPageLoadViewDelegate>
@property (nonatomic,strong)NSString *url,*htmlString;
@property (nonatomic,strong)UIWebView *webView;

@end

@implementation EMWebViewController
- (instancetype)initWithUrl:(NSString *)url title:(NSString *)title{
    if (self=[super init]) {
        _url=url;
        self.navigationItem.title=title;
    }
    return self;
}
- (instancetype)initWithHtmlString:(NSString *)htmlString title:(NSString *)title{
    if (self=[super init]) {
        _htmlString=htmlString;
        self.navigationItem.title=title;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self loadData];
}
- (void)loadData{
    if (![NSString isNilOrEmptyForString:self.htmlString]) {
        [self.webView loadHTMLString:self.htmlString baseURL:nil];
    }else{
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
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
    if (nil==self.navigationItem.title) {
        self.navigationItem.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [self.webView showPageLoadedMessage:@"加载失败,点击重试" delegate:self];
    if (nil==self.navigationItem.title) {
        self.navigationItem.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

@end
