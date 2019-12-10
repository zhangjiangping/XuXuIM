//
//  MLWhetherBindingViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/8.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLWhetherBindingViewController.h"
#import "BaseLayerView.h"
#import "MLErWeiMaViewController.h"

@interface MLWhetherBindingViewController ()
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) BaseLayerView *layerView;
@property (nonatomic, strong) UIButton *addBut;
@property (nonatomic, strong) UILabel *messageLable;
@property (nonatomic, strong) UIImageView *erweimaImg;
@end

@implementation MLWhetherBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUI
{
    [self.view addSubview:self.naView];
    [self.view addSubview:self.layerView];
    [self.view addSubview:self.addBut];
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, heightss/2.52) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Home.QRCode"]];
    }
    return _naView;
}

- (BaseLayerView *)layerView
{
    if (!_layerView) {
        _layerView = [[BaseLayerView alloc] initWithFrame:CGRectMake(15, 64, widthss-30, 300)];
        [_layerView addSubview:self.messageLable];
        [_layerView addSubview:self.erweimaImg];
    }
    return _layerView;
}

- (UILabel *)messageLable
{
    if (!_messageLable) {
        _messageLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.layerView.frame), 30)];
        _messageLable.text = [CommenUtil LocalizedString:@"QR.Prompt"];
        _messageLable.textAlignment = NSTextAlignmentCenter;
        _messageLable.font = FT(15);
        _messageLable.alpha = 0.5;
    }
    return _messageLable;
}

- (UIImageView *)erweimaImg
{
    if (!_erweimaImg) {
        _erweimaImg = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.layerView.frame)-110)/2, CGRectGetMaxY(self.messageLable.frame)+40, 110, 110)];
        _erweimaImg.image = [UIImage imageNamed:@"unkonwn_QR"];
    }
    return _erweimaImg;
}


- (UIButton *)addBut
{
    if (!_addBut) {
        _addBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBut.frame = CGRectMake(0, screenHeight-50, screenWidth, 50);
        _addBut.backgroundColor = blueRGB;
        [_addBut addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat tempWidth = [self getWidthWithContent:[CommenUtil LocalizedString:@"QR.AddQR"] height:50 font:19];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-tempWidth-28)/2, 14.5, 21, 21)];
        img.clipsToBounds = YES;
        img.image = [UIImage imageNamed:@"add_erweima"];
        [_addBut addSubview:img];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+7, 0, tempWidth, 50)];
        lable.text = [CommenUtil LocalizedString:@"QR.AddQR"];
        lable.textColor = [UIColor whiteColor];
        lable.textAlignment = NSTextAlignmentCenter;
        [_addBut addSubview:lable];
    }
    return _addBut;
}

//根据高度度求宽度content 计算的内容  Height 计算的高度 font字体大小
- (CGFloat)getWidthWithContent:(NSString *)content height:(CGFloat)height font:(CGFloat)font{
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.width;
}


- (void)addAction
{
    MLErWeiMaViewController *erVC = [[MLErWeiMaViewController alloc] init];
    erVC.isAuthen = @"1";
    [self.navigationController pushViewController:erVC animated:YES];
}

@end








