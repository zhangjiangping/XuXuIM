//
//  MLAnnouncementViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/28.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLAnnouncementViewController.h"
#import "BaseWebViewController.h"
#import "DataModel.h"
#import "Data.h"

#import "MLAnnounCell.h"
#import "SVPullToRefresh.h"
#import "UIImageView+WebCache.h"

@interface MLAnnouncementViewController () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    int offset;
    MBProgressHUD *hud;
    MLAnnounCell *announCell;
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MLAnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self shangtiReload];
}

//下拉加载更多
- (void)shangtiReload
{
    __weak MLAnnouncementViewController *weakSelf = self;
    [self.table addPullToRefreshWithActionHandler:^{
        [weakSelf infinite];
    }];
}

//下拉
- (void)infinite
{
    __weak MLAnnouncementViewController *weakSelf = self;
    offset++;
    [weakSelf request];
}

//关闭下拉加载
- (void)endrefrech
{
    __weak MLAnnouncementViewController *weakSelf = self;
    [weakSelf.table.pullToRefreshView stopAnimating];
}

- (void)setUI
{
    offset = 1;
    _dataArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = RGB(230, 231, 232);
    hud = [[MBProgressHUD shareInstance] showLoding:[CommenUtil LocalizedString:@"Loading..."] showView:nil];
    [self request];
    [self.view addSubview:self.naView];
    [self.view addSubview:self.table];
}


- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Center.Announcement"]];
        [_naView.but addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _naView;
}

- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, widthss, heightss-64-20) style:UITableViewStylePlain];
        _table.backgroundColor = RGB(230, 231, 232);
        _table.delegate = self;
        _table.dataSource = self;
        _table.estimatedRowHeight = screenHeight;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.tableFooterView = [[UIView alloc] init];
    
        announCell = [[MLAnnounCell alloc] init];
        [_table registerClass:[MLAnnounCell class] forCellReuseIdentifier:@"MLAnnounCell"];
    }
    return _table;
}

- (void)backAction:(UIButton *)sender
{
    [self.announceDelegate BackAction];
}

- (void)request
{
    [[MCNetWorking sharedInstance] myPostWithUrlString:notice_listURL withParameter:@{@"offset":[NSString stringWithFormat:@"%d", offset],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]} withComplection:^(id responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            NSArray *dataArray = responseObject[@"data"];
            if (dataArray.count == 0) {
                if (offset > 1) {
                    [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NotMoreData"] showView:nil];
                } else {
                    self.table.hidden = YES;
                    [self.view addSubview:self.backGroundEmptyLable];
                    self.backGroundEmptyLable.hidden = NO;
                    self.backGroundEmptyLable.text = [CommenUtil LocalizedString:@"Center.NotAnnouncement"];
                }
            } else {
                self.backGroundEmptyLable.hidden = YES;
                self.table.hidden = NO;
                DataModel *dataModel = [DataModel modelWithDictionary:responseObject];
                NSMutableArray *indexPathList = [[NSMutableArray alloc]init];
                NSArray *modelArray = dataModel.dataArray;
                for (NSInteger i = 0; i < modelArray.count; i++ ) {
                    Data *model = modelArray[i];
                    [_dataArray insertObject:model atIndex:0];
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];//记录位置信息
                    [indexPathList addObject:indexPath];//位置信息数组
                }
                [_table insertRowsAtIndexPaths:indexPathList withRowAnimation:UITableViewRowAnimationTop];//插入位置信息数组
                if (offset == 1) {
                    [self scrollsToBottomAnimated:NO];
                    [self scrollViewToBottom:YES];
                }
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
    MLAnnounCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MLAnnounCell" forIndexPath:indexPath];
    [cell setModel:_dataArray[indexPath.row]];
    cell.contentView.backgroundColor = RGB(230, 231, 232);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count) {
        Data *model = _dataArray[indexPath.row];
        MLAnnounCell *cell = announCell;
        cell.model = model;
        return [cell getCellHeight];
    } else {
        return screenHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Data *model = _dataArray[indexPath.row];
    BaseWebViewController *baseWebVC = [[BaseWebViewController alloc] init];
    baseWebVC.titleStr = [CommenUtil LocalizedString:@"Center.Announcement"];
    baseWebVC.urlStr = [NSString stringWithFormat:@"%@/mid/%@",detail_noticeURL,model.mid];
    [self.navigationController pushViewController:baseWebVC animated:YES];
    [self.table deselectRowAtIndexPath:indexPath animated:YES];
}


//下面两个方法设置table一进来互动到最底部
- (void)scrollsToBottomAnimated:(BOOL)animated
{
    [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:animated];//这里一定要设置为NO，动画可能会影响到scrollerView，导致增加数据源之后，tableView到处乱跳
}

- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.table.contentSize.height > self.table.frame.size.height) {
        [self.table setContentOffset:CGPointMake(0, self.table.contentSize.height - self.table.frame.size.height) animated:animated];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
