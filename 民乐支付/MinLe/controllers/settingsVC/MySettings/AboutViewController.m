//
//  AboutViewController.m
//  民乐支付
//
//  Created by JP on 2017/4/26.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import "AboutViewController.h"
#import "BaseLayerView.h"
#import "BaseWebViewController.h"

@interface AboutViewController ()
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) BaseLayerView *layerView;
@property (nonatomic, strong) UILabel *copyrightlable;
@end

@implementation AboutViewController

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
    [self.view addSubview:self.layerView];
    [self.view addSubview:self.copyrightlable];
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 200) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Setting.About"]];
    }
    return _naView;
}

- (BaseLayerView *)layerView
{
    if (!_layerView) {
        _layerView = [[BaseLayerView alloc] initWithFrame:CGRectMake(15, 64, screenWidth-30, 200)];
        
        NSString *str = [NSString stringWithFormat:@"%@V %@（%@）", [CommenUtil LocalizedString:@"Setting.Version"],minlePay_AppVersion, minlePay_Version];
        NSArray *arry = @[[CommenUtil LocalizedString:@"Setting.UserInstructions"],str];
        CGFloat ww = screenWidth-30-30;
        CGFloat hh = 44;
        for (int i = 0; i < arry.count; i++) {
            UIButton *but = [UIButton  buttonWithType:UIButtonTypeSystem];
            but.frame = CGRectMake(15, 40+(hh+32)*i, ww, hh);
            but.backgroundColor = RGB(241, 241, 241);
            but.layer.cornerRadius = 5;
            but.tag = i+1;
            [but addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
            [_layerView addSubview:but];
            
            UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, hh)];
            nameLable.text = arry[i];
            [but addSubview:nameLable];
            
            if (i == 0) {
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(ww-24, (hh-14)/2, 14, 14)];
                img.image = [UIImage imageNamed:@"settings_03"];
                img.clipsToBounds = YES;
                [but addSubview:img];
            }
        }
    }
    return _layerView;
}

- (UILabel *)copyrightlable
{
    if (!_copyrightlable) {
        NSString *str = [CommenUtil LocalizedString:@"Setting.MinleCopyright"];
        float hh = [CommenUtil getTxtHeight:str forContentWidth:screenWidth-60 fotFontSize:14];
        _copyrightlable = [[UILabel alloc] initWithFrame:CGRectMake(30, screenHeight-hh-10, screenWidth-60, hh)];
        _copyrightlable.font = FT(14);
        _copyrightlable.text = str;
        _copyrightlable.textAlignment = NSTextAlignmentCenter;
        _copyrightlable.textColor = [UIColor lightGrayColor];
    }
    return _copyrightlable;
}

- (void)onAction:(UIButton *)sender
{
    if (sender.tag == 1) {
        BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
        webVC.titleStr = [CommenUtil LocalizedString:@"Setting.UserInstructions"];
        webVC.urlStr = [NSString stringWithFormat:@"%@1",ApiH5URL];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

@end





