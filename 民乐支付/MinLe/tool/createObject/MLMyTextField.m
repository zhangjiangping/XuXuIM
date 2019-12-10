//
//  MLMyTextField.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/14.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLMyTextField.h"

@implementation MLMyTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(241, 241, 241);
        self.layer.cornerRadius = 10;
        
        [self addSubview:self.textField];
    }
    return self;
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
