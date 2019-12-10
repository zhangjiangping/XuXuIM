//
//  MLBillCell.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/31.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"

@interface MLBillCell : UITableViewCell
{
    UIImageView *myImg;
    UILabel *lable;
    UILabel *dandingLable;
    UILabel *timeLable;
    UILabel *moneyLable;
}
@property (nonatomic, strong) Data *model;

- (void)setModel:(Data *)model;

@end
