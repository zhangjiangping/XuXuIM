//
//  MLMinLeTextField.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/12/20.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLMinLeTextField.h"

@implementation MLMinLeTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(241, 241, 241);
        self.layer.cornerRadius = 10;
        
        self.leftViewMode = UITextFieldViewModeUnlessEditing;
        self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.frame.size.height)];
        
        //自定按钮添加到键盘上
        UIView *bar;
        if (IOS_VERSION >= 11.0) {
            bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth,40)];
        } else {
            bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenWidth,40)];
        }
        bar.backgroundColor = [UIColor whiteColor];
        //分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bar.frame), OnePointHeight)];
        lineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [bar addSubview:lineView];
        
        [bar addSubview:self.tureBut];
        [bar addSubview:self.cancelBut];
        self.inputAccessoryView = bar;
    }
    return self;
}

//重写这个方法是为了使Placeholder居中，不会出现文字稍微偏上了一些
- (void)drawPlaceholderInRect:(CGRect)rect {
    if (IOS_VERSION >= 11.f) {
        [super drawPlaceholderInRect:rect];
    } else {
        [super drawPlaceholderInRect:CGRectMake(0, CGRectGetHeight(self.frame) * 0.5 - 1, 0, 0)];
    }
}

- (UIButton *)tureBut
{
    if (!_tureBut) {
        _tureBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _tureBut.frame = CGRectMake(screenWidth - 70, 5, 60, 30);
        [_tureBut setTitle:[CommenUtil LocalizedString:@"Common.Done"] forState:UIControlStateNormal];
        _tureBut.backgroundColor = RGB(195, 210, 223);
        [_tureBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _tureBut.layer.cornerRadius = 15;
        _tureBut.titleLabel.font = FT(15);
        [_tureBut addTarget:self action:@selector(print) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tureBut;
}

- (UIButton *)cancelBut
{
    if (!_cancelBut) {
        _cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBut.frame = CGRectMake(10, 5, 60, 30);
        [_cancelBut setTitle:[CommenUtil LocalizedString:@"Common.Cancle"] forState:UIControlStateNormal];
        _cancelBut.backgroundColor = RGB(195, 210, 223);
        [_cancelBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelBut.layer.cornerRadius = 15;
        _cancelBut.titleLabel.font = FT(15);
        [_cancelBut addTarget:self action:@selector(print) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBut;
}

- (void)print
{
    [self resignFirstResponder];
}

@end
