//
//  MLMessageTwoCell.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/1.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLMessageTwoCell.h"
#import "UIImageView+MyImageView.h"
#import "UIView+Responder.h"

@implementation MLMessageTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    tmLable = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, cellWidth-80, 15)];
    tmLable.font = FT(12);
    tmLable.alpha = 0.5;
    [self.contentView addSubview:tmLable];
    
    typeLable = [[UILabel alloc] init];
    typeLable.font = FT(15);
    typeLable.alpha = 0.5;
    typeLable.numberOfLines = 0;
    [self.contentView addSubview:typeLable];
    
    shenqingLable = [[UILabel alloc] init];
    shenqingLable.font = FT(15);
    shenqingLable.alpha = 0.5;
    [self.contentView addSubview:shenqingLable];
    
    tongguoLable = [[UILabel alloc] init];
    tongguoLable.font = FT(15);
    tongguoLable.alpha = 0.5;
    [self.contentView addSubview:tongguoLable];
    
    sixinimg = [[UIImageView alloc] init];
    sixinimg.clipsToBounds = YES;
    sixinimg.userInteractionEnabled = YES;
    [self.contentView addSubview:sixinimg];
}

- (void)setModel:(Data *)model
{
    _model = model;
    
    tmLable.text = model.ymd;
    
    if ([model.content_type isEqualToString:@"1"]) {
        sixinimg.hidden = YES;
        shenqingLable.hidden = NO;
        tongguoLable.hidden = NO;
        
        
        NSString *titleStr = [NSString stringWithFormat:@"%@：%@",[CommenUtil LocalizedString:@"Center.AuthType"],model.title];
        float typeHeight = [CommenUtil getTxtHeight:titleStr forContentWidth:cellWidth-80 fotFontSize:15];
        typeLable.frame = CGRectMake(80, 40, cellWidth-80, typeHeight);
        typeLable.text = titleStr;
        
        shenqingLable.frame = CGRectMake(80, CGRectGetMaxY(typeLable.frame)+10, cellWidth-80, 15);
        shenqingLable.text = [NSString stringWithFormat:@"%@：%@",[CommenUtil LocalizedString:@"Settle.ApplyDate"],model.create_time];
        
        tongguoLable.frame = CGRectMake(80, CGRectGetMaxY(shenqingLable.frame)+10, cellWidth-80, 15);
        tongguoLable.text = [NSString stringWithFormat:@"%@：%@",[CommenUtil LocalizedString:@"Center.ThroughDate"],model.update_time];
    } else {
        sixinimg.hidden = NO;
        shenqingLable.hidden = YES;
        tongguoLable.hidden = YES;
        
        float typeHeight = [CommenUtil getTxtHeight:model.remark forContentWidth:cellWidth-80 fotFontSize:15];
        typeLable.frame = CGRectMake(80, 40, cellWidth-80, typeHeight);
        typeLable.text = model.remark;

        sixinimg.frame = CGRectMake((screenWidth-200)/2, CGRectGetMaxY(typeLable.frame)+10, 200, 200);
        [sixinimg setImageWithString:model.content withDefalutImage:[UIImage imageNamed:@""]];
        
        if (!longGesture) {
            longGesture = [[MyTapGesture alloc] initWithTarget:self action:@selector(longAction:)];
            [sixinimg addGestureRecognizer:longGesture];
        }
    }
}

//长按图片响应方法
- (void)longAction:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:[CommenUtil LocalizedString:@"Electronic.SavePhoto"]
                                      delegate:self
                                      cancelButtonTitle:[CommenUtil LocalizedString:@"Common.Cancle"]
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:[CommenUtil LocalizedString:@"Electronic.SavePhotoToPhone"],nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.viewController.view];
    }
}

#pragma mark --- UIActionSheetDelegate---

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (sixinimg.image) {
            UIImageWriteToSavedPhotosAlbum(sixinimg.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[CommenUtil LocalizedString:@"Common.Prompt"] message:[CommenUtil LocalizedString:@"Electronic.PhotoNotLoading"] delegate:self cancelButtonTitle:[CommenUtil LocalizedString:@"Common.Ture"] otherButtonTitles: nil];
            [alert show];
        }
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message = [CommenUtil LocalizedString:@"Electronic.SaveGood"];
    if (!error) {
        message = [CommenUtil LocalizedString:@"Electronic.SaveSuccess"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[CommenUtil LocalizedString:@"Common.Prompt"] message:message delegate:self cancelButtonTitle:[CommenUtil LocalizedString:@"Common.Ture"] otherButtonTitles: nil];
        [alert show];
    } else {
        message = [error description];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[CommenUtil LocalizedString:@"Common.Prompt"] message:message delegate:self cancelButtonTitle:[CommenUtil LocalizedString:@"Common.Ture"] otherButtonTitles: nil];
        [alert show];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
