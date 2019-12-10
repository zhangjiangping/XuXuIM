//
//  VETSwitchCell.m
//  MobileVoip
//
//  Created by Liu Yang on 01/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETSwitchCell.h"

@interface VETSwitchCell ()

@end

@implementation VETSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
        [self setupLayouts];
    }
    return self;
}

- (void)setupViews
{
    _switchBtn = [UISwitch new];
    [self.contentView addSubview:_switchBtn];
    _switchBtn.tintColor = MAINTHEMECOLOR;
    _switchBtn.onTintColor = MAINTHEMECOLOR;
    [_switchBtn addTarget:self action:@selector(tapSwitch:) forControlEvents:UIControlEventValueChanged];
}

- (void)setupLayouts
{
    [_switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
}

// subclass implementation
- (void)tapSwitch:(id)sender
{
    
}

@end
