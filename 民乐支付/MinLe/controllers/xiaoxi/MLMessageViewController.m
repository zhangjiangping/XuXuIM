//
//  MLMessageViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/28.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLMessageViewController.h"
#import "SVPullToRefresh.h"
#import "DataModel.h"
#import "Data.h"
#import "MLMessageCell.h"
#import "MLMessageTwoCell.h"
#import "MBProgressHUD.h"

@interface MLMessageViewController () <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    int offset;
    MBProgressHUD *hud;
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray <NSNumber *>*rowArray;
@property (nonatomic, strong) UIButton *emptyBut;
@end

@implementation MLMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self shangtiReload];
}

- (void)setUI
{
    offset = 1;
    _dataArray = [[NSMutableArray alloc] init];
    _rowArray = [[NSMutableArray alloc] init];
    hud = [[MBProgressHUD shareInstance] showLoding:[CommenUtil LocalizedString:@"Loading..."] showView:nil];
    [self request];
    [self.view addSubview:self.naView];
    [self.view addSubview:self.table];
}

//上提加载
- (void)shangtiReload
{
    __weak MLMessageViewController *weakSelf = self;
    [self.table addInfiniteScrollingWithActionHandler:^{
        [weakSelf infinite];
    }];
}

//上提
- (void)infinite
{
    __weak MLMessageViewController *weakSelf = self;
    offset++;
    [weakSelf request];
}

//关闭上提刷新
- (void)endrefrech
{
    __weak MLMessageViewController *weakSelf = self;
    [weakSelf.table.infiniteScrollingView stopAnimating];
}

#pragma mark - UIButton action

- (void)backAction:(UIButton *)sender
{
    [self.messageDelegate BackAction];
}

- (void)emptyAction:(UIButton *)sender
{
    //从底部弹出选择框
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:[CommenUtil LocalizedString:@"Common.Cancle"] destructiveButtonTitle:[CommenUtil LocalizedString:@"Center.ToEmptyAllRecords"] otherButtonTitles:nil, nil];
    //加在window上是为了避免：取消键响应代理方法
    [sheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

#pragma mark -  UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[MCNetWorking sharedInstance] createPostWithUrlString:clearMessageURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} withComplection:^(id responseObject) {
            if ([responseObject[@"status"] isEqual:@1]) {
                [_dataArray removeAllObjects];
                [_table reloadData];
            } else {
                [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            }
        } withFailure:^(NSError *error) {
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
            NSLog(@"%@",error);
        }];
    }
}

#pragma mark - getter

- (UIButton *)emptyBut
{
    if (!_emptyBut) {
        _emptyBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _emptyBut.frame = CGRectMake(CGRectGetWidth(self.naView.frame)-60, 16, 50, 50);
        [_emptyBut setTitle:[CommenUtil LocalizedString:@"Common.Empty"] forState:UIControlStateNormal];
        [_emptyBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_emptyBut addTarget:self action:@selector(emptyAction:) forControlEvents:UIControlEventTouchUpInside];
        _emptyBut.titleLabel.font = FT(17);
    }
    return _emptyBut;
}

- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, widthss, heightss-64) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.tableFooterView = [[UIView alloc] init];
        [_table registerClass:[MLMessageCell class] forCellReuseIdentifier:@"MLMessageCell"];
        [_table registerClass:[MLMessageTwoCell class] forCellReuseIdentifier:@"MLMessageTwoCell"];
    }
    return _table;
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Center.Message"]];
        [_naView addSubview:self.emptyBut];
        [_naView.but addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _naView;
}

- (void)request
{
    [[MCNetWorking sharedInstance] myPostWithUrlString:message_listURL withParameter:@{@"offset":[NSString stringWithFormat:@"%d", offset],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]} withComplection:^(id responseObject) {
        [hud hide:YES];
        if ([responseObject[@"status"] isEqual:@1]) {
            DataModel *dataModel = [DataModel modelWithDictionary:responseObject];
            if (dataModel.data.count == 0) {
                if (offset > 1) {
                    [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NotMoreData"] showView:nil];
                } else {
                    self.table.hidden = YES;
                    [self.view addSubview:self.backGroundEmptyLable];
                    self.backGroundEmptyLable.hidden = NO;
                    self.backGroundEmptyLable.text = [CommenUtil LocalizedString:@"Center.NotNewMessage"];
                }
            } else {
                self.backGroundEmptyLable.hidden = YES;
                self.table.hidden = NO;
                for (NSDictionary *dic in dataModel.data) {
                    Data *model = [Data modelWithDictionary:dic];
                    [_dataArray addObject:model];
                }
                for (int i = 0; i < _dataArray.count; i++) {
                    [_rowArray addObject:@0];
                }
                [_table reloadData];
            }
        } else {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_rowArray[section] isEqual:@0]) {
        return 1;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_rowArray[indexPath.section] isEqual:@1] && indexPath.row == 1) {
        MLMessageTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MLMessageTwoCell" forIndexPath:indexPath];
        [cell setModel:_dataArray[indexPath.section]];
        return cell;
    } else {
        MLMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MLMessageCell" forIndexPath:indexPath];
        [cell setModel:_dataArray[indexPath.section]];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        if ([_rowArray[indexPath.section] isEqual:@1]) {
           img.image = [UIImage imageNamed:@"xiaoxizhankai_07"];
        } else {
           img.image = [UIImage imageNamed:@"lijichakan"];
        }
        img.clipsToBounds = YES;
        cell.accessoryView = img;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_rowArray[indexPath.section] isEqual:@1]) {
        if (indexPath.row == 0) {
            return 75;
        } else {
            Data *model = _dataArray[indexPath.section];
            if ([model.content_type isEqualToString:@"1"]) {
                return 135;
            } else {
                return 300;
            }
        }
    } else {
        return 75;
    }
}

//左移动删除这一行
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Data *model = _dataArray[indexPath.section];
    [[MCNetWorking sharedInstance] myPostWithUrlString:del_messageURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"mid":model.mid} withComplection:^(id responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            [_dataArray removeObjectAtIndex:indexPath.row];
            [_table reloadData];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}
//将delete更改成中文
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CommenUtil LocalizedString:@"Common.Delete"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_rowArray[indexPath.section] isEqual:@1]) {
        _rowArray[indexPath.section] = @0;
    } else {
        _rowArray[indexPath.section] = @1;
    }
    [self.table reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        [self endrefrech];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
