//
//  MLNewsViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/28.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLNewsViewController.h"
#import "BaseWebViewController.h"
#import "DataModel.h"
#import "Data.h"

#import "MLNewsCell.h"
#import "SVPullToRefresh.h"

@interface MLNewsViewController () <UITableViewDelegate,UITableViewDataSource>
{
    int offset;
    MBProgressHUD *hud;
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MLNewsViewController

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
    __weak MLNewsViewController *weakSelf = self;
    [self.table addInfiniteScrollingWithActionHandler:^{
        [weakSelf infinite];
    }];
}

//上提
- (void)infinite
{
    __weak MLNewsViewController *weakSelf = self;
    offset++;
    [weakSelf request];
}

//关闭上提刷新
- (void)endrefrech
{
    __weak MLNewsViewController *weakSelf = self;
    [weakSelf.table.infiniteScrollingView stopAnimating];
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Center.News"]];
        [_naView.but addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _naView;
}

- (void)backAction:(UIButton *)sender
{
    [self.newsDelegate BackAction];
}

- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, widthss, heightss-64) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.tableFooterView = [[UIView alloc] init];
        [_table registerClass:[MLNewsCell class] forCellReuseIdentifier:@"MLNewsCell"];
    }
    return _table;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        [self endrefrech];
    }
}

- (void)request
{
    [[MCNetWorking sharedInstance] myPostWithUrlString:news_listURL withParameter:@{@"offset":[NSString stringWithFormat:@"%d", offset],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]} withComplection:^(id responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            DataModel *dataModel = [DataModel modelWithDictionary:responseObject];
            if (dataModel.data.count == 0) {
                if (offset > 1) {
                    [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NotMoreData"] showView:nil];
                } else {
                    self.table.hidden = YES;
                    [self.view addSubview:self.backGroundEmptyLable];
                    self.backGroundEmptyLable.hidden = NO;
                    self.backGroundEmptyLable.text = [CommenUtil LocalizedString:@"Center.NotNews"];
                }
            } else {
                self.backGroundEmptyLable.hidden = YES;
                self.table.hidden = NO;
                for (NSDictionary *dic in dataModel.data) {
                    Data *model = [Data modelWithDictionary:dic];
                    [_dataArray addObject:model];
                }
                [_table reloadData];
            }
        } else {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
        }
        [hud hide:YES];
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
    MLNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MLNewsCell" forIndexPath:indexPath];
    [cell setModel:_dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Data *model = _dataArray[indexPath.row];
    BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
    webVC.urlStr = [NSString stringWithFormat:@"%@/nid/%@",detail_newURL,model.nid];
    webVC.titleStr = [CommenUtil LocalizedString:@"Center.News"];
    [self.navigationController pushViewController:webVC animated:YES];
    [self.table deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
