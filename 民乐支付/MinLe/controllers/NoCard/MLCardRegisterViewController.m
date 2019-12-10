//
//  MLCardRegisterViewController.m
//  minlePay
//
//  Created by JP on 2017/10/16.
//  Copyright © 2017年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import "MLCardRegisterViewController.h"
#import "MLNoCardRegisterViewController.h"
#import "DataModel.h"

@interface MLCardRegisterViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UILabel *emptyLable;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIButton *addRegisterbut;

@end

@implementation MLCardRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSArray array];
    [self.view addSubview:self.naView];
    [self.view addSubview:self.table];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取注册列表
- (void)request
{
    NSDictionary *dic = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
                          @"type":@"1_3"};
    [SharedApp.netWorking createPostWithUrlString:getUserCardInfoURL withParameter:dic withComplection:^(NSDictionary *responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            DataModel *datModel = [DataModel modelWithDictionary:responseObject];
            if (datModel.dataArray && datModel.dataArray.count > 0) {
                self.backGroundEmptyLable.hidden = YES;
                _table.hidden = NO;
                _dataArray = [NSArray arrayWithArray:datModel.dataArray];
                _table.frame = CGRectMake(0, 64, screenWidth, screenHeight-64);
                [_table reloadData];
            } else {
                _table.hidden = YES;
                [self.view addSubview:self.backGroundEmptyLable];
                self.backGroundEmptyLable.hidden = NO;
                self.backGroundEmptyLable.text = [CommenUtil LocalizedString:@"NoCard.NotOpenCardRecoder"];
                
                [self.view addSubview:self.addRegisterbut];
            }
        } else {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}

#pragma mark - getter

- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64-50) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.tableFooterView = [UIView new];
    }
    return _table;
}

#pragma mark - Action

- (void)pushAction:(UIButton *)sender
{
    MLNoCardRegisterViewController *vc = [[MLNoCardRegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    Data *data = _dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@：%@",[CommenUtil LocalizedString:@"NoCard.CardNumber"],data.cardno];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Data *data = _dataArray[indexPath.row];
    if (self.block) {
        self.block(data);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - getter

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"NoCard.CardList"]];
    }
    return _naView;
}

- (UIButton *)addRegisterbut
{
    if (!_addRegisterbut) {
        _addRegisterbut = [UIButton buttonWithType:UIButtonTypeSystem];
        _addRegisterbut.frame = CGRectMake(0, heightss-50, widthss, 50);
        _addRegisterbut.backgroundColor = RGB(2, 138, 218);
        [_addRegisterbut setTitle:[CommenUtil LocalizedString:@"NoCard.AddRegister"] forState:UIControlStateNormal];
        [_addRegisterbut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addRegisterbut addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
        _addRegisterbut.titleLabel.font = FT(20);
    }
    return _addRegisterbut;
}

@end
