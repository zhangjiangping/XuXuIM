//
//  PickerWindowView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 2017/2/17.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import "PickerWindowView.h"

@interface PickerWindowView () <UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIView *pickTitleView;
@end

@implementation PickerWindowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        [self addSubview:self.pickTitleView];
        [self addSubview:self.pickerView];
    }
    return self;
}

#pragma mark - getter

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight-200, screenWidth, 200)];
        // 显示选中框
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

- (UIView *)pickTitleView
{
    if (!_pickTitleView) {
        _pickTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-240, screenWidth, 40)];
        _pickTitleView.backgroundColor = [UIColor whiteColor];
        
        [_pickTitleView addSubview:self.tureBut];
        [_pickTitleView addSubview:self.cancelBut];
        
        _pickTitleView.layer.borderWidth = 0.5;
        _pickTitleView.layer.borderColor = [ColorsUtil colorWithHexString:@"#d3d3d3"].CGColor;
    }
    return _pickTitleView;
}

- (UIButton *)tureBut
{
    if (!_tureBut) {
        _tureBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _tureBut.frame = CGRectMake(screenWidth/2, 0, screenWidth/2-15, 40);
        // 设置标题对齐方式请1
        _tureBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_tureBut setTitle:[CommenUtil LocalizedString:@"Common.Ture"] forState:UIControlStateNormal];
        [_tureBut setTitleColor:[ColorsUtil colorWithHexString:@"#008ada"] forState:UIControlStateNormal];
        [_tureBut setTitleColor:blueRGB forState:UIControlStateHighlighted];
    }
    return _tureBut;
}

- (UIButton *)cancelBut
{
    if (!_cancelBut) {
        _cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBut.frame = CGRectMake(15, 0, screenWidth/2-15, 40);
        // 设置标题对齐方式请1
        _cancelBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_cancelBut setTitle:[CommenUtil LocalizedString:@"Common.Cancle"] forState:UIControlStateNormal];
        [_cancelBut setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    return _cancelBut;
}

#pragma Mark -- UIPickerViewDataSource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.yearArray.count;
}

#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 180;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.delegate selectedPickerRow:row];
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.yearArray objectAtIndex:row];
}

@end
