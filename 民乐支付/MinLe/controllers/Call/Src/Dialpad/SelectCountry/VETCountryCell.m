//
//  VETCountryCell.m
//  MobileVoip
//
//  Created by Liu Yang on 03/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETCountryCell.h"

@implementation VETCountryCell

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
    _countryLogo = [UIImageView new];
    [self.contentView addSubview:_countryLogo];
    
    _leftLabel = [UILabel new];
    _leftLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_leftLabel];
    
    _rigLabel = [UILabel new];
    _rigLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_rigLabel];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = RGBCOLOR(0xd4, 0xd4, 0xd7);
    [self.contentView addSubview:_lineView];
}

- (void)setupLayouts
{
    CGFloat space = 15.0;
    
    [_countryLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.and.height.equalTo(@24);
        make.left.mas_equalTo(self.contentView).offset(space);
    }];

    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(_countryLogo.mas_right).offset(space);
    }];
    
    [_rigLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView).offset(-space*2);
    }];
    
    CGFloat lineHeight = PointHeight;
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.mas_equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(@(lineHeight));
    }];
}

@end
