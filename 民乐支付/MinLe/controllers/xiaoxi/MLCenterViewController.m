//
//  MLCenterViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/28.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLCenterViewController.h"
#import "MLAnnouncementViewController.h"
#import "MLMessageViewController.h"
#import "MLNewsViewController.h"
#import "MLCenterCell.h"
#import "DataModel.h"
#import "Data.h"

@interface MLCenterViewController () <UITableViewDelegate,UITableViewDataSource,BackActionDelegate,MessageBackActionDelegate,NewsBackActionDelegate>
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UITableView *centerTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MLCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setUI
{
    _dataArray = [NSMutableArray array];
    [self.view addSubview:self.naView];
    [self.view addSubview:self.centerTableView];
    [self request];
}

#pragma mark  -  返回刷新未读消息

- (void)BackAction
{
    if (_dataArray.count != 0) {
        [_dataArray removeAllObjects];
    }
    [self request];
}

- (void)request
{
    [[MCNetWorking sharedInstance] createPostWithUrlString:info_allURL withParameter:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]} withComplection:^(id responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            DataModel *datModel = [DataModel modelWithDictionary:responseObject];
            for (NSDictionary *dic in datModel.data) {
                Data *model = [Data modelWithDictionary:dic];
                [_dataArray addObject:model];
            }
            [self.centerTableView reloadData];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Center.Notification"]];
    }
    return _naView;
}

- (UITableView *)centerTableView
{
    if (!_centerTableView) {
        _centerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, widthss, heightss-64) style:UITableViewStylePlain];
        _centerTableView.delegate = self;
        _centerTableView.dataSource = self;
        [_centerTableView registerClass:[MLCenterCell class] forCellReuseIdentifier:@"MLCenterCell"];
        _centerTableView.tableFooterView = [[UIView alloc] init];
    }
    return _centerTableView;
}

#pragma mark - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MLCenterCell *centerCell = [tableView dequeueReusableCellWithIdentifier:@"MLCenterCell" forIndexPath:indexPath];
    [centerCell setModel:_dataArray[indexPath.row]];
    return centerCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Data *model = _dataArray[indexPath.row];
    if ([model.type isEqualToString:@"1"]) {
        MLAnnouncementViewController *drawVC = [[MLAnnouncementViewController alloc] init];
        drawVC.announceDelegate = self;
        [self.navigationController pushViewController:drawVC animated:YES];
    } else if ([model.type isEqualToString:@"2"]) {
        MLMessageViewController *messageVC = [[MLMessageViewController alloc] init];
        messageVC.messageDelegate = self;
        [self.navigationController pushViewController:messageVC animated:YES];
    } else {
        MLNewsViewController *newsVC = [[MLNewsViewController alloc] init];
        newsVC.newsDelegate = self;
        [self.navigationController pushViewController:newsVC animated:YES];
    }
    //设置选中cell跳转后返回取消选中状态
    [self.centerTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
