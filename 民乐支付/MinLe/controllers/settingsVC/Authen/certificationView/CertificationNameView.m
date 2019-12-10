//
//  CertificationNameView.m
//  民乐支付
//
//  Created by JP on 2017/7/24.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//  

#import "CertificationNameView.h"
#import "AVCaptureViewController.h"
#import "XLBankScanViewController.h"

@interface CertificationNameView ()
{
    float defaultHeight;
    float defaultWidth;
    float historyHeight;
}
@property (nonatomic, strong) UILabel *tureMessageLable;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation CertificationNameView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        historyHeight = heights;
        NSString *str = [CommenUtil LocalizedString:@"Authen.TureIDInfo"];
        defaultHeight = [CommenUtil getTxtHeight:str forContentWidth:widths-30 fotFontSize:12];
        defaultWidth = [CommenUtil getWidthWithContent:str height:defaultHeight font:12];
        [self addSubview:self.fView];
        [self addSubview:self.zView];
        [self addSubview:self.tureMessageLable];
        [self addSubview:self.lineView];
        [self addSubview:self.nameTextField];
        [self addSubview:self.nameNumberTextField];
    }
    return self;
}

#pragma mark - action

- (void)addAction:(UIButton *)sender
{
    [self.viewController.view endEditing:YES];
    //self.size = CGSizeMake(widths, historyHeight);
    if (sender.tag == 1) {
        AVCaptureViewController *AVCaptureVC = [[AVCaptureViewController alloc] init];
        AVCaptureVC.type = IDCardTypePositive;
        AVCaptureVC.block = ^(IDInfo *info) {
            _fView.state = TakingPicturesStateEnded;
            self.fView.leftImg.image = info.subImage;
            self.tureMessageLable.hidden = NO;
            self.lineView.hidden = NO;
            self.nameTextField.hidden = NO;
            self.nameNumberTextField.hidden = NO;
            self.nameTextField.text = info.name;
            self.nameNumberTextField.text = info.num;
            self.size = CGSizeMake(widths, historyHeight+160+defaultHeight);
            if (self.nameDelegate && [self.nameDelegate respondsToSelector:@selector(selectedEnder)]) {
                [self.nameDelegate selectedEnder];
            }
        };
        [self.viewController.navigationController pushViewController:AVCaptureVC animated:YES];
    } else if (sender.tag == 2) {
        XLBankScanViewController *bankVc = [[XLBankScanViewController alloc] init];
        bankVc.type = IDCardTypeReverse;
        bankVc.block = ^(IDInfo *info) {
            _zView.state = TakingPicturesStateEnded;
            self.zView.leftImg.image = info.subImage;
            self.tureMessageLable.hidden = NO;
            self.lineView.hidden = NO;
            self.nameTextField.hidden = NO;
            self.nameNumberTextField.hidden = NO;
            self.size = CGSizeMake(widths, historyHeight+160+defaultHeight);
            if (self.nameDelegate && [self.nameDelegate respondsToSelector:@selector(selectedEnder)]) {
                [self.nameDelegate selectedEnder];
            }
        };
        [self.viewController.navigationController pushViewController:bankVc animated:YES];
    }
}

#pragma mark - UI

- (CertificationView *)fView
{
    if (!_fView) {
        _fView = [[CertificationView alloc] initWithFrame:CGRectMake(15, 22.5, widths-30, 131) withLeftImgName:@"name-card-pos" withAddName:[CommenUtil LocalizedString:@"Authen.TapIDFace"]];
        _fView.state = TakingPicturesStateDefault;
        _fView.rightBut.tag = 1;
        [_fView.rightBut addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fView;
}

- (CertificationView *)zView
{
    if (!_zView) {
        _zView = [[CertificationView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.fView.frame)+22.5, widths-30, 131) withLeftImgName:@"name-card-back" withAddName:[CommenUtil LocalizedString:@"Authen.TapIDEmblem"]];
        _zView.state = TakingPicturesStateDefault;
        _zView.rightBut.tag = 2;
        [_zView.rightBut addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zView;
}

- (UILabel *)tureMessageLable
{
    if (!_tureMessageLable) {
        _tureMessageLable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.zView.frame)+22.5, defaultWidth, defaultHeight)];
        _tureMessageLable.text = [CommenUtil LocalizedString:@"Authen.TureIDInfo"];
        _tureMessageLable.font = FT(12);
        _tureMessageLable.hidden = YES;
    }
    return _tureMessageLable;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tureMessageLable.frame)+5, CGRectGetMinY(self.tureMessageLable.frame)+(defaultHeight-0.5)/2, widths-(CGRectGetMaxX(self.tureMessageLable.frame)+5), 0.5)];
        _lineView.backgroundColor = RGB(85, 85, 85);
        _lineView.alpha = 0.25;
        _lineView.hidden = YES;
    }
    return _lineView;
}

- (MLMinLeTextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.tureMessageLable.frame)+20, widths-40, 50)];
        _nameTextField.hidden = YES;
    }
    return _nameTextField;
}

- (MLMinLeTextField *)nameNumberTextField
{
    if (!_nameNumberTextField) {
        _nameNumberTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.nameTextField.frame)+15, widths-40, 50)];
        _nameNumberTextField.hidden = YES;
    }
    return _nameNumberTextField;
}

@end
