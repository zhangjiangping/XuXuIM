//
//  InternationalWebViewController.m
//  民乐支付
//
//  Created by JP on 2017/4/11.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import "InternationalWebViewController.h"
#import "WYWebProgressLayer.h"
#import <WebKit/WebKit.h>

#define linesWidth 2
@interface InternationalWebViewController () <WKNavigationDelegate,WKUIDelegate>
{
    WYWebProgressLayer *_progressLayer; //网页加载进度条
}
@property (nonatomic, strong) WKWebView *wkWebView;
@end

@implementation InternationalWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(245, 246, 249);
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI
{
    self.title = [CommenUtil LocalizedString:@"Me.InternationalCreditCard"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.view addSubview:self.wkWebView];

}
- (WKWebView *)wkWebView
{
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _wkWebView.UIDelegate = self;
        if ([_wkWebView respondsToSelector:@selector(setNavigationDelegate:)]) {
            [_wkWebView setNavigationDelegate:self];
        }
        _wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //开始右滑返回手势
        //_wkWebView.allowsBackForwardNavigationGestures = YES;
        [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        
        NSURL *url = [NSURL URLWithString:self.urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        [_wkWebView loadRequest:request];
    }
    return _wkWebView;
}

#pragma mark - 监听进度

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self.wkWebView) {
            if (self.wkWebView.estimatedProgress >= 1.0f) {
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    _progressLayer.shadowOpacity = 0;
                } completion:^(BOOL finished) {
                    [_progressLayer finishedLoad];
                    _progressLayer = nil;
                }];
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}

#pragma mark - WKWebViewDelegate

//解决某些地址次级页面不能进入的问题(例如：http://Www.abchina.com)
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

//页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    _progressLayer = [[WYWebProgressLayer alloc] initWithLineWidth:linesWidth];
    _progressLayer.frame = CGRectMake(0, 44-linesWidth, screenWidth, linesWidth);
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
    [_progressLayer startLoad];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"当内容开始返回时调用");
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [_progressLayer finishedLoad];
    _progressLayer = nil;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    [_progressLayer finishedLoad];
    _progressLayer = nil;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    //在收到响应后，决定是否跳转
    decisionHandler(WKNavigationResponsePolicyAllow);//允许跳转
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

- (void)dealloc
{
    [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress" context:NULL];
    [_progressLayer finishedLoad];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
    NSLog(@"i am dealloc");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressLayer finishedLoad];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
