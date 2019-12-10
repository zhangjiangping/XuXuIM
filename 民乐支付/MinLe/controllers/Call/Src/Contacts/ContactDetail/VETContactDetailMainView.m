//
//  VETContactDetailMainView.m
//  MobileVoip
//
//  Created by Liu Yang on 03/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETContactDetailMainView.h"
#import "VETAppleContact.h"
#import "UIView+TTGStarAnimation.h"
#import "UIColor+FlatColor.h"

/***********************************************************
 *  VETContactDetailPhoneCell
 ***********************************************************/
@implementation VETContactDetailPhoneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
        [self setupLayouts];
    }
    return self;
}

- (void)setupViews
{
    _hintLabel = [[UILabel alloc] init];
    _hintLabel.textColor = [UIColor blackColor];
    _hintLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_hintLabel];
    
    _phoneNumLabel = [[UILabel alloc] init];
    _phoneNumLabel.textColor = MAINTHEMECOLOR;
    [self.contentView addSubview:_phoneNumLabel];
    
//    _ratesButton = [[UIButton alloc] init];
//    [_ratesButton setTitle:[CommenUtil LocalizedString:@"Call.Rates"] forState:UIControlStateNormal];
//    [_ratesButton setTitleColor:MAINTHEMECOLOR forState:UIControlStateNormal];
//    _ratesButton.layer.borderColor = MAINTHEMECOLOR.CGColor;
//    _ratesButton.layer.borderWidth = 1.0;
//    _ratesButton.layer.masksToBounds = YES;
//    _ratesButton.layer.cornerRadius = 10.0;
//    _ratesButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    [_ratesButton addTarget:self action:@selector(tapRatesBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:_ratesButton];
    
    _callButton = [[UIButton alloc] init];
    [_callButton setImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
    [_callButton setBackgroundColor:MAINTHEMECOLOR];
    _callButton.layer.borderColor = MAINTHEMECOLOR.CGColor;
    _callButton.layer.borderWidth = 1.0;
    _callButton.layer.masksToBounds = YES;
    _callButton.layer.cornerRadius = 35.0 / 2;
    [_callButton addTarget:self action:@selector(tapCallBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_callButton];
}

- (void)setupLayouts
{
    CGFloat space = 15.0;
    
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(space);
        make.bottom.mas_equalTo(self.contentView.mas_centerY).mas_offset(-2);
    }];
    
    [_phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(space);
        make.top.mas_equalTo(self.contentView.mas_centerY).mas_offset(2);
    }];
    
    [_ratesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_callButton.mas_left).mas_offset(-20);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(@60);
        make.height.mas_equalTo(@30);
    }];
    
    [_callButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).mas_offset(-25);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.and.height.mas_equalTo(@35);
    }];
}

- (void)setMobileModel:(VETMobileModel *)mobileModel
{
    _mobileModel = mobileModel;
    _hintLabel.text = _mobileModel.mobileType;
    
    // 删除开头有00的号码
    NSString *handleString;
    if (_mobileModel.mobileContent && _mobileModel.mobileContent.length > 2) {
        NSString *twoPrefix = [_mobileModel.mobileContent substringToIndex:2];
        handleString = [twoPrefix isEqualToString:@"00"] ? [_mobileModel.mobileContent substringFromIndex:2] : _mobileModel.mobileContent;
    }
    else {
        handleString = _mobileModel.mobileContent;
    }
    _phoneNumLabel.text = handleString;
}

- (void)tapRatesBtn:(id)sender
{
    UIButton *ratesBtn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailPhoneCell:didTapRatesBtn:model:)]) {
        [self.delegate detailPhoneCell:self didTapRatesBtn:ratesBtn model:_mobileModel];
    }
}

- (void)tapCallBtn:(id)sender
{
    UIButton *callBtn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailPhoneCell:didTapCallBtn:model:)]) {
        [self.delegate detailPhoneCell:self didTapCallBtn:callBtn model:_mobileModel];
    }
}

@end

/***********************************************************
 *  VETContactDetailMainView
 ***********************************************************/

@interface VETContactDetailMainView ()

@end

