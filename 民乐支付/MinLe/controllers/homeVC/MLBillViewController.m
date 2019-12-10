//
//  MLBillViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/31.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLBillViewController.h"
#import "DataModel.h"
#import "Data.h"

#import "MLBillCell.h"
#import "SVPullToRefresh.h"
#import "NSString+MyString.h"

@interface MLBillViewController () <UITableViewDelegate,UITableViewDataSource>
{
    int offset;//分页偏移量
    NSString *currentTime;
    DataModel *datModel;
    MBProgressHUD *hud;
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *todayArray;
@property (nonatomic, strong) NSMutableArray *yesterdayArray;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UILabel *noDataView;//没有数据时候显示的view
@end

@implementation MLBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self shangtiReload];
}

- (void)setUI
{
    offset = 1;
    _todayArray = [[NSMutableArray alloc] init];
    _yesterdayArray = [[NSMutableArray alloc] init];
    _dataArray = [NSArray array];
    NSString *dateString = [NSString dataFormatter];
    currentTime = [dateString substringWithRange:NSMakeRange(8, 2)];
    
    [self.view addSubview:self.naView];
    [self.view addSubview:self.table];
    hud = [[MBProgressHUD shareInstance] showLoding:[CommenUtil LocalizedString:@"Loading..."] showView:nil];
    [self request];
}

//上提加载
- (void)shangtiReload
{
    __weak MLBillViewController *weakSelf = self;
    [self.table addInfiniteScrollingWithActionHandler:^{
        [weakSelf infinite];
    }];
}

//上提
- (void)infinite
{
    __weak MLBillViewController *weakSelf = self;
    offset++;
    [weakSelf request];
}

//关闭上提刷新
- (void)endrefrech
{
    __weak MLBillViewController *weakSelf = self;
    [weakSelf.table.infiniteScrollingView stopAnimating];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        [self endrefrech];
    }
}

- (void)request
{
    [[MCNetWorking sharedInstance] myPostWithUrlString:billing_recordURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"offset":[NSString stringWithFormat:@"%d",offset]} withComplection:^(id responseObject) {
        if (offset > 1  &&  [responseObject[@"data"] count] == 0) {
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Bill.NoMoreBillsData"] showView:nil];
        } else if (offset == 1 && [responseObject[@"data"] count] == 0) {
            [self.view addSubview:self.noDataView];
        } else {
            [self.noDataView removeFromSuperview];
        }
        if ([responseObject[@"status"] isEqual:@1]) {
            datModel = [DataModel modelWithDictionary:responseObject];
            for (NSDictionary *dic in datModel.data) {
                Data *model = [Data modelWithDictionary:dic];
                NSString *str = [model.create_time substringWithRange:NSMakeRange(8, 2)];
                if ([currentTime isEqualToString:str]) {
                    [_todayArray addObject:model];
                } else {
                    [_yesterdayArray addObject:model];
                }
            }
            self.dataArray = @[_todayArray,_yesterdayArray];
            [self.table reloadData];
        }
        [hud hide:YES];
        [self endrefrech];
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@", error);
        [hud hide:YES];
        [self endrefrech];
    }];
}

- (UILabel *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64)];
        _noDataView.backgroundColor = RGB(241, 241, 241);
        _noDataView.text = [CommenUtil LocalizedString:@"Bill.EmptyMsg"];
        _noDataView.font = [UIFont boldSystemFontOfSize:18];
        _noDataView.numberOfLines = 0;
        _noDataView.textAlignment = NSTextAlignmentCenter;
    }
    return _noDataView;
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Bill.MyBill"]];
    }
    return _naView;
}

- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, widthss, heightss-64) style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.tableFooterView = [[UIView alloc] init];
        _table.estimatedRowHeight = 100.5;
        [_table registerClass:[MLBillCell class] forCellReuseIdentifier:@"MLBillCell"];
    }
    return _table;
}

#pragma mark - 数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MLBillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MLBillCell" forIndexPath:indexPath];
    [cell setModel:_dataArray[indexPath.section][indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //一定要加上分割线的高度
    return 100+0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.dataArray[section] count] == 0) {
        return 0.1;
    } else {
        return 37;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.dataArray[section] count] == 0) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0.1)];
    } else {
        UIView *todayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 37)];
        UILabel *todayLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 37)];
        UILabel *maxMoneyLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(todayLable.frame)+10, 0, screenWidth-15-CGRectGetMaxX(todayLable.frame)-10, 37)];
        maxMoneyLable.textAlignment = NSTextAlignmentRight;
        if (section == 0) {
            todayLable.text = [CommenUtil LocalizedString:@"Today"];
            if (datModel) {
                maxMoneyLable.text = [NSString stringWithFormat:@"%@： ￥%@", [CommenUtil LocalizedString:@"Common.TotalAmount"],datModel.today];
            }
        } else {
            todayLable.text = [CommenUtil LocalizedString:@"Yesterday"];
            if (datModel) {
                maxMoneyLable.text = [NSString stringWithFormat:@"%@： ￥%@", [CommenUtil LocalizedString:@"Common.TotalAmount"],datModel.yesterday];
            }
        }
        todayLable.font = FT(16);
        maxMoneyLable.font = FT(14);
        [todayView addSubview:todayLable];
        [todayView addSubview:maxMoneyLable];
        return todayView;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0.1)];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
