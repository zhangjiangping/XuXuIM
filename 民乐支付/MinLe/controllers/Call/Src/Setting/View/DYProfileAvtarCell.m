//
//  DYProfileAvtarCell.m
//  DunyunLock
//
//  Created by young on 16/4/13.
//  Copyright © 2016年 duyun. All rights reserved.
//

#import "DYProfileAvtarCell.h"
//#import "UIImageView+CornerRadius.h"

@interface DYProfileAvtarCell ()

@property (nonatomic, retain) UIView *lineView;
@property (nonatomic, retain) UILabel *phoneLabel;
@property (nonatomic, retain) UIImageView *rightImageView;

@end

@implementation DYProfileAvtarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        [self setupLayouts];
    }
    return self;
}

- (void)setupViews
{
    _avtarImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_avtarImageView];
    _avtarImageView.layer.cornerRadius = 50 * 0.5;
    _avtarImageView.clipsToBounds = YES;
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = RGBCOLOR(0xd4, 0xd4, 0xd7);
    [self.contentView addSubview:_lineView];
    _lineView.hidden = YES;
    
    _phoneLabel = [UILabel new];
    _phoneLabel.textColor = [UIColor blackColor];
    _phoneLabel.font = [UIFont systemFontOfSize:18.0];
    [self.contentView addSubview:_phoneLabel];
    
    _rightImageView = [UIImageView new];
    _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    _rightImageView.image = [UIImage imageNamed:@"arrow"];
    [self.contentView addSubview:_rightImageView];
}

- (void)setupLayouts
{
    [_avtarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.and.height.equalTo(@50);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
    }];
    
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(_avtarImageView.mas_right).offset(15);
    }];
    
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
        make.width.mas_equalTo(_rightImageView.mas_height);
    }];
    
    CGFloat lineHeight = PointHeight;
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.mas_equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(@(lineHeight));
    }];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _phoneLabel.text = title;
}

- (void)setShowLine:(BOOL)showLine
{
    _showLine = showLine;
    _lineView.hidden = showLine ? NO : YES;

}

- (void)setShowDisclosure:(BOOL)showDisclosure
{
    _showDisclosure = showDisclosure;
    _rightImageView.hidden = showDisclosure ? NO : YES;
}

@end
