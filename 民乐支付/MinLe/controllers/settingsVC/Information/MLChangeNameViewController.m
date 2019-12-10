//
//  MLChangeNameViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/26.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLChangeNameViewController.h"
#import "MLChangeNameNavigationView.h"

@interface MLChangeNameViewController () <UITextFieldDelegate>
@property (nonatomic, strong) MLChangeNameNavigationView *naView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *lable;
@property (nonatomic, strong) UIView *fieldView;
@end

@implementation MLChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setUI
{
    self.view.backgroundColor = RGB(239, 239, 243);
    [self.view addSubview:self.naView];
    [self.naView.saveBut addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.fieldView];
}

- (MLChangeNameNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLChangeNameNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64)];
    }
    return _naView;
}

- (UIView *)fieldView
{
    if (!_fieldView) {
        _fieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 84, widthss, 45)];
        _fieldView.backgroundColor = [UIColor whiteColor];
        [_fieldView addSubview:self.textField];
    }
    return _fieldView;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, widthss-20, 45)];
        _textField.font = FT(16);
        _textField.text = self.nameBut.titleLabel.text;
        _textField.delegate = self;
        _textField.rightView = self.lable;
        _textField.rightViewMode = UITextFieldViewModeAlways;
        [_textField becomeFirstResponder];
    }
    return _textField;
}

- (UILabel *)lable
{
    if (!_lable) {
        _lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 45)];
        _lable.text = [CommenUtil LocalizedString:@"Me.Less16Text"];
        _lable.textAlignment = NSTextAlignmentCenter;
        _lable.alpha = 0.7;
        _lable.font = FT(11);
        _lable.contentMode = UIViewContentModeCenter;
    }
    return _lable;
}

#pragma mark - UITextView delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.naView.saveBut.alpha = 1;
    self.naView.saveBut.enabled = YES;//可点击
    if (textField == self.textField) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 16) {
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.MoreThen16Text"] showView:nil];
            return NO;
        }
    }
    return YES;
}

- (void)saveAction:(UIButton *)sender
{
    if (self.block) {
        if (_textField.text.length > 0) {
            self.block(_textField.text);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
