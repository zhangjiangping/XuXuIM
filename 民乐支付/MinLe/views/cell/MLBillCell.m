//
//  MLBillCell.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/31.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLBillCell.h"

@implementation MLBillCell

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
    myImg = [[UIImageView alloc] init];
    myImg.clipsToBounds = YES;
    [self.contentView addSubview:myImg];
    
    //支付状态
    lable = [[UILabel alloc] init];
    lable.font = FT(16);
    lable.alpha = 0.8;
    [self.contentView addSubview:lable];
    
    //订单号
    dandingLable = [[UILabel alloc] init];
    dandingLable.alpha = 0.5;
    dandingLable.font = FT(14);
    dandingLable.textAlignment = NSTextAlignmentLeft;
    dandingLable.adjustsFontSizeToFitWidth = YES;
    dandingLable.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:dandingLable];
    
    //支付时间
    timeLable = [[UILabel alloc] init];
    timeLable.textAlignment = NSTextAlignmentLeft;
    timeLable.alpha = 0.5;
    timeLable.font = FT(14);
    [self.contentView addSubview:timeLable];
    
    moneyLable = [[UILabel alloc] init];
    moneyLable.textAlignment = NSTextAlignmentRight;
    moneyLable.adjustsFontSizeToFitWidth = YES;
    moneyLable.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:moneyLable];
}

- (void)setModel:(Data *)model
{
    _model = model;
    
    myImg.frame = CGRectMake(15, (cellHeight-50)/2, 50, 50);
    lable.frame = CGRectMake(CGRectGetMaxX(myImg.frame)+20, 10, 100, (cellHeight-20)/3);
    dandingLable.frame = CGRectMake(CGRectGetMaxX(myImg.frame)+20, CGRectGetMaxY(lable.frame), cellWidth-CGRectGetMaxX(myImg.frame)-120, (cellHeight-20)/3);
    timeLable.frame = CGRectMake(CGRectGetMaxX(myImg.frame)+20, CGRectGetMaxY(dandingLable.frame), cellWidth-CGRectGetMaxX(myImg.frame)-120, (cellHeight-20)/3);
    moneyLable.frame = CGRectMake(cellWidth-100, 0, 90, cellHeight);

    if ([model.pay_method isEqualToString:@"H5_ZFBJSAPI"] || [model.pay_method isEqualToString:@"API_ZFBQRCODE"] || [model.pay_method isEqualToString:@"API_ZFBSCAN"] || [model.pay_method isEqualToString:@"02"]) {
        //支付宝
        myImg.image = [UIImage imageNamed:@"zhifubao"];
    } else if ([model.pay_method isEqualToString:@"H5_WXJSAPI"] || [model.pay_method isEqualToString:@"API_WXQRCODE"] || [model.pay_method isEqualToString:@"API_WXSCAN"] || [model.pay_method isEqualToString:@"01"]) {
        //微信
        myImg.image = [UIImage imageNamed:@"weixing"];
    } else if ([model.pay_method isEqualToString:@"H5_QQJSAPI"] || [model.pay_method isEqualToString:@"API_QQQRCODE"] || [model.pay_method isEqualToString:@"API_QQSCAN"]) {
        //QQ钱包
        myImg.image = [UIImage imageNamed:@"QQ"];
    } else if ([model.pay_method isEqualToString:@"H5_JDJSAPI"] || [model.pay_method isEqualToString:@"API_JDQRCODE"] || [model.pay_method isEqualToString:@"API_JDSCAN"]) {
        //京东
        myImg.image = [UIImage imageNamed:@"JD"];
    } else if ([model.pay_method isEqualToString:@"H5_BDJSAPI"] || [model.pay_method isEqualToString:@"API_BDQRCODE"] || [model.pay_method isEqualToString:@"API_BDSCAN"]) {
        //百度
        myImg.image = [UIImage imageNamed:@"baidu-pay"];
    } else if ([model.pay_method isEqualToString:@"4"]) {
        //无卡收款
        myImg.image = [UIImage imageNamed:@"icon-card"];
    } else {
        //扫描收款
        myImg.image = [UIImage imageNamed:@"qr-record"];
    }

   dandingLable.text = model.order_num;
   timeLable.text = model.create_time;
    
    if ([model.type isEqualToString:@"1"]) {
        if ([model.pay_method isEqualToString:@"H5_ZFBJSAPI"] || [model.pay_method isEqualToString:@"H5_WXJSAPI"] || [model.pay_method isEqualToString:@"H5_QQJSAPI"] || [model.pay_method isEqualToString:@"H5_JDJSAPI"] || [model.pay_method isEqualToString:@"H5_BDJSAPI"]) {
            lable.text = [CommenUtil LocalizedString:@"Bill.PublicCollection"];
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
}

@end
