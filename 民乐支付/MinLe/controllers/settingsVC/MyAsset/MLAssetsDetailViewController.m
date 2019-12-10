//
//  MLAssetsDetailViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/2.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLAssetsDetailViewController.h"
#import "DataModel.h"
#import "Data.h"

#import "MLAssetsDetailCell.h"
#import "SVPullToRefresh.h"

@interface MLAssetsDetailViewController () <UITableViewDelegate,UITableViewDataSource>
{
    int offset;//分页偏移量
    MBProgressHUD *hud;
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MLAssetsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self shangtiReload];
}

- (void)setUI
{
    offset = 1;
    _dataArray = [[NSMutableArray alloc] init];
    hud = [[MBProgressHUD shareInstance] showLoding:[CommenUtil LocalizedString:@"Loading..."] showView:nil];
    [self request];
    [self.view addSubview:self.naView];
    [self.view addSubview:self.table];
}

//上提加载
- (void)shangtiReload
{
    __weak MLAssetsDetailViewController *weakSelf = self;
    [self.table addInfiniteScrollingWithActionHandler:^{
        [weakSelf infinite];
    }];
}

//上提
- (void)infinite
{
    __weak MLAssetsDetailViewController *weakSelf = self;
    offset++;
    [weakSelf request];
}

//关闭上提刷新
- (void)endrefrech
{
    __weak MLAssetsDetailViewController *weakSelf = self;
    [weakSelf.table.infiniteScrollingView stopAnimating];
    
}

- (void)request
{
    [[MCNetWorking sharedInstance] myPostWithUrlString:auditURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"offset":[NSString stringWithFormat:@"%d",offset]} withComplection:^(id responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            self.backGroundEmptyLable.hidden = YES;
            self.table.hidden = NO;
            DataModel *datModel = [DataModel modelWithDictionary:responseObject];
            if (datModel.dataArray.count > 0) {
                [_dataArray addObjectsFromArray:datModel.dataArray];
                [self.table reloadData];
            } else {
                if (offset > 1) {
                    [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NotMoreData"] showView:nil];
                } else {
                    self.table.hidden = YES;
                    [self.view addSubview:self.backGroundEmptyLable];
                    self.backGroundEmptyLable.hidden = NO;
                    self.backGroundEmptyLable.text = [CommenUtil LocalizedString:@"Asset.NotRecord"];
                }
            }
        } else {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
        }
        [hud hide:YES];
        [self endrefrech];
    } withFailure:^(NSError *error) {
        NSLog(@"%@", error);
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        [hud hide:YES];
        [self endrefrech];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        [self endrefrech];
    }
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Asset.Record"]];
    }
    return _naView;
}

- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, widthss, heightss-64) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.estimatedRowHeight = 75.5;
        _table.tableFooterView = [[UIView alloc] init];
        [_table registerClass:[MLAssetsDetailCell class] forCellReuseIdentifier:@"MLAssetsDetailCell"];
    }
    return _table;
}

#pragma mark - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MLAssetsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MLAssetsDetailCell" forIndexPath:indexPath];
    [cell setModel:_dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75+0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
