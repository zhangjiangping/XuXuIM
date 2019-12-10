//
//  BaseWebViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/10.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "BasePostWebViewController.h"
#import "MLHomeViewController.h"
#import "MLMyViewController.h"
#import "WYWebProgressLayer.h"

#define linesWidth 5
@interface BasePostWebViewController () <UIWebViewDelegate>
{
    WYWebProgressLayer *_progressLayer; //网页加载进度条
}
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UIButton *but;
@end

@implementation BasePostWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI
{
    [self.view addSubview:self.naView];
    _progressLayer = [WYWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 64-linesWidth, screenWidth, linesWidth);
    [self.view.layer addSublayer:_progressLayer];
    
    [self.view addSubview:self.webView];
}

#pragma mark - getter

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:@""];
        _naView.but.alpha = 0;
        [_naView addSubview:self.but];
    }
    return _naView;
}

- (UIButton *)but
{
    if (!_but) {
        _but = [UIButton buttonWithType:UIButtonTypeSystem];
        _but.frame = CGRectMake(0, 0, 64, 64);
        [_but addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 12, 20)];
        img.image = [UIImage imageNamed:@"Back"];
        img.clipsToBounds = YES;
        [_but addSubview:img];
    }
    return _but;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, widthss, heightss-64)];
        _webView.delegate = self;
        NSURL *url = [NSURL URLWithString:self.urlString];
        NSString *body = [NSString stringWithFormat: @"html=%@",self.parameter];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
        [request setHTTPMethod: @"POST"];
        [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
        [_webView loadRequest: request];
    }
    return _webView;
}

#pragma mark - UIWebViewDelegate

//此方法可以获取网页上的数据
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSLog(@"request:%@",[[request URL] absoluteString]);
    }
    return YES;
}

/// 网页开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_progressLayer startLoad];
}

/// 网页完成加载
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_progressLayer finishedLoad];
    
    // 获取h5的标题
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

/// 网页加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_progressLayer finishedLoad];
}

- (void)dealloc
{
    [_progressLayer closeTimer];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
    NSLog(@"i am dealloc");
}

@end

