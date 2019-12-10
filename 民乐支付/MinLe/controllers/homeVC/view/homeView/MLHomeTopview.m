//
//  MLHomeTopview.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/19.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLHomeTopview.h"
#import "BaseWebViewController.h"

@interface MLHomeTopview ()
{
    float lineWidth;
    float leftWidth;
    float padding;
    float imgWidth;
    float imgButtonWidth;
    float instructionsWidth;
    float rightWidth;
    
}
@property (nonatomic, strong) UILabel *todayMsgLable;
@property (nonatomic, strong) UILabel *integralMsgLable;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *instructionsBut;

@end

@implementation MLHomeTopview

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(0, 134, 219);
        
        lineWidth = OnePointHeight;
        padding = 10;
        leftWidth = (widths-padding*4-lineWidth)/2;
        imgWidth = 24;
        imgButtonWidth = 50;
        instructionsWidth = [CommenUtil getWidthWithContent:[CommenUtil LocalizedString:@"Home.Integral"] height:30 font:20];
        
        [self addSubview:self.lineView];
        
        [self addSubview:self.todayMsgLable];
        [self addSubview:self.moneyLable];
        
        [self addSubview:self.integralMsgLable];
        [self addSubview:self.instructionsBut];
        [self addSubview:self.integralLable];
    }
    return self;
}

#pragma mark - Getter

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake((widths-lineWidth)/2, (heights-100)/2, lineWidth, 100)];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    return _lineView;
}

- (UILabel *)todayMsgLable
{
    if (!_todayMsgLable) {
        _todayMsgLable = [[UILabel alloc] initWithFrame:CGRectMake(padding, 50, leftWidth, 30)];
        _todayMsgLable.text = [CommenUtil LocalizedString:@"Home.TodaysTransaction"];
        _todayMsgLable.textColor = [UIColor whiteColor];
        _todayMsgLable.font = FT(20);
        _todayMsgLable.textAlignment = NSTextAlignmentCenter;
    }
    return _todayMsgLable;
}

- (UICountingLabel *)moneyLable
{
    if (!_moneyLable) {
        _moneyLable = [[UICountingLabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(self.todayMsgLable.frame), leftWidth, heights-CGRectGetMaxY(self.todayMsgLable.frame)-20)];
        _moneyLable.adjustsFontSizeToFitWidth = YES;
        _moneyLable.contentMode = UIViewContentModeScaleAspectFill;
        _moneyLable.textAlignment = NSTextAlignmentCenter;
        _moneyLable.textColor = [UIColor whiteColor];
        _moneyLable.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:40];
        _moneyLable.layer.shadowOffset = CGSizeMake(0, 1); //设置阴影的偏移量
        _moneyLable.layer.shadowRadius = 0.5;  //设置阴影的半径
        _moneyLable.layer.shadowColor = [UIColor blackColor].CGColor; //设置阴影的颜色为黑色
        _moneyLable.layer.shadowOpacity = 0.25;
        
        //设置格式
        _moneyLable.format = @"%.2f";
        //设置分隔符样式
        //_moneyLable.positiveFormat = @"###,##0.00";
    }
    return _moneyLable;
}

- (UILabel *)integralMsgLable
{
    if (!_integralMsgLable) {
        float x = CGRectGetMaxX(self.lineView.frame)+padding+(leftWidth-instructionsWidth-imgWidth-padding)/2;
        _integralMsgLable = [[UILabel alloc] initWithFrame:CGRectMake(x, 50, instructionsWidth, 30)];
        _integralMsgLable.text = [CommenUtil LocalizedString:@"Home.Integral"];
        _integralMsgLable.textColor = [UIColor whiteColor];
        _integralMsgLable.font = FT(20);
        _integralMsgLable.textAlignment = NSTextAlignmentCenter;
    }
    return _integralMsgLable;
}

- (UIButton *)instructionsBut
{
    if (!_instructionsBut) {
        _instructionsBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _instructionsBut.frame = CGRectMake(CGRectGetMaxX(self.integralMsgLable.frame), 30, imgButtonWidth, imgButtonWidth);
        [_instructionsBut addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
        
        float y = imgButtonWidth-CGRectGetHeight(self.integralMsgLable.frame)+(CGRectGetHeight(self.integralMsgLable.frame)-imgWidth)/2;
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(padding, y, imgWidth, imgWidth)];
        img.image = [UIImage imageNamed:@"icon-help"];
        img.clipsToBounds = YES;
        [_instructionsBut addSubview:img];
    }
    return _instructionsBut;
}

- (UICountingLabel *)integralLable
{
    if (!_integralLable) {
        float x = CGRectGetMaxX(self.lineView.frame)+padding;
        _integralLable = [[UICountingLabel alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(self.integralMsgLable.frame), leftWidth, heights-CGRectGetMaxY(self.integralMsgLable.frame)-20)];
        _integralLable.adjustsFontSizeToFitWidth = YES;
        _integralLable.contentMode = UIViewContentModeScaleAspectFill;
        _integralLable.textAlignment = NSTextAlignmentCenter;
        _integralLable.textColor = [UIColor whiteColor];
        _integralLable.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:36];
        _integralLable.layer.shadowOffset = CGSizeMake(0, 1); //设置阴影的偏移量
        _integralLable.layer.shadowRadius = 0.5;  //设置阴影的半径
        _integralLable.layer.shadowColor = [UIColor blackColor].CGColor; //设置阴影的颜色为黑色
        _integralLable.layer.shadowOpacity = 0.25;
        _integralLable.text = @"0";
        //设置格式
        //_integralLable.format = @"%.2f";
        //设置分隔符样式
        //_integralLable = @"###,##0.00";
    }
    return _integralLable;
}

- (void)pushAction
{
    BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
    webVC.titleStr = [CommenUtil LocalizedString:@"Home.IntegralGuidelines"];
    webVC.urlStr = [NSString stringWithFormat:@"%@5",ApiH5URL];
    [self.viewController.navigationController pushViewController:webVC animated:YES];
}

@end
