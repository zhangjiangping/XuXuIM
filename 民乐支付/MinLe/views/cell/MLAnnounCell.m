//
//  MLAnnounCell.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/28.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLAnnounCell.h"
#import "UIImageView+MyImageView.h"
#import "UIImage+MLMyimage.h"

@implementation MLAnnounCell

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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
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

- (void)initUI
{
    timeLable = [[UILabel alloc] init];
    timeLable.backgroundColor = [UIColor lightGrayColor];
    timeLable.layer.cornerRadius = 5;
    timeLable.clipsToBounds = YES;
    timeLable.textColor = [UIColor whiteColor];
    timeLable.font = FT(13);
    timeLable.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:timeLable];
    
    layerView = [[BaseLayerView alloc] init];
    [self.contentView addSubview:layerView];
    
    lable = [[UILabel alloc] init];
    [layerView addSubview:lable];
    
    lable2 = [[UILabel alloc] init];
    lable2.font = FT(13);
    lable2.alpha = 0.5;
    [layerView addSubview:lable2];
    
    img = [[UIImageView alloc] init];
    img.clipsToBounds = YES;
    img.contentMode = UIViewContentModeScaleAspectFill;
    [layerView addSubview:img];
    
    lable3 = [[UILabel alloc] init];
    lable3.alpha = 0.5;
    [layerView addSubview:lable3];
    
    lable4 = [[UILabel alloc] init];
    lable4.font = FT(15);
    lable4.alpha = 0.7;
    [layerView addSubview:lable4];
    
    jiantouImg = [[UIImageView alloc] init];
    jiantouImg.clipsToBounds = YES;
    [layerView addSubview:jiantouImg];
}

- (void)setModel:(Data *)model
{
    _model = model;

    timeLable.frame = CGRectMake((screenWidth-150)/2, 20, 150, 25);
    layerView.frame = CGRectMake(15, 65, screenWidth-30, cellHeight-65);
    textHeight = [CommenUtil getHeightWithContent:model.title width:CGRectGetWidth(layerView.frame)-20 font:17];
    lable.frame = CGRectMake(10, 10, CGRectGetWidth(layerView.frame)-20, textHeight);
    lable2.frame = CGRectMake(10, CGRectGetMaxY(lable.frame)+10, 200, 15);

    if (![self.model.poster isEqualToString:@""]) {
        NSString *pngStr = [self.model.poster substringWithRange:NSMakeRange(self.model.poster.length-4, 4)];
        img.hidden = NO;
        if (![pngStr isEqualToString:@".gif"]) {
            UIImage *image = [self getImgWithImgStr:model.poster];
            imgHeight = image.size.height;
            if (imgHeight < 200) {
                imgWidth = [self getImgSize:image.size withImgViewHeight:imgHeight];
            } else {
                imgHeight = 200;
                imgWidth = [self getImgSize:image.size withImgViewHeight:200];
            }
            if (imgWidth > CGRectGetWidth(layerView.frame)-20) imgWidth = CGRectGetWidth(layerView.frame)-20;
            img.frame = CGRectMake(10+(CGRectGetWidth(layerView.frame)-20-imgWidth)/2, CGRectGetMaxY(lable2.frame)+10, imgWidth, imgHeight);
            img.image = image;
        } else {
            imgHeight = 200;
            UIImage *defaultImg = [UIImage imageNamed:@"announDefault"];
            imgWidth = [self getImgSize:defaultImg.size withImgViewHeight:imgHeight];
            if (imgWidth > CGRectGetWidth(layerView.frame)-20) {
                imgWidth = CGRectGetWidth(layerView.frame)-20;
            }
            img.frame = CGRectMake(10+(CGRectGetWidth(layerView.frame)-20-imgWidth)/2, CGRectGetMaxY(lable2.frame)+10, imgWidth, imgHeight);
            img.image = defaultImg;
        }
        lable3.frame = CGRectMake(10, CGRectGetMaxY(img.frame)+15, CGRectGetWidth(layerView.frame)-20, 0.5);
    } else {
        img.hidden = YES;
        lable3.frame = CGRectMake(10, CGRectGetHeight(layerView.frame)-38, CGRectGetWidth(layerView.frame)-20, 0.5);
    }
    lable4.frame = CGRectMake(10, CGRectGetHeight(layerView.frame)-35, 100, 30);
    jiantouImg.frame = CGRectMake(CGRectGetWidth(layerView.frame)-20, CGRectGetHeight(layerView.frame)-27.5, 15, 15);
    
    timeLable.text = model.zh_time;
    lable.text = model.title;
    lable2.text = model.create_time;
    lable3.backgroundColor = [UIColor blackColor];
    lable4.text = [CommenUtil LocalizedString:@"Center.ImmediatelyCheck"];
    jiantouImg.image = [UIImage imageNamed:@"lijichakan"];
}

- (float)getImgSize:(CGSize)size withImgViewHeight:(CGFloat)imgViewHeight
{
    CGFloat imgW = size.width;
    CGFloat imgH = size.height;
    CGFloat srcRatio = imgH / imgW;
    CGSize csize = CGSizeMake(imgViewHeight / srcRatio, imgViewHeight);
    return csize.width;
}


- (UIImage *)getImgWithImgStr:(NSString *)imgStr
{
    NSString *str = [NSString stringWithFormat:@"%@%@",MLMLJK,imgStr];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
    UIImage *image = [UIImage imageWithData:data];
    
    //UIImage *newImg = [image imageCompress:image targetSize:CGSizeMake(CGRectGetWidth(layerView.frame)-20, 200)];
        
    return image;
}

- (CGFloat)getCellHeight
{
    if ([self.model.poster isEqualToString:@""]) {
        return 65+10+textHeight+25+15.5+45;
    } else {
        return imgHeight+65+30+25+15.5+45;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
