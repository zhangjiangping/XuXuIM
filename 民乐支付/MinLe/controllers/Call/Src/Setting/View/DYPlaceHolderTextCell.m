//
//  DYProfileTextCell.m
//  DunyunLock
//
//  Created by young on 16/4/13.
//  Copyright © 2016年 duyun. All rights reserved.
//

#import "DYPlaceHolderTextCell.h"
#import "UIView+Extension.h"

@interface DYPlaceHolderTextCell ()

@property (nonatomic, retain) UIView *lineView;

@end

@implementation DYPlaceHolderTextCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        [self setupLayouts];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(15, (self.contentView.frame.size.height - 32) / 2,32,32);
    self.textLabel.x = 15 + 32 + 5;
    self.lineView.x = self.textLabel.x;
}

- (void)setupViews
{
    _placeHolderLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_placeHolderLabel];
    _placeHolderLabel.textColor = [UIColor colorWithRed:200.0f / 255.0f green:200.0f / 255.0f blue:200.0f / 255.0f alpha:1.0f];
    _placeHolderLabel.textAlignment = NSTextAlignmentRight;
    _placeHolderLabel.font = [UIFont systemFontOfSize:14.0];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = RGBCOLOR(0xd4, 0xd4, 0xd7);
    [self.contentView addSubview:_lineView];
    [self.contentView bringSubviewToFront:_lineView];
    _lineView.hidden = YES;
    
    _leftImageView = [UIImageView new];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_leftImageView];
    
    _rightImageView = [UIImageView new];
    _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_rightImageView];
}

- (void)setupLayouts
{
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView).mas_offset(15);
        make.top.mas_lessThanOrEqualTo(self.contentView).mas_offset(12);
        make.bottom.mas_lessThanOrEqualTo(self.contentView).mas_offset(-12);
        make.width.mas_equalTo(_leftImageView.mas_height);
    }];
    
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
        make.width.mas_equalTo(_rightImageView.mas_height);
    }];
    
    [_placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.top.mas_equalTo(self.contentView.mas_top).offset(5);
        make.bottom.mas_equalTo(self.contentView).offset(-5);
        make.width.equalTo(@250);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    CGFloat lineHeight = PointHeight;
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.mas_equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(@(lineHeight));
    }];
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    _placeHolderLabel.text = placeHolder;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.textLabel.text = title;
}

- (void)setShowLine:(BOOL)showLine
{
    _showLine = showLine;
    _lineView.hidden = showLine ? NO : YES;
}

@end
