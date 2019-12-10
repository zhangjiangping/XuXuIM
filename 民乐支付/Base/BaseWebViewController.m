//
//  BaseWebViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/10.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "BaseWebViewController.h"
#import "MLHomeViewController.h"
#import "MLMyViewController.h"
#import "WYWebProgressLayer.h"

#define linesWidth 3

@interface BaseWebViewController () <UIWebViewDelegate>
{
    WYWebProgressLayer *_progressLayer; //网页加载进度条
}
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UIButton *but;
@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
}

- (void)setUI
{
    [self.view addSubview:self.naView];
    [self.view addSubview:self.webView];
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:self.titleStr];
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
    if ([self.isRoot isEqualToString:@"1"]) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[MLHomeViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    } else if ([self.isRoot isEqualToString:@"2"]) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[MLMyViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, widthss, heightss-64)];
        _webView.delegate = self;
        if (self.isHtml) {
            [_webView loadHTMLString:self.htmlDataString baseURL:nil];
        } else {
            NSURL *url = [NSURL URLWithString:self.urlStr];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [_webView loadRequest:request];
        }
    }
    return _webView;
}

#pragma mark - UIWebViewDelegate
/// 网页开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _progressLayer = [[WYWebProgressLayer alloc] initWithLineWidth:linesWidth];
    _progressLayer.frame = CGRectMake(0, 64-linesWidth, screenWidth, linesWidth);
    [self.view.layer addSublayer:_progressLayer];
    [_progressLayer startLoad];
}

// 网页完成加载
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_progressLayer finishedLoad];
    _progressLayer = nil;
    
    // 获取h5的标题
    if (self.titleStr) {
        self.title = self.titleStr;
    } else {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

/// 网页加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_progressLayer finishedLoad];
    _progressLayer = nil;
}

- (void)dealloc
{
    [_progressLayer closeTimer];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
    NSLog(@"i am dealloc");
}

@end

