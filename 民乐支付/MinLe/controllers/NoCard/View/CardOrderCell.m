//
//  CardOrderCell.m
//  minlePay
//
//  Created by JP on 2017/10/17.
//  Copyright © 2017年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import "CardOrderCell.h"
#import "Data.h"

@interface CardOrderCell ()

@property (nonatomic, strong) UILabel *cardLable;
@property (nonatomic, strong) UILabel *orderLable;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) UILabel *stateLable;

@end

@implementation CardOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initUI
{
    _cardLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, cellWidth-30, 20)];
    _cardLable.font = FT(14);
    [self.contentView addSubview:_cardLable];
    
    _orderLable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_cardLable.frame)+10, cellWidth-30, 20)];
    _orderLable.font = FT(14);
    [self.contentView addSubview:_orderLable];
    
    _timeLable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_orderLable.frame)+10, cellWidth-30, 20)];
    _timeLable.font = FT(14);
    [self.contentView addSubview:_timeLable];
}

- (void)setModel:(Data *)model
{
    _model = model;
    
    _cardLable.text = [NSString stringWithFormat:@"%@：%@",[CommenUtil LocalizedString:@"NoCard.CardNumber"],model.cardno];
    _orderLable.text = [NSString stringWithFormat:@"%@：%@",[CommenUtil LocalizedString:@"NoCard.PhoneNumber"],model.mobile];
    _timeLable.text = [NSString stringWithFormat:@"%@：%@",[CommenUtil LocalizedString:@"NoCard.Date"],model.show_time];
    
}

@end
