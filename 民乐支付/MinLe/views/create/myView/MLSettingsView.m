//
//  MLSettingsView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/24.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLSettingsView.h"
#import "MLSettingsSetUpViewController.h"
#import "UIView+Responder.h"
#import "MLPayPassWordViewController.h"
#import "MLNextStepPhoneViewController.h"
#import "AboutViewController.h"
#import "MLThirdPartyViewController.h"
#import "WXApi.h"

@implementation MLSettingsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arry;
        if ([WXApi isWXAppInstalled]) {
            arry = @[[CommenUtil LocalizedString:@"Setting.SetupPayPassword"],
                     [CommenUtil LocalizedString:@"Setting.ResetLoginPassword"],
                     [CommenUtil LocalizedString:@"Setting.ChangePhoneNumber"],
                     [CommenUtil LocalizedString:@"Setting.ThirdLogin"],
                     [CommenUtil LocalizedString:@"Setting.About"]];
        } else {
            arry = @[[CommenUtil LocalizedString:@"Setting.SetupPayPassword"],
                     [CommenUtil LocalizedString:@"Setting.ResetLoginPassword"],
                     [CommenUtil LocalizedString:@"Setting.ChangePhoneNumber"],
                     [CommenUtil LocalizedString:@"Setting.About"]];
        }
        
        CGFloat ww = widths-30;
        CGFloat hh = (heights-80-(arry.count-1)*25)/arry.count;
        for (int i = 0; i < arry.count; i++) {
            UIButton *but = [UIButton  buttonWithType:UIButtonTypeSystem];
            but.frame = CGRectMake(15, 40+(hh+25)*i, ww, hh);
            but.backgroundColor = RGB(241, 241, 241);
            but.layer.cornerRadius = 5;
            but.tag = i+1;
            [but addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:but];
            
            UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, hh)];
            nameLable.text = arry[i];
            [but addSubview:nameLable];
        
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(ww-24, (hh-14)/2, 14, 14)];
            img.image = [UIImage imageNamed:@"settings_03"];
            img.clipsToBounds = YES;
            [but addSubview:img];
        }
    }
    return self;
}

- (void)pushAction:(UIButton *)sender
{
    if ([WXApi isWXAppInstalled]) {
        switch (sender.tag) {
            case 1:
                [self.viewController.navigationController pushViewController:[[MLPayPassWordViewController alloc] init] animated:YES];
                break;
            case 2:
                [self.viewController.navigationController pushViewController:[[MLSettingsSetUpViewController alloc] init] animated:YES];
                break;
            case 3:
                [self.viewController.navigationController pushViewController:[[MLNextStepPhoneViewController alloc] init] animated:YES];
                break;
            case 4:
                [self.viewController.navigationController pushViewController:[[MLThirdPartyViewController alloc] init] animated:YES];
                break;
            case 5:
                [self.viewController.navigationController pushViewController:[[AboutViewController alloc] init] animated:YES];
                break;
            default:
                break;
        }
    } else {
        switch (sender.tag) {
            case 1:
                [self.viewController.navigationController pushViewController:[[MLPayPassWordViewController alloc] init] animated:YES];
                break;
            case 2:
                [self.viewController.navigationController pushViewController:[[MLSettingsSetUpViewController alloc] init] animated:YES];
                break;
            case 3:
                [self.viewController.navigationController pushViewController:[[MLNextStepPhoneViewController alloc] init] animated:YES];
                break;
            case 4:
               [self.viewController.navigationController pushViewController:[[AboutViewController alloc] init] animated:YES];
                break;
            default:
                break;
        }
    }
}

@end






