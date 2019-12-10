//
//  VETNetworkViewController.m
//  MobileVoip
//
//  Created by Liu Yang on 12/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETNetworkViewController.h"
#import "VETSwitchCell.h"
#import "VETVoip.h"
#import "DBUtil.h"
#import "VETAccount.h"
#import <objc/runtime.h>
#import "VETNavigationController.h"
#import "LYAlertViewHelper.h"
#import "UIBarButtonItem+Extension.h"
#import "VETLogoutHelper.h"

/***********************************************************
 *  VETNetworkPortCell
 ***********************************************************/

@interface VETNetworkPortCell ()

@end

@implementation VETNetworkPortCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
        [self setupLayouts];
    }
    return self;
}

- (void)setupViews
{
    _leftLabel = [UILabel new];
    _leftLabel.textColor = [UIColor blackColor];
    _leftLabel.text = NSLocalizedString(@"Audio Port", @"Setting");
    [self.contentView addSubview:_leftLabel];
    
    _rightTextField = [UITextField new];
    _rightTextField.textColor = MAINTHEMECOLOR;
    _rightTextField.placeholder = @"0";
    _rightTextField.keyboardType = UIKeyboardTypeNumberPad;
    _rightTextField.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_rightTextField];
}

- (void)setupLayouts
{
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).mas_offset(15);
        
    }];
    
    [_rightTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).mas_offset(-15);
        make.width.mas_equalTo(@200);
    }];
}

@end

/***********************************************************
 *  VETNetworkViewController
 ***********************************************************/
@interface VETNetworkViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate>
{
    NSUInteger _initialPort;
    BOOL _initialEncryption;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UISwitch *switchBtn;

@end

@implementation VETNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame
                                              style:UITableViewStyleGrouped];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
    [_tableView reloadData];
    
    self.title = NSLocalizedString(@"Network", @"Setting");

    _initialPort = [[VETUserManager sharedInstance] transport];
    _initialEncryption = [[VETUserManager sharedInstance] encryptStatus];

    /*
     * Hook VETNavigation的back方法
     */
//    SEL originSelector = @selector(back_original);
//    SEL swizzledSelector = @selector(tapBack_replaced);
//    Method originMethod = class_getInstanceMethod([VETNavigationController class], originSelector);
//    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
//    
//    class_addMethod([VETNavigationController class], @selector(originalBack), method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
//    class_replaceMethod([VETNavigationController class], originSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(originMethod));
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back_icon" highImageName:@"nav_item_back" target:self action:@selector(tapBack)];
}

- (void)tapBack
{
    // 注销，重新登录
    if (_initialPort != [_textField.text integerValue] || _switchBtn.on != _initialEncryption) {
        [LYAlertViewHelper alertViewStrongWithTagert:self title:NSLocalizedString(@"Save changes to the network settings?", @"Settings") content:NSLocalizedString(@"New network settings will be applied immediately, account will be reconnected.", @"Settings") confirmEvent:^(UIAlertAction *action) {
            [self logoutAndReconnect];
            [self.navigationController popViewControllerAnimated:YES];
        } cancelEvent:^(UIAlertAction *action) {

        }];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 这个方法里的Self在
//- (void)tapBack_replaced
//{
//    [self performSelector:@selector(originalBack) withObject:nil];
    // 调用VETNavigation的back方法的实现
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *const cellId = @"port";
        VETNetworkPortCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[VETNetworkPortCell alloc] initWithStyle:UITableViewCellStyleValue1
                                        reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.rightTextField.delegate = self;
            cell.rightTextField.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[VETUserManager sharedInstance] transport]];
            _textField = cell.rightTextField;
        }
        _textField.text = [NSString stringWithFormat:@"%d",[[VETUserManager sharedInstance] transport]];
        return cell;
    }
    else {
        static NSString *const cellId = @"encryption";
        VETSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[VETSwitchCell alloc] initWithStyle:UITableViewCellStyleValue1
                                        reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            _switchBtn = cell.switchBtn;
        }
        cell.textLabel.text = NSLocalizedString(@"Encryption", @"Setting");
        cell.switchBtn.on = [[VETUserManager sharedInstance] encryptStatus];
        [cell.switchBtn addTarget:self action:@selector(tapSwitch:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
}

- (void)tapSwitch:(UISwitch *)switchBtn
{
    UISwitch *switchButton = switchBtn;
    BOOL isButtonOn = [switchButton isOn];
    [switchButton setOn:!isButtonOn];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"string:%@", textField);
    return YES;
}

#pragma mark - private
- (void)logoutAndReconnect
{
    [[VETUserManager sharedInstance] setEncryptStatus:_switchBtn.on];
    [[VETUserManager sharedInstance] setTransportPort:[_textField.text integerValue]];
    
    NSArray *accountArray = [[DBUtil sharedManager] queryAccount];
    
    NSArray *registerAccountArr = [[VETVoipManager sharedManager] accounts];
    for (VETVoipAccount *account in registerAccountArr) {
        [account setRegistered:NO];
        [[VETVoipManager sharedManager] removeAccount:account];
        NSLog(@"++++++removeAccount");
    }
    
    for (VETAccount *account in accountArray) {
        VETAccountEncryptionType encryptionType = [[VETUserManager sharedInstance] encryptStatus] ? VETAccountEncryptionTypeRC4 : VETAccountEncryptionTypeNone;
        
//        [[VETVoipManager sharedManager] setTransportPort:[[VETUserManager sharedInstance] transport]];
        
        VETVoipAccount *voipAccount = [[VETVoipAccount alloc] initWithFullName:account.displayName username:account.displayName password:account.password domain:SERVER_ADDRESS realm:@"*" encryptionType:encryptionType transportType:(VETAccountTransportType)account.transportType encryptionPort:SERVER_ENCRYPTION_PORT];
        
        if (!voipAccount.isRegistered) {
            NSLog(@"++++++addAccount");
            [[VETVoipManager sharedManager] addAccount:voipAccount];
        }
    }
}

@end
