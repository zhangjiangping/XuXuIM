//
//  MLMessageTwoCell.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/1.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTapGesture.h"
#import "Data.h"

@interface MLMessageTwoCell : UITableViewCell <UIActionSheetDelegate>
{
    UILabel *tmLable;
    UILabel *typeLable;
    UILabel *shenqingLable;
    UILabel *tongguoLable;
    
    UIImageView *sixinimg;//私信类型显示图片
    MyTapGesture *longGesture;
}

@property (nonatomic, strong) Data *model;

@end
