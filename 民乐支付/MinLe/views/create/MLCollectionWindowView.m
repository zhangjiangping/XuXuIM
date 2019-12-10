//
//  MLCollectionWindowView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/1.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLCollectionWindowView.h"

#define layerHeight 415.5
#define tableHeight 335

#define layerHeight2 225.5
#define tableHeight2 145

@interface MLCollectionWindowView () <UITableViewDelegate,UITableViewDataSource>
{
    NSString *tStr;
    float rowHeight;
}
@property (nonatomic, strong) UILabel *lable;
@property (nonatomic, strong) UIView *xianView1;

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *typeArray;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MLCollectionWindowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        rowHeight = 75;
        [self addSubview:self.layerView];
        [self addSubview:self.cancelBut];
    }
    return self;
}

//数据更换更新视图
- (void)updataTableView:(NSArray *)dataArray withType:(NSString *)type
{
    if (dataArray.count > 2) {
        tStr = @"T1";
        _typeArray = @[@"API_ZFBQRCODE",@"API_WXQRCODE",@"API_QQQRCODE",@"API_JDQRCODE",@"API_BDQRCODE",MLSaoMa];
        _layerView.frame = CGRectMake(35, (heights-layerHeight)/2-20, widths-70, layerHeight);
        _table.frame = CGRectMake(0, layerHeight-tableHeight, CGRectGetWidth(self.layerView.frame), tableHeight);
        rowHeight = (float)tableHeight / (dataArray.count);
    } else {
        tStr = @"T0";
        _typeArray = @[@"02",@"01"];
        _layerView.frame = CGRectMake(35, (heights-layerHeight2)/2-20, widths-70, layerHeight2);
        _table.frame = CGRectMake(0, layerHeight2-tableHeight2, CGRectGetWidth(self.layerView.frame), tableHeight2);
        rowHeight = (float)tableHeight2 / (dataArray.count);
    }
    _dataArray = dataArray;
    [_table reloadData];
}

//给cell赋值
- (void)setModel:(NSArray *)modelArray withCell:(UITableViewCell *)cell
{
    UIImageView *tagImg = [cell.contentView viewWithTag:111];
    tagImg.frame = CGRectMake((CGRectGetWidth(self.layerView.frame)-150)/2, (rowHeight-35)/2, 35, 35);
    tagImg.image = [UIImage imageNamed:modelArray[0]];
    
    UILabel *taglable = [cell.contentView viewWithTag:222];
    taglable.frame = CGRectMake(CGRectGetMaxX(tagImg.frame)+15, 0, 100, rowHeight);
    taglable.text = modelArray[1];
}

#pragma mark - 数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        UIImageView *image = [[UIImageView alloc] init];
        image.clipsToBounds = YES;
        image.tag = 111;
        [cell.contentView addSubview:image];
        
        UILabel *lable = [[UILabel alloc] init];
        lable.tag = 222;
        [cell.contentView addSubview:lable];
    }
    [self setModel:self.dataArray[indexPath.section] withCell:cell];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.delegate didSelectedWithType:_typeArray[indexPath.section] withTTtype:tStr];
}

- (BaseLayerView *)layerView
{
    if (!_layerView) {
        _layerView = [[BaseLayerView alloc] initWithFrame:CGRectMake(35,(heights-layerHeight)/2-20, widths-70, layerHeight)];
        [_layerView addSubview:self.lable];
        [_layerView addSubview:self.moneyLable];
        [_layerView addSubview:self.xianView1];
        [_layerView addSubview:self.table];
    }
    return _layerView;
}

- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.xianView1.frame), CGRectGetWidth(self.layerView.frame), layerHeight-tableHeight) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.tableFooterView = [UIView new];
        _table.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _table.layer.cornerRadius = 5;
        _table.layer.masksToBounds = YES;
    }
    return _table;
}

- (UIButton *)cancelBut
{
    if (!_cancelBut) {
        _cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBut.frame = CGRectMake((widths-42)/2, heights-42-20, 42, 42);
        [_cancelBut setImage:[UIImage imageNamed:@"zhifuquxiao"] forState:UIControlStateNormal];
    }
    return _cancelBut;
}

- (UILabel *)lable
{
    if (!_lable) {
        _lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, CGRectGetWidth(self.layerView.frame), 20)];
        _lable.text = [CommenUtil LocalizedString:@"Collection.CollectionMoney"];
        _lable.textAlignment = NSTextAlignmentCenter;
    }
    return _lable;
}

- (UILabel *)moneyLable
{
    if (!_moneyLable) {
        _moneyLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lable.frame)+10, CGRectGetWidth(self.layerView.frame), 20)];
        _moneyLable.textColor = [UIColor orangeColor];
        _moneyLable.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLable;
}

- (UIView *)xianView1
{
    if (!_xianView1) {
        _xianView1 = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.moneyLable.frame)+15, CGRectGetWidth(self.layerView.frame)-30, 0.5)];
        _xianView1.backgroundColor = [UIColor lightGrayColor];
        _xianView1.alpha = 0.5;
    }
    return _xianView1;
}

- (void)show
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.x = 0;
        self.frame = frame;
    }];
}

- (void)hiden
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.x = -1000;
        self.frame = frame;
    }];
}

@end













