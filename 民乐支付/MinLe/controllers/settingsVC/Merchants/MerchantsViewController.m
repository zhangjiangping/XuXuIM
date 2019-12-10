//
//  MerchantsViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 2017/1/12.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import "MerchantsViewController.h"

//开关的几种状态
typedef NS_ENUM(NSUInteger, SwitchState){
    SwitchStateOff = 0, /**< 关闭 */
    SwitchStateOn = 1,  /**< 开启 */
};

@interface MerchantsViewController () <UITableViewDelegate,UITableViewDataSource>
{
    SwitchState switchState;
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UIView *messageView;
@property (nonatomic, strong) UILabel *messageLable;
@property (nonatomic, strong) UISwitch *switchBut;

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MerchantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUI
{
    self.dataArray = [[NSMutableArray alloc] init];
    [self.view addSubview:self.naView];
    [self updata];
}

- (void)updata
{
    /*
     id ：商户号id
     cmbcmchntid ：民生商户号
     usestatus ：使用状态  1=使用，0=不使用
     money：金额
     mchntname: 商户简称
     type：1 = 开启自动切换 2 = 手动选择商户号
     */
    
    if (self.dataArray.count) {
        [self.dataArray removeAllObjects];
    }
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [[MCNetWorking sharedInstance] createPostWithUrlString:partsListURL withParameter:@{@"token":token} withComplection:^(NSDictionary *responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            self.backGroundEmptyLable.hidden = YES;
            self.table.hidden = NO;
            [self.view addSubview:self.messageView];
            [self.view addSubview:self.table];
            
            //头部视图部分
            NSString *typeStr = [NSString stringWithFormat:@"%@",responseObject[@"type"]];
            if ([typeStr isEqualToString:@"1"]) {
                _messageLable.text = [CommenUtil LocalizedString:@"Me.MerchantsMsg1"];
                _switchBut.on = YES;
                switchState = SwitchStateOn;
            } else if ([typeStr isEqualToString:@"2"]) {
                _messageLable.text = [CommenUtil LocalizedString:@"Me.MerchantsMsg2"];
                _switchBut.on = NO;
                switchState = SwitchStateOff;
            }
            //列表视图部分
            for (NSDictionary *dic in responseObject[@"data"]) {
                [self.dataArray addObject:dic];
            }
            [self.table reloadData];
        } else {
            self.table.hidden = YES;
            [self.view addSubview:self.backGroundEmptyLable];
            self.backGroundEmptyLable.hidden = NO;
            self.backGroundEmptyLable.text = [CommenUtil LocalizedString:@"Me.NotMerchants"];
        }
        
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}

//切换按钮处理
- (void)switchAction:(id)sender
{
    UISwitch *witch = (UISwitch *)sender;
    NSString *typeStr = witch.isOn ? @"1" : @"2";
    switchState = witch.isOn ? SwitchStateOn : SwitchStateOff;
    NSDictionary *dic = @{@"token":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]],@"type":typeStr};
    [SharedApp.netWorking createPostWithUrlString:mchntTypeURL withParameter:dic withComplection:^(NSDictionary *responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            if ([typeStr isEqualToString:@"1"]) {
                _messageLable.text = [CommenUtil LocalizedString:@"Me.MerchantsMsg1"];
                [self updataOnCell];
            } else if ([typeStr isEqualToString:@"2"]) {
                _messageLable.text = [CommenUtil LocalizedString:@"Me.MerchantsMsg2"];
                [self updataOffCell];
            }
        } else {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}

//关闭后cell隐藏右边图片，并且不能选择
- (void)updataOnCell
{
    for (int i = 0; i < self.dataArray.count; i++) {
        UITableViewCell *cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [self upDataCell:cell withType:@"0"];
    }
}

//开启后cell可以手动选择
- (void)updataOffCell
{
    for (int i = 0; i < self.dataArray.count; i++) {
        UITableViewCell *cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        NSString *selecteTypeStr = self.dataArray[i][@"usestatus"];
        [self upDataCell:cell withType:selecteTypeStr];
    }
}

//更新cell视图方法
- (void)upDataCell:(UITableViewCell *)cell withType:(NSString *)type
{
    UILabel *lable = [cell.contentView viewWithTag:1];
    UILabel *lable2 = [cell.contentView viewWithTag:2];
    UILabel *lable3 = [cell.contentView viewWithTag:100];
    
    UIImageView *rightImg = [cell.contentView viewWithTag:3];
    if ([type isEqualToString:@"1"]) {
        lable.textColor = blueRGB;
        lable2.textColor = blueRGB;
        lable3.textColor = blueRGB;
        rightImg.image = [UIImage imageNamed:@"btn_choose"];
    } else {
        lable.textColor = [UIColor blackColor];
        lable2.textColor = [UIColor blackColor];
        lable3.textColor = [UIColor blackColor];
        rightImg.image = [UIImage imageNamed:@"btn_unchoose"];
    }
    rightImg.hidden = switchState == SwitchStateOff ? NO : YES;
}

#pragma mark - 数据源和代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        NSDictionary *dic = self.dataArray[indexPath.row];
        
        UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screenWidth-15-51, 31)];
        nameLable.tag = 100;
        nameLable.text = dic[@"mchntname"];
        [cell.contentView addSubview:nameLable];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(nameLable.frame), screenWidth-15-51, 31)];
        lable.text = dic[@"cmbcmchntid"];
        lable.font = FT(17);
        lable.tag = 1;
        [cell.contentView addSubview:lable];
        
        UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lable.frame), screenWidth-15-51, 31)];
        lable2.text = [NSString stringWithFormat:@"%@：%@%@", dic[@"money"],[CommenUtil LocalizedString:@"Me.TodayCollection"],[CommenUtil LocalizedString:@"Common.Yuan"]];
        lable2.font = FT(14);
        lable2.alpha = 0.5;
        lable2.tag = 2;
        [cell.contentView addSubview:lable2];
        
        UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-21-15, 36, 21, 21)];
        rightImg.clipsToBounds = YES;
        rightImg.tag = 3;
        [cell.contentView addSubview:rightImg];
        
        NSString *type = dic[@"usestatus"];
        if (switchState == SwitchStateOff) {
            [self upDataCell:cell withType:type];
        } else {
            [self upDataCell:cell withType:@"0"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.table deselectRowAtIndexPath:indexPath animated:YES];
    
    if (switchState == SwitchStateOff) {
        if (![self.dataArray[indexPath.row][@"usestatus"] isEqualToString:@"1"]) {
            [[MCNetWorking sharedInstance] createPostWithLoading:[CommenUtil LocalizedString:@"Switch..."] withUrlString:switchMerchantURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"id":self.dataArray[indexPath.row][@"id"]} withComplection:^(NSDictionary *responseObject) {
                if ([responseObject[@"status"] isEqual:@1]) {
                    for (int i = 0; i < self.dataArray.count; i++) {
                        UITableViewCell *cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                        if (i != indexPath.row) {
                            [self upDataCell:cell withType:@"0"];
                            [self.dataArray[i] setObject:@"0" forKey:@"usestatus"];
                        } else {
                            [self.dataArray[indexPath.row] setObject:@"1" forKey:@"usestatus"];
                            [self upDataCell:cell withType:@"1"];
                        }
                    }
                } else {
                    [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
                }
            } withFailure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93;
}

#pragma mark - getter

- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.messageView.frame), screenWidth, screenHeight-CGRectGetMaxY(self.messageView.frame)) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.tableFooterView = [UIView new];
        _table.showsVerticalScrollIndicator = NO;
        _table.showsHorizontalScrollIndicator = NO;
    }
    return _table;
}

- (UIView *)messageView
{
    if (!_messageView) {
        _messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, 50)];
        _messageView.backgroundColor = RGB(243, 248, 255);
        
        _messageLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screenWidth-15*2-60, 50)];
        _messageLable.font = FT(14);
        
        [_messageView addSubview:_messageLable];
        [_messageView addSubview:self.switchBut];
    }
    return _messageView;
}

- (UISwitch *)switchBut
{
    if (!_switchBut) {
        _switchBut = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.messageView.frame)-60, 10, 60, 40)];
        [_switchBut addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBut;
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Me.Manage"]];
    }
    return _naView;
}

@end
