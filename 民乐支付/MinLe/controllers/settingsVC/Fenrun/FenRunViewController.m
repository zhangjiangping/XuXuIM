//
//  FenRunViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 2017/2/16.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import "FenRunViewController.h"
#import "NSString+MyString.h"

#import "DataModel.h"
#import "Data.h"
#import "PickerWindowView.h"
#import "UICountingLabel.h"

@interface FenRunViewController () <UITableViewDelegate,UITableViewDataSource,SelectedPickerRowDelegate>
{
    NSMutableString *yearStr;
    NSMutableArray *yearArray;
    NSInteger pickRow;
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIView *moneyView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *messageView;

@property (nonatomic, strong) UILabel *yearLable;
@property (nonatomic, strong) UILabel *fenrunLable;

@property (nonatomic, strong) UIButton *selectedBut;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) PickerWindowView *pickWindowView;

@end

@implementation FenRunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUI
{
    _dataArray = [[NSMutableArray alloc] init];
    NSString *dateString = [NSString dataFormatter];
    yearStr = [[dateString substringWithRange:NSMakeRange(0, 4)] mutableCopy];
    
    yearArray = [[NSMutableArray alloc] init];
    
    [self getYearArray];
    
    [self.view addSubview:self.naView];
    [self.view addSubview:self.moneyView];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.table];
    [self.view addSubview:self.pickWindowView];
    
    [self request];
}

//获取最新5个年份的数组
- (void)getYearArray
{
    int yearLen = [yearStr intValue];
    for (int i = 0; i < 5; i++) {
        int a = 0;
        a = yearLen - i;
        NSString *str = [NSString stringWithFormat:@"%d",a];
        [yearArray addObject:str];
    }
    NSLog(@"%@",yearArray);
}

- (void)request
{
    if (self.dataArray.count) {
        [self.dataArray removeAllObjects];
    }
    NSDictionary *dic = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"year":yearStr};
    [[MCNetWorking sharedInstance] createPostWithUrlString:commissionListURL withParameter:dic withComplection:^(NSDictionary *responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            DataModel *dataModel = [DataModel modelWithDictionary:responseObject];
            _yearLable.text = [NSString stringWithFormat:@"%@年",dataModel.year];
            _fenrunLable.text = [NSString stringWithFormat:@"%@ ￥%@",[CommenUtil LocalizedString:@"Me.FenRunTotalAmount"],dataModel.money];
            
            for (NSDictionary *dic in dataModel.data) {
                Data *model = [Data modelWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        } else {
            _yearLable.text = [NSString stringWithFormat:@"%@年",yearArray[pickRow]];
            _fenrunLable.text = [NSString stringWithFormat:@"%@ ￥00:00",[CommenUtil LocalizedString:@"Me.FenRunTotalAmount"]];
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
        }
        [self.table reloadData];
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}


#pragma mark - Action

- (void)logoutAction:(UIButton *)sender
{
    
}

- (void)dianAction:(UIButton *)sender
{
    
}

- (void)selectedAction:(UIButton *)sender
{
    self.pickWindowView.hidden = NO;
}

- (void)respondsToSureButton:(UIButton *)sender
{
    self.pickWindowView.hidden = YES;
    yearStr = [yearArray objectAtIndex:pickRow];
    [self request];
}

- (void)respondsToCancelButton:(UIButton *)sender
{
    self.pickWindowView.hidden = YES;
}

#pragma mark - picker delegate

- (void)selectedPickerRow:(NSInteger)row
{
    pickRow = row;
}

#pragma mark - Table 数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *fenrunCellid = @"fenrunCellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:fenrunCellid];
    Data *model = self.dataArray[indexPath.row];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:fenrunCellid];

        for (int i = 0; i < 3; i++) {
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(i*(screenWidth/3.0f), 0, screenWidth/3.0f, 66)];
            lable.tag = i+1;
            lable.textAlignment = NSTextAlignmentCenter;
            lable.adjustsFontSizeToFitWidth = YES;
            lable.contentMode = UIViewContentModeScaleAspectFill;
            
            [cell.contentView addSubview:lable];
        }
    }
    [self updataCell:cell withModel:model];
    return cell;
}

//更新cell视图
- (void)updataCell:(UITableViewCell *)cell withModel:(Data *)model
{
    UILabel *monthLable = [cell.contentView viewWithTag:1];
    UILabel *nameLable = [cell.contentView viewWithTag:2];
    UILabel *moneyLable = [cell.contentView viewWithTag:3];
    monthLable.text = [NSString stringWithFormat:@"%@%@",model.month,[CommenUtil LocalizedString:@"Month"]];
    nameLable.text = model.username;
    moneyLable.text = [NSString stringWithFormat:@"+%@",model.money];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

#pragma mark - getter

- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), screenWidth, screenHeight-CGRectGetMaxY(self.titleView.frame)) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.tableFooterView = [[UIView alloc] init];
    }
    return _table;
}

