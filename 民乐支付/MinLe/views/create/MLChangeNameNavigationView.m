//
//  MLChangeNameNavigationView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/26.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLChangeNameNavigationView.h"
#import "UIView+Responder.h"

@interface MLChangeNameNavigationView ()
@property (nonatomic, strong) UILabel *lable;
@property (nonatomic, strong) UIButton *cancelBut;
@end

@implementation MLChangeNameNavigationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(0, 134, 219);
        [self addSubview:self.lable];
        [self addSubview:self.cancelBut];
        [self addSubview:self.saveBut];
    }
    return self;
}

- (UILabel *)lable
{
    if (!_lable) {
        _lable = [[UILabel alloc] initWithFrame:CGRectMake(60, 14, widths-120, 50)];
        _lable.textAlignment = NSTextAlignmentCenter;
        _lable.textColor = [UIColor whiteColor];
        _lable.text = [CommenUtil LocalizedString:@"Me.UserName"];
    }
    return _lable;
}

- (UIButton *)cancelBut
{
    if (!_cancelBut) {
        _cancelBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelBut.frame = CGRectMake(10, 14, 50, 50);
        [_cancelBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBut setTitle:[CommenUtil LocalizedString:@"Common.Cancle"] forState:UIControlStateNormal];
        [_cancelBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _cancelBut.titleLabel.font = FT(17);
    }
    return _cancelBut;
}

- (UIButton *)saveBut
{
    if (!_saveBut) {
        _saveBut = [UIButton buttonWithType:UIButtonTypeSystem];
        [_saveBut setTitle:[CommenUtil LocalizedString:@"Me.Save"] forState:UIControlStateNormal];
        [_saveBut setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        _saveBut.frame = CGRectMake(widths-60, 14, 50, 50);
        _saveBut.alpha = 0.5;
        _saveBut.enabled = NO;
        _saveBut.titleLabel.font = FT(17);
    }
    return _saveBut;
}

- (void)backAction
{
    [self.viewController.navigationController popViewControllerAnimated:YES];
}

@end
