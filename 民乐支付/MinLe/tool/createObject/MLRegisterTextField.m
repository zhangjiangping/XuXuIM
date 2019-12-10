//
//  MLRegisterTextField.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/2.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLRegisterTextField.h"

@implementation MLRegisterTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView
{
    self.layer.borderWidth = 1;
    self.layer.borderColor = LayerRGB(0, 134, 219);
    self.layer.cornerRadius = 5;
    [self addSubview:self.textField];
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, widths-10, heights-10)];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _textField;
}

@end
