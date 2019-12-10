//
//  MLForMoreDetailsViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/21.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLForMoreDetailsViewController.h"
#import "MLScopeBusinessViewController.h"

@interface MLForMoreDetailsViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSString *business_scope;//经营范围
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *array;
@end

@implementation MLForMoreDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUI
{
    _dataArray = [[NSArray alloc] init];
    [self.view addSubview:self.naView];;
    _array = @[@[[CommenUtil LocalizedString:@"Authen.MerchantsAllName"],
                 [CommenUtil LocalizedString:@"Account.ScopeBusiness"]],
               @[[CommenUtil LocalizedString:@"Account.BusinessArea"]],
               @[[CommenUtil LocalizedString:@"Authen.BusinessLicense"],
                 [CommenUtil LocalizedString:@"Account.BusinessLicenseDue"]],
               @[[CommenUtil LocalizedString:@"Account.Tax"],
                 [CommenUtil LocalizedString:@"Account.OpenAccountLicence"]],
               @[[CommenUtil LocalizedString:@"Authen.LegalName"],
                 [CommenUtil LocalizedString:@"Account.LegalPhone"],
                 [CommenUtil LocalizedString:@"Authen.LegalIDNumber"],
                 [CommenUtil LocalizedString:@"Account.LegalIDDue"]],
               @[[CommenUtil LocalizedString:@"Account.BusinessAddress"],
                 [CommenUtil LocalizedString:@"Account.Address"],
                 [CommenUtil LocalizedString:@"Account.ZipCode"]]];
    [self.view addSubview:self.naView];
    [self request];
    [self.view addSubview:self.table];
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Account.DetailInfo"]];
    }
    return _naView;
}

- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, widthss, heightss-64) style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.sectionHeaderHeight = 20;
        _table.sectionFooterHeight = 0;
        _table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthss, 0.1)];
    }
    return _table;
}

- (void)request
{
    [[MCNetWorking sharedInstance] createPostWithUrlString:zhanghuURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"type":@"2"} withComplection:^(id responseObject) {
        business_scope = [NSString string];
        if ([responseObject[@"data"][0][@"business_scope"] isEqual:[NSNull null]] || responseObject[@"data"][0][@"business_scope"] == nil) {
            business_scope = @"";
        } else {
            business_scope = responseObject[@"data"][0][@"business_scope"];
        }
        NSLog(@"%@",business_scope);
        if ([responseObject[@"status"] isEqual:@1]) {
            _dataArray = @[@[[NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"name"]],business_scope],
                           @[[NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"operating_area"]]],
                           @[[NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"business_number"]],
                             [NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"business_end_time"]]],
                           @[[NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"tax_registration_number"]],
                             [NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"account_opening_num"]]],
                           @[[NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"corporate_name"]],
                             [NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"corporate_phone"]],
                             [NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"corporate_id_card"]],
                             [NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"corporate_id_card_end_time"]]],
                           @[[NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"zip"]],
                             [NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"business_area"]],
                             [NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"detailed_address"]]]];
        }
        [_table reloadData];
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@", error);
    }];
}

#pragma mark - datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"myForMoreDataTableViewCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    if (!(indexPath.section == 0 && indexPath.row == 1)) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = _array[indexPath.section][indexPath.row];
    cell.detailTextLabel.text = _dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        if (business_scope.length >= 10) {
            MLScopeBusinessViewController *scopVC = [[MLScopeBusinessViewController alloc] init];
            scopVC.business_scope = business_scope;
            [self.navigationController pushViewController:scopVC animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
