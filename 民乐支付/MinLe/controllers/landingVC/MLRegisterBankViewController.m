//
//  MLRegisterBankViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/4.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLRegisterBankViewController.h"

@interface MLRegisterBankViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSArray *bankArray;
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UITableView *table;
@end

@implementation MLRegisterBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUI
{
    bankArray = [NSArray array];
    [self upData];
    [self.view addSubview:self.naView];
    [self.view addSubview:self.table];
}

- (void)upData
{
    [[MCNetWorking sharedInstance] createPostWithUrlString:getBankURL withParameter:@{} withComplection:^(NSDictionary *responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            if ([responseObject[@"data"] count]) {
                bankArray = responseObject[@"data"];
                [self.table reloadData];
            }
        } else {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Register.ChooseABank"]];
    }
    return _naView;
}

- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, widthss, heightss-64) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.tableFooterView = [[UIView alloc] init];
    }
    return _table;
}

#pragma mark  - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return bankArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"cellStrId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.textLabel.text = bankArray[indexPath.row][@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *bankName = bankArray[indexPath.row][@"name"];
    NSString *code = bankArray[indexPath.row][@"code"];
    NSDictionary *dic = @{@"name":bankName,@"code":code};
    self.block(dic);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
