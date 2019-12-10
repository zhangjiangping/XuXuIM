//
//  MLHomeLeftView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/28.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLHomeLeftView.h"
#import "MLAccountInformationViewController.h"
#import "MLMationAuthenticationViewController.h"
#import "MLMyAssetsViewController.h"
#import "MLMyAgentViewController.h"
#import "MLSettingsViewController.h"
#import "UIView+Responder.h"
#import "MLErWeiMaViewController.h"

@interface MLHomeLeftView ()
@property (nonatomic, strong) UIImageView *img;
@end

@implementation MLHomeLeftView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.shadowOffset = CGSizeMake(0, 1); //设置阴影的偏移量
        self.layer.shadowRadius = 1.0;  //设置阴影的半径
        self.layer.shadowColor = [UIColor blackColor].CGColor; //设置阴影的颜色为黑色
        self.layer.shadowOpacity = 0.2; //设置阴影的不透明度
        [self addSubview:self.img];
    }
    return self;
}

- (UIImageView *)img
{
    if (!_img) {
        _img = [[UIImageView alloc] initWithFrame:self.bounds];
        _img.image = [UIImage imageNamed:@"gerenzhongxin_03"];
        _img.userInteractionEnabled = YES;
        CGFloat hh = (heights-20)/6;
        NSArray *arry = @[[CommenUtil LocalizedString:@"Home.MyAssets"],
                          [CommenUtil LocalizedString:@"Home.AccountDetails"],
                          [CommenUtil LocalizedString:@"Home.InformationAuthentication"],
                          [CommenUtil LocalizedString:@"Home.MyAgent"],
                          [CommenUtil LocalizedString:@"Home.Flicking"],
                          [CommenUtil LocalizedString:@"Common.Setup"]];
        //NSArray *imgArray = @[@"gerenzhongxin_06@2x.png",@"gerenzhongxin@2x_09.png",@"gerenzhongxin_12@2x.png",@"gerenzhongxin_15@2x.png",@"gerenzhongxin@2x_17.png",@"gerenzhongxin@2x_19.png"];
        NSArray *imgArray = @[@"Money",@"Accounts",@"Certification",@"MyProfile",@"QRScan",@"Settings"];
        for (int i = 0; i < 6; i++) {
            UIButton *but = [UIButton buttonWithType:UIButtonTypeSystem];
            but.frame = CGRectMake(0, 10+hh*i, widths, hh);
            but.tag = i+1;
            [but addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
            [_img addSubview:but];
            
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(widths/3+15, 0, widths/3*2-15, hh)];
            lable.text = arry[i];
            lable.textAlignment = NSTextAlignmentLeft;
            lable.alpha = 0.6;
            lable.font = FT(15);
            [but addSubview:lable];
            
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((widths/3-25)/2, (hh-25)/2, 25, 25)];
            imageV.image = [UIImage imageNamed:imgArray[i]];
            imageV.clipsToBounds = YES;
            [but addSubview:imageV];
        }
    }
    return _img;
}

- (void)pushAction:(UIButton *)sender
{
    self.alpha = 0;
    switch (sender.tag) {
        case 1:
            [self.viewController.navigationController pushViewController:[[MLMyAssetsViewController alloc] init] animated:YES];
            break;
        case 2:
            [self.viewController.navigationController pushViewController:[[MLAccountInformationViewController alloc] init] animated:YES];
            break;
        case 3:
            [self.viewController.navigationController pushViewController:[[MLMationAuthenticationViewController alloc] init] animated:YES];
            break;
        case 4:
            [self.viewController.navigationController pushViewController:[[MLMyAgentViewController alloc] init] animated:YES];
            break;
        case 5:
            [self.viewController.navigationController pushViewController:[[MLErWeiMaViewController alloc] init] animated:YES];
            break;
        case 6:
            [self.viewController.navigationController pushViewController:[[MLSettingsViewController alloc] init] animated:YES];
            break;
        default:
            break;
    }
}

@end
