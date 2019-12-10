//
//  MLMyAgentDetailView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/24.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLMyAgentDetailView.h"

@interface MLMyAgentDetailView ()
@property (nonatomic, strong) UIImageView *callImageView;
@property (nonatomic, strong) UILabel *callLable;
@end

@implementation MLMyAgentDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.img];
        [self addSubview:self.nameLable];
        [self addSubview:self.phoneLable];
        [self addSubview:self.but];
        
        NSString *str = [CommenUtil LocalizedString:@"Me.AgentToMe"];
        float butHeight = 28;
        float strWidth = [CommenUtil getWidthWithContent:str withHeight:butHeight withFont:[UIFont systemFontOfSize:12]];
        float imgWH = 17;
        float leftPadding = 10;
        float padding = 13;
        float butWidth = imgWH + leftPadding*2 + padding + strWidth;
        
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            _img.frame = CGRectMake((widths-90)/2, 15, 90, 90);
            _nameLable.frame = CGRectMake(50, CGRectGetMaxY(self.img.frame)+10, widths-100, 20);
            _phoneLable.frame = CGRectMake(50, CGRectGetMaxY(self.nameLable.frame)+5, widths-100, 20);
            _but.frame = CGRectMake((widths-butWidth)/2, CGRectGetMaxY(self.phoneLable.frame)+15, 133, butHeight);
            _callImageView.frame = CGRectMake(leftPadding, (butHeight-imgWH)/2.f, imgWH, imgWH);
            _callLable.frame = CGRectMake(CGRectGetMaxX(_callImageView.frame)+padding, 0, strWidth, butHeight);
        } else {
            _img.frame = CGRectMake((widths-90)/2, 30, 90, 90);
            _nameLable.frame = CGRectMake(50, CGRectGetMaxY(self.img.frame)+20, widths-100, 30);
            _phoneLable.frame = CGRectMake(50, CGRectGetMaxY(self.nameLable.frame)+15, widths-100, 30);
            _but.frame = CGRectMake((widths-butWidth)/2, CGRectGetMaxY(self.phoneLable.frame)+30, butWidth, butHeight);
            _callImageView.frame = CGRectMake(leftPadding, (butHeight-imgWH)/2.f, imgWH, imgWH);
            _callLable.frame = CGRectMake(CGRectGetMaxX(_callImageView.frame)+padding, 0, strWidth, butHeight);
        }
        _callLable.text = str;
    }
    return self;
}

- (UIImageView *)img
{
    if (!_img) {
        _img = [[UIImageView alloc] init];
        _img.image = [UIImage imageNamed:@"woddailishang_03"];
        _img.layer.cornerRadius = 45;
        _img.clipsToBounds = YES;
    }
    return _img;
}

- (UILabel *)nameLable
{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc] init];
        _nameLable.font = FT(15);
        _nameLable.alpha = 0.5;
        _nameLable.contentMode = UIViewContentModeScaleAspectFill;
        _nameLable.adjustsFontSizeToFitWidth = YES;
    }
    return _nameLable;
}

- (UILabel *)phoneLable
{
    if (!_phoneLable) {
        _phoneLable = [[UILabel alloc] init];
        _phoneLable.font = FT(15);
        _phoneLable.alpha = 0.5;
    }
    return _phoneLable;
}

- (UIButton *)but
{
    if (!_but) {
        _but = [UIButton buttonWithType:UIButtonTypeCustom];
        _but.layer.cornerRadius = 7.5;
        _but.backgroundColor = RGB(0, 138, 218);
        
        _callImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_contact"]];
        _callImageView.clipsToBounds = YES;
        [_but addSubview:_callImageView];
        
        _callLable = [[UILabel alloc] init];
        _callLable.textColor = [UIColor whiteColor];
        _callLable.font = [UIFont systemFontOfSize:12];
        [_but addSubview:_callLable];
    }
    return _but;
}


@end







