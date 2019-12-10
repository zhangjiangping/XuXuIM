//
//  MLCertificationWindowView.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/1.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLCertificationWindowView : UIView

@property (nonatomic, strong) UILabel *lable;
@property (nonatomic, strong) UIButton *certificationBut;
@property (nonatomic, strong) UIButton *cancelBut;

- (instancetype)initWithFrame:(CGRect)frame withButtonTitle:(NSString *)title;

//个人信息弹出视图更新
- (void)setAuthCerWindowViewState:(NSNumber *)statusNum;

//无卡注册弹出视图更新
- (void)setNoCardCerWindowViewState;

- (void)show;

- (void)hiden;

@end

