//
//  MLAssetsDetailCell.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/2.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"

@interface MLAssetsDetailCell : UITableViewCell
{
    UILabel *timelable;
    UILabel *timeLable2;
    UIImageView *myImg;
    UILabel *lable;
    UILabel *moneyLable;
    UILabel *statusLable;
}
@property (nonatomic, strong) Data *model;

- (void)setModel:(Data *)model;

@end
