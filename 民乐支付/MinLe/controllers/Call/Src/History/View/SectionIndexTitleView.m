//
//  SectionIndexTitleView.m
//  minlePay
//
//  Created by JP on 2017/10/25.
//  Copyright © 2017年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import "SectionIndexTitleView.h"

#define indexTitleWidth 15
#define indexTitleHeight 16

@interface SectionIndexTitleView ()

@property (nonatomic, strong) NSMutableArray *mutableIndexArray;
@property (nonatomic, strong) UIView *indexContainView;

@end

@implementation SectionIndexTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _mutableIndexArray = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withIndexArray:(NSArray *)indexArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _mutableIndexArray = [NSMutableArray arrayWithArray:indexArray];
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    float ww = indexTitleWidth;
    float hh = indexTitleHeight * (_mutableIndexArray.count+1);
    _indexContainView = [[UIView alloc] initWithFrame:CGRectMake((widths-ww)/2.f, (heights-hh)/2.f-30, ww, hh)];
    [self addSubview:_indexContainView];
    
    for (int i = 0; i < _mutableIndexArray.count; i++) {
        NSString *indexTitle = _mutableIndexArray[i];
        UIButton *indexBut = [UIButton buttonWithType:UIButtonTypeCustom];
        indexBut.frame = CGRectMake(0, indexTitleHeight*i, indexTitleWidth, indexTitleHeight);
        [indexBut setTitle:indexTitle forState:UIControlStateNormal];
        [indexBut setTitleColor:blueRGB forState:UIControlStateNormal];
        indexBut.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        indexBut.tag = i+1;
        [indexBut addTarget:self action:@selector(indexAction:) forControlEvents:UIControlEventTouchUpInside];
        [_indexContainView addSubview:indexBut];
    }
}

- (void)updataUI:(NSArray *)sectionIndexArray
{
    _mutableIndexArray = [NSMutableArray arrayWithArray:sectionIndexArray];
    [_indexContainView removeFromSuperview];
    [self initUI];
}

- (void)indexAction:(UIButton *)sender
{
    NSLog(@"点击了通讯录%@",(_mutableIndexArray[sender.tag-1] ? _mutableIndexArray[sender.tag-1] : @"出错啦"));
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollTableSectionWithSectionIndex:)]) {
        [self.delegate scrollTableSectionWithSectionIndex:sender.tag];
    }
}

@end



