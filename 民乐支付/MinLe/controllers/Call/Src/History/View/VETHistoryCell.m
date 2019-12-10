//
//  VETHistoryCell.m
//  LYXAnimatoinDemo
//
//  Created by Liu Yang on 22/03/2017.
//  Copyright © 2017 young. All rights reserved.
//

#import "VETHistoryCell.h"
#import "masonry.h"
#import <objc/runtime.h>
#import "PLCustomCellBtn.h"
#import "VETCallRecord.h"
#import "NSDateFormatter+Category.h"
#import "NSDate+LYXExtension.h"

@interface VETHistoryCell ()

@property (nonatomic, retain) UIView *lineView;

@end

@implementation VETHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
        [self setupLayouts];
    }
    return self;
}

- (void)setupViews {
    _statusImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_statusImageView];
    _statusImageView.hidden = YES;
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = RGBCOLOR(0xd4, 0xd4, 0xd7);
    [self.contentView addSubview:_lineView];
    _lineView.hidden = YES;
    
    _phoneLabel = [UILabel new];
    [self.contentView addSubview:_phoneLabel];
//    _phoneLabel.adjustsFontSizeToFitWidth = YES;
//    [_phoneLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    _stausLabel = [UILabel new];
    [self.contentView addSubview:_stausLabel];
    _stausLabel.textColor = [UIColor lightGrayColor];
    _stausLabel.adjustsFontSizeToFitWidth = YES;
    _stausLabel.font = [UIFont systemFontOfSize:13.0];

    _timeLabel = [UILabel new];
    [self.contentView addSubview:_timeLabel];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.textAlignment = NSTextAlignmentRight;
//    _timeLabel.adjustsFontSizeToFitWidth = YES;
//    _timeLabel.minimumScaleFactor = 14.0;
    [_timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    _timeLabel.font = [UIFont systemFontOfSize:13.0];
    
//    _detailButton = [PLCustomCellBtn new];
//    [self.contentView addSubview:_detailButton];
//    [_detailButton setImage:[UIImage imageNamed:@"detail_icon"] forState:UIControlStateNormal];
//    _detailButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setupLayouts {
    CGFloat space = 12.0;
    
    [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.and.height.equalTo(@14);
        make.left.mas_equalTo(self.contentView).offset(space);
    }];
    
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_statusImageView.mas_right).offset(space);
        make.bottom.mas_equalTo(self.contentView.mas_centerY).offset(-1);
        make.right.mas_equalTo(_timeLabel.mas_left).offset(-10);
    }];
    
    [_stausLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_phoneLabel).offset(0);
        make.top.mas_equalTo(self.contentView.mas_centerY).offset(1);
    }];
    
//    [_detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.contentView).offset(-space);
//        make.centerY.mas_equalTo(self.contentView.mas_centerY);
//        make.width.and.height.mas_equalTo(@20);
//    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-16);
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(0);
    }];
    
    CGFloat lineHeight = PointHeight;
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.right.mas_equalTo(self.contentView).offset(0);
        make.left.mas_equalTo(self.contentView).offset(35);
        make.height.mas_equalTo(@(lineHeight));
        make.width.mas_greaterThanOrEqualTo(@(30)).priorityHigh();
    }];
}

- (void)setShowLine:(BOOL)showLine
{
    _showLine = showLine;
    _lineView.hidden = showLine ? NO : YES;
}

- (void)setRecord:(VETCallRecord *)record
{
    _record = record;
    if (record.callPhoneFullName && record.callPhoneFullName.length > 0) {
        _phoneLabel.text = record.callPhoneFullName;
    }
    else {
        _phoneLabel.text = record.account;
    }
    
    switch (record.callType) {
        case VETCallTypeIncoming: {
            _stausLabel.text = [CommenUtil LocalizedString:@"Call.Incoming"];
            _phoneLabel.textColor = [UIColor blackColor];
            _statusImageView.hidden = YES;
            _statusImageView.image = [UIImage imageNamed:@"phone_incoming"];
            break;
        }
        case VETCallTypeFailed: {
            _stausLabel.text = [CommenUtil LocalizedString:@"Call.Failed"];
            _phoneLabel.textColor = [UIColor blackColor];
            _statusImageView.hidden = YES;
            break;
        }
        case VETCallTypeOutgoing: {
            _stausLabel.text = [CommenUtil LocalizedString:@"Call.Outgoing"];
            _phoneLabel.textColor = [UIColor blackColor];
            _statusImageView.hidden = NO;
            _statusImageView.image = [UIImage imageNamed:@"phone_outgoing"];
            break;
        }
        case VETCallTypeMissed: {
            _stausLabel.text = [CommenUtil LocalizedString:@"Call.Missed"];
            _phoneLabel.textColor = RGBCOLOR(0xff, 0x3b, 0x30);
            _statusImageView.hidden = NO;
            _statusImageView.image = [UIImage imageNamed:@"phone_missed"];
            break;
        }
        default:
            break;
    }
    NSDateFormatter *defaultFormatter = [NSDateFormatter defaultDateFormatter];
    NSDate *date = [defaultFormatter dateFromString:record.callTime];
    _timeLabel.text = [NSDate convertToNormalTimeWithDate:date language:NSDateNormalTimeLanguageEN];
    self.showLine = YES;
}

@end
