//
//  MLMyButton.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/27.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLMyButton.h"

@interface MLMyButton ()
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UILabel *lable;
@end

@implementation MLMyButton

- (instancetype)initWithFrame:(CGRect)frame withText:(NSString *)text withImgStr:(NSString *)imgStr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.img.image = [UIImage imageNamed:imgStr];
        [self addSubview:self.img];
        self.lable.text = text;
        [self addSubview:self.lable];
    }
    return self;
}

- (UIImageView *)img
{
    if (!_img) {
        _img = [[UIImageView alloc] initWithFrame:CGRectMake((widths-35)/2, (heights-75)/2, 35, 35)];
        _img.clipsToBounds = YES;
    }
    return _img;
}

- (UILabel *)lable
{
    if (!_lable) {
        _lable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.img.frame)+20, widths, 20)];
        _lable.alpha = 0.7;
        _lable.textAlignment = NSTextAlignmentCenter;
    }
    return _lable;
}

@end