- (PickerWindowView *)pickWindowView
{
    if (!_pickWindowView) {
        _pickWindowView = [[PickerWindowView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        _pickWindowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _pickWindowView.delegate = self;
        _pickWindowView.yearArray = yearArray;
        [_pickWindowView.pickerView reloadAllComponents];
        
        [_pickWindowView.cancelBut addTarget:self action:@selector(respondsToCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        [_pickWindowView.tureBut addTarget:self action:@selector(respondsToSureButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _pickWindowView.hidden = YES;
    }
    return _pickWindowView;
}

- (UIView *)moneyView
{
    if (!_moneyView) {
        _moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, 50)];
        _yearLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 200, 20)];
        _yearLable.text = [NSString stringWithFormat:@"%@%@",yearStr,[CommenUtil LocalizedString:@"Years"]];
        _yearLable.font = FT(15);
        [_moneyView addSubview:_yearLable];
        
        _fenrunLable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_yearLable.frame), 300, 20)];
        _fenrunLable.font = FT(13);
        _fenrunLable.textColor = [UIColor colorWithWhite:0 alpha:0.5];
        _fenrunLable.adjustsFontSizeToFitWidth = yearStr;
        _fenrunLable.contentMode = UIViewContentModeScaleAspectFill;
        [_moneyView addSubview:_fenrunLable];
        
        _selectedBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedBut.frame = CGRectMake(CGRectGetWidth(_moneyView.frame)-(15+30+6+15*2), 0, 15+30+6+15*2, 50);
        [_selectedBut addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17.5, 15, 15)];
        img.clipsToBounds = yearStr;
        img.image = [UIImage imageNamed:@"choose"];
        [_selectedBut addSubview:img];
        
        UILabel *selecteLable = [[UILabel alloc] initWithFrame:CGRectMake(36, 0, 30, CGRectGetHeight(_selectedBut.frame))];
        selecteLable.text = [CommenUtil LocalizedString:@"Me.Screening"];
        selecteLable.textAlignment = NSTextAlignmentRight;
        selecteLable.font = FT(15);
        selecteLable.adjustsFontSizeToFitWidth = YES;
        selecteLable.contentMode = UIViewContentModeScaleAspectFill;
        [_selectedBut addSubview:selecteLable];

        [_moneyView addSubview:_selectedBut];
    }
    return _moneyView;
}

- (UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.moneyView.frame), screenWidth, 36)];
        _titleView.layer.borderWidth = 0.5;
        _titleView.layer.borderColor = [ColorsUtil colorWithHexString:@"#d3d3d3"].CGColor;
        _titleView.backgroundColor = [UIColor whiteColor];
        NSArray *arr = @[[CommenUtil LocalizedString:@"Me.MonthIn"],
                         [CommenUtil LocalizedString:@"Me.Agent"],
                         [CommenUtil LocalizedString:@"Me.FenRunMoney"]];
        for (int i = 0; i < arr.count; i++) {
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(i*(screenWidth/3.0f), 0, screenWidth/3.0f, 36)];
            lable.text = arr[i];
            lable.font = FT(14);
            lable.alpha = 0.5;
            lable.textAlignment = NSTextAlignmentCenter;
            [_titleView addSubview:lable];
        }
    }
    return _titleView;
}

//- (UIView *)messageView
//{
//    if (!_messageView) {
//        _messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, 30)];
//        _messageView.backgroundColor = [ColorsUtil colorWithHexString:@"#8e17e"];
//        
//        UIButton *logoutBut = [UIButton buttonWithType:UIButtonTypeCustom];
//        logoutBut.frame = CGRectMake(CGRectGetWidth(_messageView.frame)-48, 0, 48, 30);
//        [logoutBut addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//        UIImageView *logoutImg = [[UIImageView alloc] initWithFrame:CGRectMake(16, 7, 16, 16)];
//        logoutImg.image = [UIImage imageNamed:@"+"];
//        [logoutBut addSubview:logoutImg];
//        [_messageView addSubview:logoutBut];
//        
//        NSString *dianStr = @"点此认证";
//        CGFloat ww = [CommenUtil getWidthWithContent:dianStr height:30 font:14];
//        
//        UIButton *dianBut = [UIButton buttonWithType:UIButtonTypeCustom];
//        dianBut.frame = CGRectMake(CGRectGetMinX(logoutBut.frame)-ww, 0, ww, 30);
//        [dianBut setTitle:dianStr forState:UIControlStateNormal];
//        [dianBut setTitleColor:[ColorsUtil colorWithHexString:@"#e80300"] forState:UIControlStateNormal];
//        [dianBut addTarget:self action:@selector(dianAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//        UILabel *lineLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 26, CGRectGetWidth(dianBut.frame), 1)];
//        lineLable.backgroundColor = [ColorsUtil colorWithHexString:@"#e80300"];
//        [dianBut addSubview:lineLable];
//        
//        [_messageView addSubview:dianBut];
//        
//        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetMinX(dianBut.frame)-30, 30)];
//        lbl.text = @"您还未进行实名认证，不能进行此操作";
//        [_messageView addSubview:lbl];
//    }
//    return _messageView;
//}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Me.FenRunSettlement"]];
    }
    return _naView;
}

@end
