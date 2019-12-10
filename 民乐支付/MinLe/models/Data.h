//
//  Data.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/22.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject
@property (nonatomic, strong) NSString *short_name;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *corporate_name;
@property (nonatomic, strong) NSString *corporate_id_card;
@property (nonatomic, strong) NSString *corporate_phone;
@property (nonatomic, strong) NSString *corporate_id_card_end_time;
@property (nonatomic, strong) NSString *business_scope;
@property (nonatomic, strong) NSString *operating_area;
@property (nonatomic, strong) NSString *merchant_class;
@property (nonatomic, strong) NSString *business_number;
@property (nonatomic, strong) NSString *business_end_time;
@property (nonatomic, strong) NSString *tax_registration_number;
@property (nonatomic, strong) NSString *account_opening_num;
@property (nonatomic, strong) NSString *business_area;
@property (nonatomic, strong) NSString *detailed_address;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *bank_type;
@property (nonatomic, strong) NSString *bank_area;
@property (nonatomic, strong) NSString *bank_branch;
@property (nonatomic, strong) NSString *bank_user_name;
@property (nonatomic, strong) NSString *bank_num;
@property (nonatomic, strong) NSString *contract_rate;
@property (nonatomic, strong) NSString *contract_number;
@property (nonatomic, strong) NSString *contract_time;
@property (nonatomic, strong) NSString *contract_end_time;

//通知中心的
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *type_name;
@property (nonatomic, strong) NSString *re_info;

//新闻列表
@property (nonatomic, strong) NSString *nid;
@property (nonatomic, strong) NSString *poster;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *zh_time;

//公告列表
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) NSString *rid;
@property (nonatomic, assign) float imgWidth;
@property (nonatomic, assign) float imgHeight;

//消息列表
@property (nonatomic, strong) NSString *week;
@property (nonatomic, strong) NSString *hour_second;
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *ymd;
@property (nonatomic, strong) NSString *content;//图片
@property (nonatomic, strong) NSString *content_type;//判断类型的
@property (nonatomic, strong) NSString *remark;//详细描述

//我的账单
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *pay_method;
@property (nonatomic, strong) NSString *order_num;

//提现
@property (nonatomic, strong) NSString *bank_name;

//账单详情
@property (nonatomic, strong) NSString *pay_status;

//分润
@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *username;

//开卡订单号
@property (nonatomic, strong) NSString *cardno;//银行卡号
@property (nonatomic, strong) NSString *orderid;//开卡订单号
@property (nonatomic, strong) NSString *activatestatus;//审核状态
@property (nonatomic, strong) NSString *order_time;//开卡时间
@property (nonatomic, strong) NSString *show_time;//列表显示时间
@property (nonatomic, strong) NSString *orderId;//订单交易订单号
@property (nonatomic, strong) NSString *txnTime;//订单交易时间
@property (nonatomic, strong) NSString *mobile;//手机号
@property (nonatomic, strong) NSString *id_card;//身份证号码

@end








