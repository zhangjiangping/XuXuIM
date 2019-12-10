//
//  MLThirdPartyViewController.m
//  民乐支付
//
//  Created by JP on 2017/8/23.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import "MLThirdPartyViewController.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "WechatAuthSDK.h"
#import "UIAlertView+WX.h"

@interface MLThirdPartyViewController () <UITableViewDelegate,UITableViewDataSource,WXApiManagerDelegate>
{
    MBProgressHUD *hud1;
    MBProgressHUD *hud2;
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UIButton *bindingBtn;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MLThirdPartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置微信授权登录代理
    [WXApiManager sharedManager].delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WXApiManagerDelegate

//登录授权回调
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response
{
    NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", response.code, response.state, response.errCode];
    NSLog(@"回调数据：%@", strMsg);
    
    if (response.code && response.state) {
        hud2 = [[MBProgressHUD shareInstance] showLoding:@"" showView:nil];
        [[WXApiManager sharedManager] getOpenID:response];
    }
}

//获取openID成功回调
- (void)managerDidReciveOpenID:(NSString *)openId withIsSuccess:(BOOL)isSuccess
{
    NSLog(@"openId:%@",openId);
    if (isSuccess) {
        NSDictionary *dic = @{@"openid":openId,
                              @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
        [SharedApp.netWorking myPostWithUrlString:bindWeChatsURL withParameter:dic withComplection:^(NSDictionary *responseObject) {
            if ([responseObject[@"status"] isEqual:@1]) {
                [_dataArray removeAllObjects];
                [self request];
            } else if ([responseObject[@"status"] isEqual:@2]) {
                [hud2 hide:YES];
                [UIAlertView showWithTitle:[CommenUtil LocalizedString:@"Common.Prompt"] message:[CommenUtil LocalizedString:@"Setting.WXAccoundBinding"] sure:nil];
            } else {
                [hud2 hide:YES];
                [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            }
        } withFailure:^(NSError *error) {
            [hud2 hide:YES];
            [UIAlertView showWithTitle:[CommenUtil LocalizedString:@"Common.Prompt"] message:[CommenUtil LocalizedString:@"Setting.ServerErrorMsg"] sure:nil];
            NSLog(@"%@",error);
        }];
    } else {
        [hud2 hide:YES];
        [UIAlertView showWithTitle:[CommenUtil LocalizedString:@"Common.Prompt"] message:[CommenUtil LocalizedString:@"Setting.BindingFaileAgain"] sure:nil];
    }
}

#pragma mark - Action

- (void)bindingAction:(UIButton *)sender
{
    [WXApiRequestHandler wechatLoginInViewController:self];
}

#pragma mark - UI

- (void)setUI
{
    [self.view addSubview:self.naView];
    [self.view addSubview:self.table];
    [self.view addSubview:self.bindingBtn];
 
    self.dataArray = [[NSMutableArray alloc] init];
    hud1 = [[MBProgressHUD shareInstance] showLoding:@"" showView:nil];
    [self request];
}

- (void)request
{
    NSDictionary *dic = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
    [SharedApp.netWorking myPostWithUrlString:openiListURL withParameter:dic withComplection:^(NSDictionary *responseObject) {
        [hud1 hide:YES];
        [hud2 hide:YES];
        if ([responseObject[@"status"] isEqual:@1]) {
            [_dataArray addObjectsFromArray:responseObject[@"data"]];
            [_table reloadData];
        } else {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
        }
    } withFailure:^(NSError *error) {
        [hud1 hide:YES];
        [hud2 hide:YES];
        [UIAlertView showWithTitle:[CommenUtil LocalizedString:@"Common.Prompt"] message:[CommenUtil LocalizedString:@"Setting.ServerErrorMsg"] sure:nil];
        NSLog(@"%@",error);
    }];
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Setting.ThirdLogin"]];
    }
    return _naView;
}

- (UIButton *)bindingBtn
{
    if (!_bindingBtn) {
        _bindingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _bindingBtn.frame = CGRectMake(0, heightss-50, widthss, 50);
        [_bindingBtn setTitle:[CommenUtil LocalizedString:@"Setting.NewBindingWXAccount"] forState:UIControlStateNormal];
        [_bindingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bindingBtn.backgroundColor = RGB(2, 138, 218);
        [_bindingBtn addTarget:self action:@selector(bindingAction:) forControlEvents:UIControlEventTouchUpInside];
        _bindingBtn.titleLabel.font = FT(19);
    }
    return _bindingBtn;
}

- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, widthss, heightss-64-50) style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.backgroundColor = [ColorsUtil colorWithHexString:@"#efeff4"];
        _table.tableFooterView = [[UIView alloc] init];
        _table.tableHeaderView = self.headerView;
    }
    return _table;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthss, 50)];
        
        NSString *str = [CommenUtil LocalizedString:@"Setting.WXOpenID"];
        float hh = [CommenUtil getTxtHeight:str forContentWidth:200 fotFontSize:16];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(15, (50-hh)/2, 7, hh)];
        leftView.backgroundColor = [ColorsUtil colorWithHexString:@"35ac38"];
        leftView.layer.cornerRadius = 3.5;
        [_headerView addSubview:leftView];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame)+10, 0, 200, 50)];
        lable.text = str;
        lable.font = FT(16);
        lable.alpha = 0.5;
        [_headerView addSubview:lable];
    }
    return _headerView;
}

#pragma mark - 数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ThirdPartyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = FT(14);
        cell.detailTextLabel.font = FT(14);
    }
    NSDictionary *dic = self.dataArray[indexPath.section];
    cell.textLabel.text = dic[@"openid"];
    cell.detailTextLabel.text = dic[@"create_time"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
