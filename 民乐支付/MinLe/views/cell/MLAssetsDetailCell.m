//
//  MLAssetsDetailCell.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/2.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLAssetsDetailCell.h"

@implementation MLAssetsDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    timelable = [[UILabel alloc] init];
    timelable.alpha = 0.5;
    timelable.font = FT(15);
    timelable.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:timelable];
    
    timeLable2 = [[UILabel alloc] init];
    timeLable2.textAlignment = NSTextAlignmentCenter;
    timeLable2.alpha = 0.5;
    timeLable2.font = FT(13);
    [self.contentView addSubview:timeLable2];
    
    myImg = [[UIImageView alloc] init];
    myImg.clipsToBounds = YES;
    [self.contentView addSubview:myImg];
    
    lable = [[UILabel alloc] init];
    lable.font = FT(16);
    lable.alpha = 0.8;
    [self.contentView addSubview:lable];
    
    moneyLable = [[UILabel alloc] init];
    moneyLable.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:moneyLable];
    
    statusLable = [[UILabel alloc] init];
    statusLable.textAlignment = NSTextAlignmentRight;
    statusLable.font = FT(13);
    [self.contentView addSubview:statusLable];
}

- (void)setModel:(Data *)model
{
    _model = model;
    
    timelable.frame = CGRectMake(10, cellHeight/5+5, 50, cellHeight/5);
    timelable.text = model.week;
    timeLable2.frame = CGRectMake(10, CGRectGetMaxY(timelable.frame)+cellHeight/10, 50, cellHeight/5);
    timeLable2.text = model.hour_second;
    
    myImg.frame = CGRectMake(80, (cellHeight-35)/2, 35, 35);
    if ([model.pay_method isEqualToString:@"H5_ZFBJSAPI"] || [model.pay_method isEqualToString:@"API_ZFBSCAN"] || [model.pay_method isEqualToString:@"API_ZFBQRCODE"] || [model.pay_method isEqualToString:@"02"]) {
        //支付宝
        myImg.image = [UIImage imageNamed:@"zhifubao"];
    } else if ([model.pay_method isEqualToString:@"H5_WXJSAPI"] || [model.pay_method isEqualToString:@"API_WXSCAN"] || [model.pay_method isEqualToString:@"API_WXQRCODE"] || [model.pay_method isEqualToString:@"01"]) {
        //微信
        myImg.image = [UIImage imageNamed:@"weixing"];
    } else if ([model.pay_method isEqualToString:@"H5_QQJSAPI"] || [model.pay_method isEqualToString:@"API_QQSCAN"] || [model.pay_method isEqualToString:@"API_QQQRCODE"]) {
        //QQ钱包
        myImg.image = [UIImage imageNamed:@"QQ"];
    } else if ([model.pay_method isEqualToString:@"H5_JDJSAPI"] || [model.pay_method isEqualToString:@"API_JDSCAN"] || [model.pay_method isEqualToString:@"API_JDQRCODE"]) {
        //京东
        myImg.image = [UIImage imageNamed:@"JD"];
    } else if ([model.pay_method isEqualToString:@"H5_BDJSAPI"] || [model.pay_method isEqualToString:@"API_BDSCAN"] || [model.pay_method isEqualToString:@"API_BDQRCODE"]) {
        //百度
        myImg.image = [UIImage imageNamed:@"baidu-pay"];
    } else if ([model.pay_method isEqualToString:@"4"]) {
        //无卡收款
        myImg.image = [UIImage imageNamed:@"icon-card"];
    } else {
        //扫描收款
        myImg.image = [UIImage imageNamed:@"qr-Receipt"];
    }
    
    lable.frame = CGRectMake(CGRectGetMaxX(myImg.frame)+20, 0, 100, cellHeight);
    moneyLable.frame = CGRectMake(CGRectGetMaxX(lable.frame)+10, 0, cellWidth-CGRectGetMaxX(lable.frame)-20, cellHeight/2);
    statusLable.frame = CGRectMake(CGRectGetMaxX(lable.frame)+10, cellHeight/2, cellWidth-CGRectGetMaxX(lable.frame)-20, cellHeight/2);

    if ([model.pay_status isEqualToString:@"0"]) {
        statusLable.text = [CommenUtil LocalizedString:@"Asset.NotCollection"];
        statusLable.textColor = RGB(249, 166, 21);
    }
    if ([model.pay_status isEqualToString:@"1"]) {
        statusLable.text = [CommenUtil LocalizedString:@"Asset.CollectionSuccess"];
        statusLable.textColor = RGB(18, 175, 10);
    }
    if ([model.pay_status isEqualToString:@"2"]) {
        statusLable.text = [CommenUtil LocalizedString:@"Asset.CollectionFaile"];
        statusLable.textColor = RGB(220, 19, 19);
    }
    if ([model.pay_status isEqualToString:@"3"]) {
        statusLable.text = [CommenUtil LocalizedString:@"Asset.Review"];
        statusLable.textColor = RGB(249, 166, 21);
    }
    if ([model.pay_status isEqualToString:@"4"]) {
        statusLable.text = [CommenUtil LocalizedString:@"Asset.ReviewThrough"];
        statusLable.textColor = RGB(18, 175, 10);
    }
    if ([model.pay_status isEqualToString:@"5"]) {
        statusLable.text = [CommenUtil LocalizedString:@"Asset.NotThrough"];
        statusLable.textColor = RGB(220, 19,19);
    }
    if ([model.pay_status isEqualToString:@"6"]) {
        statusLable.text = [CommenUtil LocalizedString:@"Asset.AllRefund"];
        statusLable.textColor = RGB(220, 19,19);
    }
    if ([model.pay_status isEqualToString:@"7"]) {
        statusLable.text = [CommenUtil LocalizedString:@"Asset.PartRefund"];
        statusLable.textColor = RGB(220, 19,19);
    }
    if ([model.pay_status isEqualToString:@"8"]) {
        statusLable.text = [CommenUtil LocalizedString:@"Asset.OrderCancel"];
        statusLable.textColor = RGB(220, 19,19);
    }
    
    if ([model.type isEqualToString:@"1"]) {
        if ([model.pay_method isEqualToString:@"H5_ZFBJSAPI"] || [model.pay_method isEqualToString:@"H5_WXJSAPI"] || [model.pay_method isEqualToString:@"H5_QQJSAPI"] || [model.pay_method isEqualToString:@"H5_JDJSAPI"] || [model.pay_method isEqualToString:@"H5_BDJSAPI"]) {
            lable.text = [CommenUtil LocalizedString:@"Asset.PublicCollection"];
        } else {
            lable.text = [CommenUtil LocalizedString:@"Collection.SweepCodeCollection"];
        }
        moneyLable.text = [NSString stringWithFormat:@"+%@",model.money];
    } else if ([model.type isEqualToString:@"3"]) {
        if ([model.pay_method isEqualToString:@"4"]) {
            lable.text = [CommenUtil LocalizedString:@"Bill.NoCardCollection"];
        }
        moneyLable.text = [NSString stringWithFormat:@"+%@",model.money];
    } else {
        lable.text = [CommenUtil LocalizedString:@"Draw.AmountWithdrawal"];
        moneyLable.text = [NSString stringWithFormat:@"-%@",model.money];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