@implementation VETContactDetailMainView
{
    NSArray *_mobileArray;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setupViews];
        [self setupLayouts];
        [self.phoneNumberTableView reloadData];
    }
    return self;
}

- (void)setContact:(VETAppleContact *)contact
{
    _contact = contact;
    _nameLabel.text = contact.fullName;
    _mobileArray = contact.mobileArray;
    
//    VETMobileModel *model = contact.mobileArray[0];
//    if (model) {
//        NSString *firstPhone = model.mobileContent;
//        _avatarImageView.backgroundColor = [UIColor gradientColorWith:[[firstPhone substringToIndex:1] integerValue]];
//    }
//    else {
//        _avatarImageView.backgroundColor = [UIColor randomGradientColor];
//    }
}

- (void)setupViews
{
    self.backgroundColor = RGBACOLOR(0xfa, 0xfa, 0xff, 1.0);
    
    /*
     * topView
     */
    _topView = [UIView new];
    _topView.backgroundColor = RGBACOLOR(0xfa, 0xfa, 0xff, 1.0);
    [self addSubview:_topView];
    
    _avatarImageView = [UIImageView new];
    _avatarImageView.image = [UIImage imageNamed:@"avatar"];
//    _avatarImageView.backgroundColor = [UIColor randomGradientColor];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_topView addSubview:_avatarImageView];
    
    _favoriteButton = [UIButton new];
    [_favoriteButton setImage:[UIImage imageNamed:@"favorite_unselect"] forState:UIControlStateNormal];
    [_favoriteButton setImage:[UIImage imageNamed:@"favorite_selected"] forState:UIControlStateSelected];
    _favoriteButton.contentMode = UIViewContentModeScaleAspectFit;
    [_favoriteButton addTarget:self action:@selector(tapFavoriteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_favoriteButton];
    [_favoriteButton ttg_setupStarAnimation];
    
    // TODO:缩小时，字体没变小。
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont systemFontOfSize:22.0];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.minimumScaleFactor = 0.5;
    _nameLabel.numberOfLines = 0;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_nameLabel];
    
    /*
     * tableview
     */
    _phoneNumberTableView = [[UITableView alloc] init];
    _phoneNumberTableView.backgroundColor = [UIColor whiteColor];
    _phoneNumberTableView.showsVerticalScrollIndicator = YES;
    [self addSubview:_phoneNumberTableView];
}

- (void)setupLayouts
{
    /*
     * topView
     */
    CGFloat topHeight = SCREEN_HEIGHT * 0.35;
    _topHeightConstraint = [[_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(20);
        make.left.and.right.mas_equalTo(self);
        make.height.mas_equalTo(@(topHeight));
    }] objectAtIndex:2];
    
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_topView.mas_centerX);
        make.centerY.mas_equalTo(_topView.mas_centerY).mas_offset(-20);
        make.height.and.width.mas_equalTo(_topView).multipliedBy(0.5);
    }];
    
    [_favoriteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_avatarImageView.mas_centerY);
        make.right.mas_equalTo(_topView).mas_offset(-40);
        make.width.and.height.mas_equalTo(@60);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_topView.mas_bottom).mas_offset(-5).priorityHigh();
        make.centerX.mas_equalTo(_topView.mas_centerX);
        make.top.mas_equalTo(_avatarImageView.mas_bottom).mas_offset(10).priorityHigh();
        make.height.mas_equalTo(_avatarImageView.height).multipliedBy(0.15).priorityMedium();
    }];
    
    /*
     * tableview
     */
    [_phoneNumberTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView.mas_bottom);
        make.bottom.and.left.and.right.mas_equalTo(self);
    }];
}

- (void)tapFavoriteBtn:(id)sender
{
    UIButton *button = (UIButton *)sender;
    // 显示取消收藏
    if (button.selected) {
        [button ttg_hideStarAnimated:YES complete:^{
        }];
    }
    // 显示收藏
    else {
        [button ttg_showStarAnimated:YES complete:^{
        }];
    }
    if ([self delegate] && [self.delegate respondsToSelector:@selector(mainView:didTapFavorityBtn:)]) {
        [self.delegate mainView:self didTapFavorityBtn:sender];
    }
}

@end
