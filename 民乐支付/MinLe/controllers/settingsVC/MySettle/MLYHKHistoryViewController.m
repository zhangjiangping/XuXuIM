//
//  MLYHKHistoryViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 2017/3/1.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import "MLYHKHistoryViewController.h"
#import "MLAccountSettlementView.h"
#import "SVPullToRefresh.h"

@interface MLYHKHistoryViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSInteger offset;
    MBProgressHUD *hud;
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *typeArray;

@end

@implementation MLYHKHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUI
{
    offset = 1;
    _dataArray = [[NSMutableArray alloc] init];
    _typeArray = [[NSMutableArray alloc] init];
    [self.view addSubview:self.naView];
    [self.view addSubview:self.table];
    
    [self shangtiReload];
    
    hud = [[MBProgressHUD shareInstance] showLoding:[CommenUtil LocalizedString:@"Loading..."] showView:nil];
    [self request];
}

//上提加载
- (void)shangtiReload
{
    __weak MLYHKHistoryViewController *weakSelf = self;
    [self.table addInfiniteScrollingWithActionHandler:^{
        [weakSelf infinite];
    }];
}

//上提
- (void)infinite
{
    __weak MLYHKHistoryViewController *weakSelf = self;
    offset++;
    [weakSelf request];
}

//关闭上提刷新
- (void)endrefrech
{
    __weak MLYHKHistoryViewController *weakSelf = self;
    [weakSelf.table.infiniteScrollingView stopAnimating];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        [self endrefrech];
    }
}

//网络请求数据
- (void)request
{
    NSDictionary *dic = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"offset":[NSString stringWithFormat:@"%ld",offset],@"length":@"2"};
    [SharedApp.netWorking myPostWithUrlString:bankUpdateListURL withParameter:dic withComplection:^(NSDictionary *responseObject) {
        [hud hide:YES];
        if ([responseObject[@"status"] isEqual:@1]) {
            self.backGroundEmptyLable.hidden = YES;
            self.table.hidden = NO;
            NSArray *array = responseObject[@"data"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                NSArray *dataArray = @[[NSString stringWithFormat:@"%@", dic[@"bank_type"]],
                                       [NSString stringWithFormat:@"%@", dic[@"bank_name"]],
                                       [NSString stringWithFormat:@"%@", dic[@"bank_area"]],
                                       [NSString stringWithFormat:@"%@", dic[@"bank_branch"]],
                                       [NSString stringWithFormat:@"%@", dic[@"actual_name"]],
                                       [NSString stringWithFormat:@"%@", dic[@"bank_card"]],
                                       [NSString stringWithFormat:@"%@", dic[@"create_time"]],
                                       [NSString stringWithFormat:@"%@", dic[@"state"]]];
                
                NSArray *myArray = @[[CommenUtil LocalizedString:@"Authen.BankState"],
                                     [CommenUtil LocalizedString:@"Authen.OpenBank"],
                                     [CommenUtil LocalizedString:@"Authen.OpenCity"],
                                     [CommenUtil LocalizedString:@"Authen.OpenBranch"],
                                     [CommenUtil LocalizedString:@"Settle.OpenNick"],
                                     [CommenUtil LocalizedString:@"Settle.BankNumber"],
                                     [CommenUtil LocalizedString:@"Settle.ApplyDate"],
                                     [CommenUtil LocalizedString:@"Settle.State"]];
                NSArray *array = @[dataArray,myArray];
                
                [_typeArray addObject:[NSString stringWithFormat:@"%@", dic[@"state"]]];
                
                [_dataArray addObject:array];
            }
            [self.table reloadData];
        } else {
            self.table.hidden = YES;
            [self.view addSubview:self.backGroundEmptyLable];
            self.backGroundEmptyLable.hidden = NO;
            self.backGroundEmptyLable.text = [CommenUtil LocalizedString:@"Settle.NotHistory"];
        }
        [self endrefrech];
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        [hud hide:YES];
        [self endrefrech];
        NSLog(@"%@", error);
    }];
}

#pragma mark - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.contentView.backgroundColor = RGB(245, 246, 249);
        MLAccountSettlementView *settView = [[MLAccountSettlementView alloc] initWithFrame:CGRectMake(15, 20, screenWidth-30, 400) withType:_typeArray[indexPath.row] withDataArray:_dataArray[indexPath.row]];
        [cell.contentView addSubview:settView];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400+35;
}


#pragma mark - UI

- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.tableFooterView = [UIView new];
        _table.backgroundColor = RGB(245, 246, 249);
        
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _table;
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Settle.HistoryAccount"]];
    }
    return _naView;
}

@end
