//
//  MLNewsCell.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/28.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLNewsCell.h"
#import "UIImageView+MyImageView.h"
#import "myUILabel.h"

@implementation MLNewsCell

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
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, cellHeight+20, cellHeight-20)];
        NSString *imgUrlStr = [NSString stringWithFormat:@"%@%@",MLMLJK,model.poster];
        [image setImageWithString:imgUrlStr withDefalutImage:nil];
        image.clipsToBounds = YES;
        [self.contentView addSubview:image];
        
        myUILabel *lable = [[myUILabel alloc] init];
        if ([model.poster isEqualToString:@""]) {
            lable.frame = CGRectMake(15, 10, cellWidth-20, (cellHeight-20)/2);
        } else {
            lable.frame = CGRectMake(CGRectGetMaxX(image.frame)+15, 10, cellWidth-CGRectGetMaxX(image.frame)-30, cellHeight-20-20);
        }
        lable.text = model.title;
        lable.numberOfLines = 2;
        lable.alpha = 0.8;
        lable.verticalAlignment = VerticalAlignmentTop;//向上对齐
        [self.contentView addSubview:lable];
        
        UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth/2-15, cellHeight-25, cellWidth/2, 15)];
        lable2.text = model.zh_time;
        lable2.font = FT(12);
        lable2.alpha = 0.5;
        lable2.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:lable2];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
