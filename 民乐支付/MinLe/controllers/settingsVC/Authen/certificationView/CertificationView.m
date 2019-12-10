//
//  CertificationView.m
//  live
//
//  Created by SZVETRON-iMAC on 2017/1/10.
//  Copyright © 2017年 SZVetron. All rights reserved.
//

#import "CertificationView.h"
#import "UIView+Responder.h"
#import "UIViewController+XHPhoto.h"
#import "CAGradientLayer+Custom.h"

@interface CertificationView ()
{
    CGFloat w;
    CGFloat h;
    float defaultHeight;
    NSString *_addName;
    NSString *_leftImgName;
    //CAGradientLayer *_gradientLayer;
}
@property (nonatomic, strong) UIImageView *addImg;
@property (nonatomic, strong) UILabel *rightLable;

@end

@implementation CertificationView

- (instancetype)initWithFrame:(CGRect)frame withLeftImgName:(NSString *)leftName withAddName:(NSString *)addName
{
    self = [super initWithFrame:frame];
    if (self) {
        w = frame.size.width/2.0f;
        h = frame.size.height;
        _addName = addName;
        _leftImgName = leftName;
        defaultHeight = [CommenUtil getTxtHeight:_addName forContentWidth:w fotFontSize:12];
        self.backgroundColor = [ColorsUtil colorWithHexString:@"#d2d8dc"];
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        
        [self addSubview:self.leftImg];
        [self addSubview:self.rightBut];
    }
    return self;
}

- (void)setState:(TakingPicturesState)state
{
    if (state == TakingPicturesStateDefault) {
        _rightLable.text = _addName;
    } else {
        _rightLable.text = [CommenUtil LocalizedString:@"Authen.TapToShoot"];
    }
}

#pragma mark - getter

- (UIImageView *)leftImg
{
    if (!_leftImg) {
        _leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, (h-77.5)/2, 114, 77.5)];
        _leftImg.clipsToBounds = YES;
        _leftImg.layer.cornerRadius = 5;
        _leftImg.image = [UIImage imageNamed:_leftImgName];
    }
    return _leftImg;
}

- (UIButton *)rightBut
{
    if (!_rightBut) {
        _rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBut.frame = CGRectMake(w, 0, w, h);
        
        [_rightBut addSubview:self.addImg];
        [_rightBut addSubview:self.rightLable];
    }
    return _rightBut;
}

- (UIImageView *)addImg
{
    if (!_addImg) {
        _addImg = [[UIImageView alloc] initWithFrame:CGRectMake((w-20)/2, (h-20-defaultHeight-17)/2, 20, 20)];
        _addImg.clipsToBounds = YES;
        _addImg.image = [UIImage imageNamed:@"add"];
    }
    return _addImg;
}

- (UILabel *)rightLable
{
    if (!_rightLable) {
        _rightLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addImg.frame)+17, w, defaultHeight)];
        _rightLable.textAlignment = NSTextAlignmentCenter;
        _rightLable.textColor = [ColorsUtil colorWithHexString:@"#0093e3"];
        _rightLable.font = FT(12);
    }
    return _rightLable;
}



@end




