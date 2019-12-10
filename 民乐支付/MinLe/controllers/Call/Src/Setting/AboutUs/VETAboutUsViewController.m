//
//  VETAboutUsViewController.m
//  MobileVoip
//
//  Created by Liu Yang on 13/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETAboutUsViewController.h"
#import "UIImageView+LYXExtension.h"

static CGFloat headHeight = 90.0;

/***********************************************************
 *  VETAboutUsTopCell
 ***********************************************************/
@interface VETAboutUsTopCell ()

@property (nonatomic, retain) UIImageView *logoImageView;
@property (nonatomic, retain) UILabel *label;

@end

@implementation VETAboutUsTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
        [self setupLayouts];
    }
    return self;
}

- (void)setupViews
{
    self.contentView.backgroundColor = RGBCOLOR(0xef, 0xef, 0xf4);
    
    _logoImageView = [[UIImageView alloc] init];
    _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_logoImageView];
    _logoImageView.layer.cornerRadius = headHeight * 0.5;
    _logoImageView.layer.masksToBounds = YES;
    
    _label = [UILabel new];
    _label.textAlignment = NSTextAlignmentCenter;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _label.text = [NSString stringWithFormat:@"%@ V%@", app_Name, app_Version];
    _label.font = [UIFont systemFontOfSize:20.0];
    _label.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_label];
}

- (void)setupLayouts
{
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.mas_equalTo(self.contentView);
        make.width.and.height.mas_equalTo(@(headHeight));
    }];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_logoImageView.mas_bottom).mas_offset(5);
        make.centerX.mas_equalTo(self.contentView);
    }];
}

@end

/***********************************************************
 *  VETAboutUsViewController
 ***********************************************************/
@interface VETAboutUsViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSString *_app_Name;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation VETAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.title = NSLocalizedString(@"About", @"About");
    
    self.view.backgroundColor = RGBCOLOR(0xef, 0xef, 0xf4);
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    _tableView.backgroundColor = RGBCOLOR(0xef, 0xef, 0xf4);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    _app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    UILabel *label = [UILabel new];
    label.textColor = [UIColor lightGrayColor];
    label.text = [NSString stringWithFormat:@"CopyRight @2016-2017 %@. All Rights Reserved.",_app_Name];
    label.font = [UIFont systemFontOfSize:12.0];
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).mas_offset(-20);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return headHeight * 2;
    }
    else {
        return 50.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        VETAboutUsTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"avatarCell"];
        if (cell == nil) {
            cell = [[VETAboutUsTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"avatarCell"];
        }
//        cell.logoImageView.image = [UIImage imageNamed:@"logo_head-1"];
        cell.logoImageView.image = [UIImage imageNamed:@"logo_head"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.textLabel.text = NSLocalizedString(@"Rate Talk2All", @"Settings");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        NSString *str = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", APP_ID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

@end
