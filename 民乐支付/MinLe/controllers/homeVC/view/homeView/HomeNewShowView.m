//
//  HomeNewShowView.m
//  民乐支付
//
//  Created by JP on 2017/8/1.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import "HomeNewShowView.h"
#import "UIImageView+MyImageView.h"
#import "UIView+Responder.h"
#import "MLAnnouncementViewController.h"
#import "myUILabel.h"

#define showWidth (widths-50)
#define showheight 210

@interface HomeNewShowView ()

@property (nonatomic, strong) UIView *middleShowView;
@property (nonatomic, strong) UIImageView *titleImg;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) myUILabel *rightLable;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *seenButton;
@property (nonatomic, strong) UIButton *logOutButton;

@end

@implementation HomeNewShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.middleShowView];
        [self addSubview:self.titleImg];
        [self addSubview:self.logOutButton];
    }
    return self;
}

//更新视图
- (void)updataView:(NSDictionary *)dic
{
    self.alpha = 1;
    _titleLable.text = [NSString stringWithFormat:@"%@",dic[@"title"]];
    [_leftImage setImageWithString:[NSString stringWithFormat:@"%@%@",MLMLJK,dic[@"poster"]]];
    _rightLable.text = [NSString stringWithFormat:@"%@",dic[@"content"]];
    _timeLable.text = [NSString stringWithFormat:@"%@",dic[@"time"]];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.frame;
        rect.origin.y = 0;
        self.frame = rect;
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }];
}

//点击查看
- (void)seenAction:(UIButton *)sender
{
    [self.viewController.navigationController pushViewController:[[MLAnnouncementViewController alloc] init] animated:YES];
    [self cancelAction];
}

//点击退出
- (void)cancelAction
{
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.frame;
        rect.origin.y = -screenHeight;
        self.frame = rect;
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor clearColor];
    }];
}

#pragma mark - UI

- (UIImageView *)titleImg
{
    if (!_titleImg) {
        _titleImg = [[UIImageView alloc] initWithFrame:CGRectMake((widths-52)/2, (heights-showheight)/2-52/2-50, 52, 52)];
        _titleImg.clipsToBounds = YES;
        _titleImg.layer.borderColor = [UIColor whiteColor].CGColor;
        _titleImg.layer.borderWidth = 1;
        _titleImg.image = [UIImage imageNamed:@"announcement"];
    }
    return _titleImg;
}

- (UIView *)middleShowView
{
    if (!_middleShowView) {
        _middleShowView = [[UIView alloc] initWithFrame:CGRectMake((widths-showWidth)/2, (heights-showheight)/2-50, showWidth, showheight)];
        _middleShowView.backgroundColor = [UIColor whiteColor];
        _middleShowView.layer.cornerRadius = 5;
        
        [_middleShowView addSubview:self.titleLable];
        [_middleShowView addSubview:self.leftImage];
        [_middleShowView addSubview:self.rightLable];
        [_middleShowView addSubview:self.timeLable];
        [_middleShowView addSubview:self.lineView];
        [_middleShowView addSubview:self.seenButton];
    }
    return _middleShowView;
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        float titleHeight = [CommenUtil getHeightWithContent:@"秒到已开通通知" width:showWidth-30 font:18];
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 26+16, showWidth-30, titleHeight)];
        _titleLable.textColor = [ColorsUtil colorWithHexString:@"#535353"];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.font = FT(18);
    }
    return _titleLable;
}

- (UIImageView *)leftImage
{
    if (!_leftImage) {
        _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.titleLable.frame)+20, 100, 50)];
        _leftImage.clipsToBounds = YES;
    }
    return _leftImage;
}

- (myUILabel *)rightLable
{
    if (!_rightLable) {
        float rightLableHeight = 35;
        _rightLable = [[myUILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImage.frame)+10, CGRectGetMinY(self.leftImage.frame), showWidth-(CGRectGetMaxX(self.leftImage.frame)+10+15), rightLableHeight)];
        _rightLable.verticalAlignment = VerticalAlignmentTop;
        _rightLable.font = FT(14);
        _rightLable.numberOfLines = 2;
    }
    return _rightLable;
}

- (UILabel *)timeLable
{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImage.frame)+10, CGRectGetMaxY(self.rightLable.frame), showWidth-(CGRectGetMaxX(self.leftImage.frame)+10+15), 15)];
        _timeLable.font = FT(12);
        _timeLable.textColor = [ColorsUtil colorWithHexString:@"#535353"];
    }
    return _timeLable;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.leftImage.frame)+24, showWidth, 0.5)];
        _lineView.backgroundColor = [ColorsUtil colorWithHexString:@"#c3c3c4"];
    }
    return _lineView;
}

- (UIButton *)seenButton
{
    if (!_seenButton) {
        _seenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _seenButton.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), showWidth, showheight-CGRectGetMaxY(self.lineView.frame));
        [_seenButton setTitle:[CommenUtil LocalizedString:@"Common.See"] forState:UIControlStateNormal];
        [_seenButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _seenButton.titleLabel.font = FT(18);
        [_seenButton addTarget:self action:@selector(seenAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seenButton;
}

- (UIButton *)logOutButton
{
    if (!_logOutButton) {
        _logOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _logOutButton.frame = CGRectMake((widths-42)/2, CGRectGetMaxY(self.middleShowView.frame)+68, 42, 42);
        [_logOutButton setImage:[UIImage imageNamed:@"zhifuquxiao"] forState:UIControlStateNormal];
        [_logOutButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logOutButton;
}

@end





