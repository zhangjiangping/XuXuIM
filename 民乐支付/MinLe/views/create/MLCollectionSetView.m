//
//  MLCollectionSetView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/1.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLCollectionSetView.h"

@interface MLCollectionSetView () <UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *fuhaoLable;
@property (nonatomic, strong) UIView *xianView;
@property (nonatomic, strong) UILabel *beizhuLable;
@property (nonatomic, strong) UITextView *placeholderLabel;
@end

@implementation MLCollectionSetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.nameLable];
        [self addSubview:self.fuhaoLable];
        [self addSubview:self.customTextField];
        [self addSubview:self.xianView];
        [self addSubview:self.beizhuLable];
        [self addSubview:self.myTextView];
    }
    return self;
}

- (UILabel *)nameLable
{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, widths-30, 30)];
        _nameLable.text = [CommenUtil LocalizedString:@"Collection.MoneyYuan"];
        _nameLable.font = FT(18);
    }
    return _nameLable;
}

- (UILabel *)fuhaoLable
{
    if (!_fuhaoLable) {
        _fuhaoLable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.nameLable.frame)+10, 40, 100)];
        _fuhaoLable.text = @"￥";
        _fuhaoLable.font = FT(40);
    }
    return _fuhaoLable;
}

- (MLCustomTextField *)customTextField
{
    if (!_customTextField) {
        _customTextField = [[MLCustomTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.fuhaoLable.frame), CGRectGetMaxY(self.nameLable.frame)+10, widths-CGRectGetMaxX(self.fuhaoLable.frame)-20, 100) withPlaceholder:[CommenUtil LocalizedString:@"Collection.EnterMoney"]];
        _customTextField.delegate = self;
    }
    return _customTextField;
}

- (UIView *)xianView
{
    if (!_xianView) {
        _xianView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.customTextField.frame)+10, widths-30, 0.5)];
        _xianView.backgroundColor = [UIColor lightGrayColor];
        _xianView.alpha = 0.5;
    }
    return _xianView;
}

- (UILabel *)beizhuLable
{
    if (!_beizhuLable) {
        _beizhuLable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.xianView.frame)+10, 80, 30)];
        _beizhuLable.text = [CommenUtil LocalizedString:@"Collection.Descr"];
        _beizhuLable.font = FT(15);
        _beizhuLable.alpha = 0.5;
    }
    return _beizhuLable;
}

- (UITextView *)myTextView
{
    if (!_myTextView) {
        _myTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.beizhuLable.frame), widths-30, heights-CGRectGetMaxY(self.beizhuLable.frame)-10)];
        _myTextView.font = [UIFont fontWithName:@"Arial" size:18.0];
        _myTextView.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
        _myTextView.delegate = self;
        _myTextView.backgroundColor = RGB(241, 241, 241);
        _myTextView.layer.cornerRadius = 5;
        
        //textview 改变字体的行间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8;// 字体的行间距
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle};
        _myTextView.attributedText = [[NSAttributedString alloc] initWithString:_myTextView.text attributes:attributes];
        
        [_myTextView addSubview:self.placeholderLabel];
    }
    return _myTextView;
}

#pragma mark - UITextField  代理

//点击return隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.customTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.customTextField) {
        NSString *text = self.customTextField.text;
        NSString *newText = [NSString stringWithFormat:@"%@%@",text,string];
        if (newText.length > 10) {
            return NO;
        }
        if ([string containsString:@"."]) {
            if ([text containsString:@"."]) {
                //有了一个点的时候不写入
                return NO;
            } else {
                if (text.length == 0 && [string isEqualToString:@"."]) {
                    //输入的第一个字符就为点的时候不写入
                    return NO;
                } else {
                    //判断不是浮点型不写入
                    if (![string isEqualToString:@"."] &&
                        ![CommenUtil isPureFloat:string]) {
                        return NO;
                    }
                }
            }
        } else if ([string isEqualToString:@""]) {
            NSLog(@"删除空格");
        } else {
            //判断整型或者浮点型
            if (![CommenUtil isPureInt:string] ||
                ![CommenUtil isPureFloat:string])
            {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - UITextView  代理

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.markedTextRange == nil && textView.text.length > 50) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Collection.EnterLength"] showView:nil];
        _myTextView.text = [_myTextView.text substringToIndex:60];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""]){
        _placeholderLabel.hidden = YES;
    }
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1){
        _placeholderLabel.hidden = NO;
    }
    if (textView == self.myTextView) {
        NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
        NSInteger res = 50 - [new length];
        if (res >= 0) {
            return YES;
        } else {
            NSRange rg = {0,[text length]+res};
            if (rg.length > 0) {
                NSString *s = [text substringWithRange:rg];
                [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            }
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Collection.EnterLength"] showView:nil];
            return NO;  
        }
    }
    return YES;
}

//设置textView的placeholder
- (UITextView *)placeholderLabel
{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UITextView alloc] initWithFrame:CGRectMake(6, 3, 90, 25)];
        _placeholderLabel.text = [CommenUtil LocalizedString:@"Collection.MoreThan50"];
        _placeholderLabel.delegate = self;
        _placeholderLabel.backgroundColor = RGB(241, 241, 241);
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.alpha = 0.7;
        [_placeholderLabel setEditable:NO];
    }
    return _placeholderLabel;
}

@end







