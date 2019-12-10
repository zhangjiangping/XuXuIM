//
//  MLErWeiMaSuccessViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/9.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLErWeiMaSuccessViewController.h"
#import "BaseLayerView.h"
#import "UIImageView+MyImageView.h"
#import "XLable.h"
#import "MLErWeiMaViewController.h"

@interface MLErWeiMaSuccessViewController ()
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *addBut;
@end

@implementation MLErWeiMaSuccessViewController

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
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.addBut];
}

- (void)addAction
{
    MLErWeiMaViewController *goVC = [[MLErWeiMaViewController alloc] init];
    goVC.isAuthen = @"1";
    [self.navigationController pushViewController:goVC animated:YES];
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"QR.Me"]];
    }
    return _naView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64-50)];
        _scrollView.contentSize = CGSizeMake(0, self.dataArray.count*340);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        for (int i = 0; i < self.dataArray.count; i++) {
            NSDictionary *dic = self.dataArray[i];
            UIImageView *erweimaImg = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.scrollView.frame)-259)/2, 20+i*330, 259, 259)];
            NSString *imgStr = [NSString stringWithFormat:@"%@%@",MLMLJK,dic[@"qrurl"]];
            [erweimaImg setImageWithString:imgStr withDefalutImage:[UIImage imageNamed:@"unkonwn_QR@2x.png"]];
            erweimaImg.clipsToBounds = YES;
            
            XLable *sequenceLable = [[XLable alloc] initWithFrame:CGRectMake(CGRectGetMinX(erweimaImg.frame), CGRectGetMaxY(erweimaImg.frame)+10, CGRectGetWidth(erweimaImg.frame), 30)];
            sequenceLable.textAlignment = NSTextAlignmentCenter;
            sequenceLable.alpha = 0.7;
            sequenceLable.font = FT(15);
            sequenceLable.adjustsFontSizeToFitWidth = YES;
            sequenceLable.contentMode = UIViewContentModeScaleAspectFill;
            sequenceLable.text = [NSString stringWithFormat:@"%@  %@",[CommenUtil LocalizedString:@"QR.SerialNumber"],dic[@"xcode"]];
            
            UIView *xianView = [[UIView alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(sequenceLable.frame), screenWidth-100, 0.5)];
            xianView.alpha = 0.5;
            xianView.backgroundColor = [UIColor lightGrayColor];
            
            [_scrollView addSubview:erweimaImg];
            [_scrollView addSubview:sequenceLable];
            [_scrollView addSubview:xianView];
        }
    }
    return _scrollView;
}

- (UIButton *)addBut
{
    if (!_addBut) {
        _addBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBut.frame = CGRectMake(0, screenHeight-50, screenWidth, 50);
        _addBut.backgroundColor = blueRGB;
        [_addBut addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *qrStr = [CommenUtil LocalizedString:@"QR.AddQR"];
        CGFloat tempWidth = [self getWidthWithContent:qrStr height:50 font:19];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-tempWidth-28)/2, 14.5, 21, 21)];
        img.clipsToBounds = YES;
        img.image = [UIImage imageNamed:@"add_erweima"];
        [_addBut addSubview:img];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+7, 0, tempWidth, 50)];
        lable.text = qrStr;
        lable.textColor = [UIColor whiteColor];
        lable.textAlignment = NSTextAlignmentCenter;
        [_addBut addSubview:lable];
    }
    return _addBut;
}

//根据高度度求宽度  content 计算的内容  Height 计算的高度 font字体大小
- (CGFloat)getWidthWithContent:(NSString *)content height:(CGFloat)height font:(CGFloat)font{
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.width;
}

@end
