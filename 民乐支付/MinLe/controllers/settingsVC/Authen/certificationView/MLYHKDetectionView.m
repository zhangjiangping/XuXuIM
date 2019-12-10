//
//  MLYHKDetectionView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/12/26.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLYHKDetectionView.h"

@interface MLYHKDetectionView ()
{
    float tempWidth;
}
@property (nonatomic, strong) UIView *detectionView;
@property (nonatomic, strong) UIImageView *titleImg;
@property (nonatomic, strong) UILabel *titlelable;
@end

@implementation MLYHKDetectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        tempWidth = [self getWidthWithContent:[CommenUtil LocalizedString:@"Authen.NotCheckBranchNumber"] height:19 font:16];
        
        [self addSubview:self.detectionView];
        
        [self addSubview:self.logoutBut];
    }
    return self;
}

#pragma mark - getter

- (UILabel *)titlelable
{
    if (!_titlelable) {
        _titlelable = [[UILabel alloc] initWithFrame:CGRectMake((self.detectionView.frame.size.width-tempWidth)/2, 20, tempWidth, 19)];
        _titlelable.textAlignment = NSTextAlignmentCenter;
        _titlelable.text = [CommenUtil LocalizedString:@"Authen.NotCheckBranchNumber"];
        _titlelable.font = FT(16);
    }
    return _titlelable;
}

- (UIImageView *)titleImg
{
    if (!_titleImg) {
        _titleImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titlelable.frame)-24, 20, 19, 19)];
        _titleImg.image = [UIImage imageNamed:@"detection"];
        _titleImg.clipsToBounds = YES;
    }
    return _titleImg;
}

- (UILabel *)messageLable
{
    if (!_messageLable) {
        _messageLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titlelable.frame), CGRectGetWidth(self.detectionView.frame), 50)];
        _messageLable.textAlignment = NSTextAlignmentCenter;
        _messageLable.font = FT(18);
        _messageLable.textColor = RGB(2, 138, 218);
    }
    return _messageLable;
}

- (UIButton *)shoudongBut
{
    if (!_shoudongBut) {
        _shoudongBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _shoudongBut.frame = CGRectMake((CGRectGetWidth(self.detectionView.frame)-100*2)/3, CGRectGetMaxY(self.messageLable.frame)+10, 100, 35);
        _shoudongBut.layer.borderWidth = 1;
        _shoudongBut.layer.borderColor = LayerRGB(2, 138, 218);
        _shoudongBut.layer.cornerRadius = 17.5;
        [_shoudongBut setTitle:[CommenUtil LocalizedString:@"Authen.ManuallyEnter"] forState:UIControlStateNormal];
        [_shoudongBut setTitleColor:[UIColor colorWithRed:2.0/255.0 green:138.0/255.0 blue:218.0/255.0 alpha:1] forState:UIControlStateNormal];
    }
    return _shoudongBut;
}

- (UIButton *)changeBut
{
    if (!_changeBut) {
        _changeBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _changeBut.frame = CGRectMake((CGRectGetWidth(self.detectionView.frame)-100*2)/3+CGRectGetMaxX(self.shoudongBut.frame), CGRectGetMaxY(self.messageLable.frame)+10, 100, 35);
        _changeBut.layer.borderWidth = 1;
        _changeBut.layer.borderColor = LayerRGB(2, 138, 218);
        _changeBut.layer.cornerRadius = 17.5;
        [_changeBut setTitle:[CommenUtil LocalizedString:@"Authen.ChangeBranch"] forState:UIControlStateNormal];
        [_changeBut setTitleColor:[UIColor colorWithRed:2.0/255.0 green:138.0/255.0 blue:218.0/255.0 alpha:1] forState:UIControlStateNormal];
    }
    return _changeBut;
}

- (UIButton *)logoutBut
{
    if (!_logoutBut) {
        _logoutBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutBut.frame = CGRectMake(screenWidth-44.5, CGRectGetMinY(self.detectionView.frame)-14.5, 29, 29);
        [_logoutBut setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        _logoutBut.layer.cornerRadius = 14.5;
    }
    return _logoutBut;
}

- (UIView *)detectionView
{
    if (!_detectionView) {
        _detectionView = [[UIView alloc] initWithFrame:CGRectMake(30, (screenHeight-150)/2, screenWidth-60, 150)];
        _detectionView.backgroundColor = [UIColor whiteColor];
        _detectionView.layer.cornerRadius = 5;
        
        [_detectionView addSubview:self.titleImg];
        [_detectionView addSubview:self.titlelable];
        [_detectionView addSubview:self.messageLable];
        
        [_detectionView addSubview:self.shoudongBut];
        [_detectionView addSubview:self.changeBut];
    }
    return _detectionView;
}

//根据高度度求宽度  content 计算的内容  Height 计算的高度 font字体大小
- (CGFloat)getWidthWithContent:(NSString *)content height:(CGFloat)height font:(CGFloat)font{
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.width;
}

@end
