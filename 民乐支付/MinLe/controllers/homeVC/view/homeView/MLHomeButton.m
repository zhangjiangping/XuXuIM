//
//  MLHomeButton.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/19.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLHomeButton.h"

@interface MLHomeButton ()
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UILabel *lable;
@end

@implementation MLHomeButton

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
        _img = [[UIImageView alloc] init];
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            _img.frame = CGRectMake((widths-30)/2, 15, 30, 25);
        } else {
            if ((screenHeight > 568.0f)) {
                _img.frame = CGRectMake((widths-50)/2, heights*0.25, 50, 43);
            } else {
                _img.frame = CGRectMake((widths-50)/2, heights*0.15, 50, 43);
            }
        }
    }
    return _img;
}

- (UILabel *)lable
{
    if (!_lable) {
        _lable = [[UILabel alloc] init];
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            _lable.frame = CGRectMake(0, CGRectGetMaxY(self.img.frame)+15, widths, 20);
        } else {
            if ((screenHeight > 568.0f)) {
                _lable.frame = CGRectMake(0, CGRectGetMaxY(self.img.frame)+20, widths, 20);
            } else {
                _lable.frame = CGRectMake(0, CGRectGetMaxY(self.img.frame)+15, widths, 20);
            }
        }
        _lable.alpha = 0.7;
        _lable.textAlignment = NSTextAlignmentCenter;
    }
    return _lable;
}

@end
