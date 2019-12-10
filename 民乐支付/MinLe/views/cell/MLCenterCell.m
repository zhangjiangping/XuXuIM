//
//  MLCenterCell.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/28.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLCenterCell.h"

@implementation MLCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(Data *)model
{
    if (_model != model) {
        _model = model;
        while ([self.contentView.subviews lastObject] != nil) {
            [[self.contentView.subviews lastObject] removeFromSuperview];
        }
        UIImageView *ig = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, cellHeight-20, cellHeight-20)];
        if ([model.type isEqualToString:@"1"]) {
            ig.image = [UIImage imageNamed:@"tixingzhongxin_06"];
        } else if ([model.type isEqualToString:@"2"]) {
            ig.image = [UIImage imageNamed:@"tixingzhongxin_03"];
        } else {
            ig.image = [UIImage imageNamed:@"tixingzhongxin_08"];
        }
        ig.clipsToBounds = YES;
        [self.contentView addSubview:ig];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ig.frame)+10, CGRectGetMinY(ig.frame), 100, (cellHeight-20)/2)];
        lable.text = model.type_name;
        lable.font = FT(18);
        [self.contentView addSubview:lable];
        
        UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ig.frame)+10, CGRectGetMaxY(lable.frame), cellWidth-CGRectGetMaxX(ig.frame)-10-50, (cellHeight-20)/2)];
        lable2.text = model.re_info;
        lable2.font = FT(13);
        lable2.alpha = 0.5;
        [self.contentView addSubview:lable2];
        
        if (![model.number isEqualToString:@"0"]) {
            UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth-30, (cellHeight-20)/2, 20, 20)];
            lable3.text = model.number;
            lable3.textColor = [UIColor whiteColor];
            lable3.backgroundColor = [UIColor redColor];
            lable3.layer.cornerRadius = 10;
            lable3.clipsToBounds = YES;
            lable3.font = FT(13);
            lable3.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:lable3];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
