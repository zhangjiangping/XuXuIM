//
//  MLMessageCell.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/28.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLMessageCell.h"

@implementation MLMessageCell

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
        
        UILabel *timelable = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 50, 20)];
        timelable.text = model.week;
        timelable.alpha = 0.5;
        timelable.font = FT(15);
        timelable.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:timelable];
        
        UILabel *timeLable2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 50, 20)];
        timeLable2.text = model.hour_second;
        timeLable2.textAlignment = NSTextAlignmentCenter;
        timeLable2.alpha = 0.5;
        timeLable2.font = FT(13);
        [self.contentView addSubview:timeLable2];
        
        UILabel *lable = [[UILabel alloc] init];
        lable.frame = CGRectMake(85, 0, cellWidth-110, 75);
        lable.text = model.title;
        lable.alpha = 0.8;
        lable.adjustsFontSizeToFitWidth = YES;
        lable.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:lable];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
