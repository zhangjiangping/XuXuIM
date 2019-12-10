//
//  AddContactsCell.m
//  Manager
//
//  Created by Apple on 15/8/19.
//  Copyright (c) 2015年 LXJ. All rights reserved.
//

#import "AddContactsCell.h"
#import "VETAppleContact.h"
#import "UIColor+FlatColor.h"

@implementation AddContactsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
    _nameAbbreviation = [UILabel new];
    _nameAbbreviation.textColor = [UIColor whiteColor];
    _nameAbbreviation.textAlignment = NSTextAlignmentCenter;
    _nameAbbreviation.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_nameAbbreviation];
    
    _lb_noti = [[UILabel alloc] init];
    _lb_noti.textAlignment = NSTextAlignmentCenter;
    _lb_noti.textColor = [UIColor whiteColor];
    _lb_noti.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:_lb_noti];
    
    _callBtn = [[PLCustomCellBtn alloc] init];
    _callBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_callBtn];
    [_callBtn setImage:[UIImage imageNamed:@"contact_call"] forState:UIControlStateNormal];
    _callBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60 / 2 - 35/2, 35, 35)];
    [self.contentView addSubview:_imgV];
    [self setViewIsCircle:_imgV];

    _lb_up = [[UILabel alloc] init];
    [self.contentView addSubview:_lb_up];
    _lb_up.font = [UIFont systemFontOfSize:16.0];
    _lb_down.textColor = [UIColor lightGrayColor];
    _lb_down.font = [UIFont systemFontOfSize:13.0];
    
    [self.contentView bringSubviewToFront:_nameAbbreviation];
}

- (void)setupLayouts
{
    [_callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15-15);
        make.top.mas_equalTo(self.contentView).mas_offset(15);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-15);
    }];
    
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView).mas_offset(10);
        make.width.and.height.mas_equalTo(@35);
    }];
    
    [_nameAbbreviation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.and.centerX.mas_equalTo(_imgV);
        make.top.and.left.and.right.and.bottom.mas_equalTo(_imgV);
    }];
    
    [_lb_up mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(_imgV.mas_right).mas_offset(10);
    }];
}

-(void)showBtn
{
    _lb_noti.hidden=YES;
//    _addBtn.hidden=NO;
}

-(void)showLb
{
    _lb_noti.hidden=NO;
//    _addBtn.hidden=YES;
}

-(void)setViewIsCircle:(UIView*)view
{
    view.layer.cornerRadius=view.frame.size.width*0.5;
    view.layer.masksToBounds=YES;
}

- (void)setContact:(VETAppleContact *)contact
{
    _contact = contact;
    
    VETMobileModel *model;
    if (!(_contact.mobileArray == nil || _contact.mobileArray.count == 0)) {
        model = contact.mobileArray[0];
    }
    
    NSString *firstPhone = model.mobileContent;
    if (model && firstPhone.length > 1) {
        NSString *firstPhone = model.mobileContent;
        _imgV.backgroundColor = [UIColor gradientColorWith:[[firstPhone substringFromIndex:firstPhone.length - 1] integerValue]];
    }
    else {
        _imgV.backgroundColor = [UIColor randomGradientColor];
    }
    
    /* 姓名 */
    self.lb_up.text = [NSString stringWithFormat:@"%@%@", contact.lastName, contact.firstName];
    
    /* 显示按钮或提示文字 */
//    [self.callBtn setTitle:NSLocalizedString(@"Add", @"Common") forState:UIControlStateNormal];

    /* 显示缩写名称 */
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    BOOL isChinese = [predicate evaluateWithObject:contact.lastName];
    NSString *abbreviationName;
    if (isChinese) {
        if (contact.lastName.length > 0) {
            abbreviationName = [contact.lastName substringToIndex:1];
        }
    }
    else {
        if (contact.firstName.length > 0 && contact.lastName.length > 0) {
            abbreviationName = [NSString stringWithFormat:@"%@%@", [contact.lastName substringToIndex:1], [contact.firstName substringToIndex:1]];
        }
        else if (contact.firstName.length > 0) {
            abbreviationName = [contact.firstName substringToIndex:1];
        }
        else if (contact.lastName.length > 0) {
            abbreviationName = [contact.lastName substringToIndex:1];
        }
    }
    self.nameAbbreviation.text = abbreviationName;
}

@end
