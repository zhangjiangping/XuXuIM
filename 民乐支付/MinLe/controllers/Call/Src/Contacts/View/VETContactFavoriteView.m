//
//  VETContactFavoriteView.m
//  MobileVoip
//
//  Created by Liu Yang on 06/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETContactFavoriteView.h"
#import "masonry.h"

@implementation VETContactFavoriteView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
        [self setupLayouts];
    }
    return self;
}

- (void)setupViews
{
    _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60 / 2 - 35/2, 35, 35)];
    _imgV.layer.cornerRadius = _imgV.frame.size.width * 0.5;
    _imgV.layer.masksToBounds=YES;
    _imgV.image = [UIImage imageNamed:@"contact_favorite"];
    [self addSubview:_imgV];
    
    _textLabel = [UILabel new];
    _textLabel.backgroundColor = [UIColor blackColor];
    _textLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:_textLabel];
}

- (void)setupLayouts
{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self).mas_offset(10);
        make.width.and.height.mas_equalTo(@35);
    }];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(_imgV.mas_right).mas_offset(10);
    }];
}

@end
