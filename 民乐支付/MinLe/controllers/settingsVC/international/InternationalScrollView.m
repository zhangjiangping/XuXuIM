//
//  InternationalScrollView.m
//  民乐支付
//
//  Created by JP on 2017/4/11.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import "InternationalScrollView.h"
#import "BaseLayerView.h"

@interface InternationalScrollView () <UITextFieldDelegate>
@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, strong) NSArray *textDetailArray;
@property (nonatomic, strong) BaseLayerView *layerView;
@property (nonatomic, strong) UIView *shuomingView;
@end

@implementation InternationalScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = NO;
        _textArray = @[[CommenUtil LocalizedString:@"International.Region"],
                       [CommenUtil LocalizedString:@"International.Money"],
                       [CommenUtil LocalizedString:@"International.Currency"],
                       [CommenUtil LocalizedString:@"International.CreditCardType"]];
        _textDetailArray = @[[CommenUtil LocalizedString:@"International.HongKong"],
                             [CommenUtil LocalizedString:@"International.EnterCreditCardMoney"],
                             [CommenUtil LocalizedString:@"International.HongKongDollars"],
                             [CommenUtil LocalizedString:@"International.Unionpay"]];
        
        self.contentSize = CGSizeMake(CGRectGetWidth(self.frame), _textArray.count*(42+40)+42);
        
        [self addSubview:self.layerView];
        [self addSubview:self.shuomingView];
    }
    return self;
}

- (BaseLayerView *)layerView
{
    if (!_layerView) {
        _layerView = [[BaseLayerView alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.frame)-30, _textArray.count*(20+40)+20)];
        
        for (int i = 0; i < _textArray.count; i++) {
            UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(15, (20+40)*i+20, CGRectGetWidth(_layerView.frame)-30, 40)];
            but.layer.borderWidth = 1;
            but.layer.borderColor = [UIColor lightGrayColor].CGColor;
            but.layer.cornerRadius = 5;
            [_layerView addSubview:but];
            
            float textWidth = [CommenUtil getWidthWithContent:_textArray[i] height:CGRectGetHeight(but.frame) font:17];
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, textWidth, CGRectGetHeight(but.frame))];
            lable.text = _textArray[i];
            lable.font = FT(17);
            [but addSubview:lable];
            
            float textDetailWidth = [CommenUtil getWidthWithContent:_textDetailArray[i] height:40 font:17];
            if (i == 0) {
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(but.frame)-34-15, (CGRectGetHeight(but.frame)-22.5)/2, 34, 22.5)];
                img.clipsToBounds = YES;
                img.image = [UIImage imageNamed:@"HK"];
                [but addSubview:img];
                
                UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(img.frame)-10-textDetailWidth, 0, textDetailWidth, CGRectGetHeight(but.frame))];
                lable.text = _textDetailArray[i];
                lable.font = FT(17);
                [but addSubview:lable];
            } else if (i == 1) {
                _moneyField = [[InterTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lable.frame)+10, 0, CGRectGetWidth(but.frame)-15-CGRectGetMaxX(lable.frame)-10, CGRectGetHeight(but.frame))];
                _moneyField.placeholder = _textDetailArray[i];
                _moneyField.textAlignment = NSTextAlignmentRight;
                _moneyField.keyboardType = UIKeyboardTypeDecimalPad;
                _moneyField.delegate = self;
                [but addSubview:_moneyField];
            } else {
                UILabel *detailLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(but.frame)-15-textDetailWidth, 0, textDetailWidth, CGRectGetHeight(but.frame))];
                detailLable.text = _textDetailArray[i];
                detailLable.font = FT(17);
                [but addSubview:detailLable];
            }
        }
    }
    return _layerView;
}

- (UIView *)shuomingView
{
    if (!_shuomingView) {
        NSString *tishiStr = [CommenUtil LocalizedString:@"International.PromptMsg"];
        float tishiHeight = [CommenUtil getTxtHeight:tishiStr forContentWidth:widths-30 fotFontSize:15];
        _shuomingView = [[UIView alloc] init];
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            _shuomingView.frame = CGRectMake(15, CGRectGetMaxY(self.layerView.frame)+5, widths-30, 20+tishiHeight);
        } else {
            _shuomingView.frame = CGRectMake(15, CGRectGetMaxY(self.layerView.frame)+35, widths-30, 20+tishiHeight);
        }
        UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
        lable1.text = [NSString stringWithFormat:@"%@：",[CommenUtil LocalizedString:@"Permission.WarmPrompt"]];
        lable1.font = FT(15);
        lable1.alpha = 0.5;
        [_shuomingView addSubview:lable1];
        
        UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, CGRectGetWidth(self.shuomingView.frame), tishiHeight)];
        lable2.text = tishiStr;
        lable2.font = FT(15);
        lable2.alpha = 0.5;
        lable2.numberOfLines = 0;
        [_shuomingView addSubview:lable2];
    }
    return _shuomingView;
}

@end










