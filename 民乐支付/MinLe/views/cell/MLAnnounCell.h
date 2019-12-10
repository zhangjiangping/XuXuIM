//
//  MLAnnounCell.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/28.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"
#import "BaseLayerView.h"

@interface MLAnnounCell : UITableViewCell
{
    UILabel *timeLable;
    BaseLayerView *layerView;
    UILabel *lable;
    UILabel *lable2;
    UIImageView *img;
    UILabel *lable3;
    UILabel *lable4;
    UIImageView *jiantouImg;
    
    float imgHeight;
    float imgWidth;
    float textHeight;
}

@property (nonatomic, strong) Data *model;

- (void)setModel:(Data *)model;

- (CGFloat)getCellHeight;

@end
