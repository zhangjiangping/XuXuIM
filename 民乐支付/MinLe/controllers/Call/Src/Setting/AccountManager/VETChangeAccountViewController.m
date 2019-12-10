//
//  VETChangeAccountViewController.m
//  VETEphone
//
//  Created by Liu Yang on 28/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import "VETChangeAccountViewController.h"
#import "VETAddAccountViewController.h"
#import "DBUtil.h"
#import "VETAccount.h"
#import "VETNavigationController.h"
#import "LYAlertViewHelper.h"
#import "VETVoip.h"
#import "PLCustomCellBtn.h"
#import <objc/runtime.h>
#import "VETAccountDetailViewController.h"

/***********************************************************
 *  VETAccountCell
 ***********************************************************/

static void *VETAccountPrimaryAlertKey = "PrimaryAlertKey";

@interface VETAccountCell :  UITableViewCell

@property (nonatomic, retain) PLCustomCellBtn *switchButton;
@property (nonatomic, assign) VETAccountStatus accountStatus;
@property (nonatomic, retain) UIImageView *accountStatusImageView;
@property (nonatomic, retain) UILabel *accountLabel;
@property (nonatomic, assign, getter=isPrimaryAccount) BOOL primaryAccount;

-(void)showMenu:(void(^)())block;

@end

@implementation VETAccountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
        [self setupLayouts];
    }
    return self;
}

- (void)setupViews
{
    _switchButton = [[PLCustomCellBtn alloc] init];
    [self.contentView addSubview:_switchButton];
    [_switchButton setImage:[UIImage imageNamed:@"account_logined"] forState:UIControlStateSelected];
    [_switchButton setImage:[UIImage imageNamed:@"account_unlogin"] forState:UIControlStateNormal];
    
    _accountStatusImageView = [UIImageView new];
    [self.contentView addSubview:_accountStatusImageView];
    _accountStatusImageView.image = [UIImage imageNamed:@"call_status_failed"];
    _accountStatusImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _accountLabel = [UILabel new];
    [self.contentView addSubview:_accountLabel];
}

- (void)setupLayouts
{
    [_switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.width.and.height.mas_equalTo(@25);
    }];
    
    [_accountStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.width.and.height.mas_equalTo(@25);
    }];
    
    [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(_accountStatusImageView.mas_right).offset(15);
    }];
}

- (void)setAccountStatus:(VETAccountStatus)accountStatus
{
    _accountStatus = accountStatus;
    switch (_accountStatus) {
        case VETAccountStatusInitial:{
            _accountStatusImageView.image = [UIImage imageNamed:@"call_status_failed"];
            break;
        }
        case VETAccountStatusOffline:{
            _accountStatusImageView.image = [UIImage imageNamed:@"call_status_failed"];
            break;
        }
        case VETAccountStatusInvalid:{
            _accountStatusImageView.image = [UIImage imageNamed:@"call_status_failed"];
            break;
        }
        case VETAccountStatusConnecting:{
            _accountStatusImageView.image = [UIImage imageNamed:@"call_status_connecting"];
            break;
        }
        case VETAccountStatusConnected:{
            _accountStatusImageView.image = [UIImage imageNamed:@"call_status_success"];
            break;
        }
        case VETAccountStatusDisconnecting:{
            _accountStatusImageView.image = [UIImage imageNamed:@"call_status_failed"];
            break;
        }
        default:
            break;
    }
}

- (void)setPrimaryAccount:(BOOL)primaryAccount
{
    _primaryAccount = primaryAccount;
    self.accountLabel.textColor = _primaryAccount ? [UIColor redColor] : [UIColor blackColor];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return action == @selector(primaryAction:);
}

- (void)primaryAction:(id)sender
{
    void (^block)() = objc_getAssociatedObject(self, VETAccountPrimaryAlertKey);
    block();
}

-(void)showMenu:(void(^)())block
{
    if(self.isFirstResponder){
        [self resignFirstResponder];
    }else{
        [self becomeFirstResponder];
    }
    //  Create Item
    UIMenuItem *primaryItem = [[UIMenuItem alloc] initWithTitle:@"Primary account" action:@selector(primaryAction:)];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuItems:@[primaryItem]];
    [menuController update];
    [menuController setTargetRect:self.frame inView:self.superview];
    [menuController setMenuVisible:YES animated:YES];
    objc_setAssociatedObject(self, VETAccountPrimaryAlertKey, block, OBJC_ASSOCIATION_COPY);
}

@end

/***********************************************************
 *  VETChangeAccountViewController
 ***********************************************************/

@interface VETChangeAccountViewController ()
{
    NSIndexPath *_selectedIndexPath;
    VETAccount *_userAccount;
}

@property (nonatomic, retain) NSArray *accountArray;

@end

@implementation VETChangeAccountViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:VETVoipManagerAccountRegisterStatusNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Change account", @"Setting");
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", @"Contact") style:UIBarButtonItemStylePlain target:self action:@selector(tapAddButton:)];
    self.navigationItem.rightBarButtonItem.tintColor = MAINTHEMECOLOR;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voipAccountRegistrationDidChange:) name:VETVoipManagerAccountRegisterStatusNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _accountArray = [[DBUtil sharedManager] queryAccount];
    [self.tableView reloadData];
    
    for (VETVoipAccount *account in [[VETVoipManager sharedManager] accounts]) {
        [self changeStateWithVoipAccount:account];
    }
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _accountArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indetifier = @"cell";
    VETAccountCell *cell = (VETAccountCell *)[tableView dequeueReusableCellWithIdentifier:indetifier];
    if (cell == nil) {
        cell = [[VETAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifier];
    }
    [self setupCell:cell indexPath:indexPath];
    return cell;
}

- (void)setupCell:(VETAccountCell *)cell indexPath:(NSIndexPath *)indexPath
{
    VETAccount *account = _accountArray[indexPath.row];
    
    cell.accountLabel.text = account.displayName;
    cell.switchButton.selected = account.autoLogin;
    
    // 当前帐户在服务器的状态
    VETVoipAccount *voipAccount = [[VETVoipManager sharedManager] accountWithUsername:account.username];
    if (voipAccount) {
        [cell setAccountStatus:voipAccount.accountStatus];
    }
    
    // 当前帐户是否是主帐户
    if ([account.username isEqualToString:[[VETUserManager sharedInstance] mainUsername]]) {
        [cell setPrimaryAccount:YES];
    }
    else {
        [cell setPrimaryAccount:NO];
    }
    
    //  添加长按手势
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCell:)];
    [cell addGestureRecognizer:longGes];
    
    cell.switchButton.selectIndexpath = indexPath;
    [cell.switchButton addTarget:self action:@selector(tapSwitchButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VETAccountDetailViewController *detailVC = [[VETAccountDetailViewController alloc] init];
    detailVC.account = _accountArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    VETAccount *account = _accountArray[indexPath.row];
    if ([[VETVoipManager sharedManager] accountWithUsername:account.username].isRegistered) {
        [[VETVoipManager sharedManager] removeAccount:[[VETVoipManager sharedManager] accountWithUsername:account.username]];
    }
    // 删除模型
//    [_accountArray removeObjectAtIndex:indexPath.row];
    [[DBUtil sharedManager] deleteAccount:_accountArray[indexPath.row]];
    _accountArray = [[DBUtil sharedManager] queryAccount];
    // 刷新
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

/**
 *  修改Delete按钮文字为“删除”
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"Delete", @"Setting");
}

#pragma mark - private

/**
 *  点击登录选项按钮
 */
- (void)tapSwitchButton:(id)sender
{
    PLCustomCellBtn *btn = (PLCustomCellBtn *)sender;
    NSIndexPath *indexPath = btn.selectIndexpath;
    
    btn.selected = !btn.selected;
    
    // 自动登录
    BOOL status = false;
    VETAccount *account = _accountArray[indexPath.row];
    account.autoLogin = btn.selected;
    
    // 更新autoLogin状态
    [[DBUtil sharedManager] updateAccount:account];
    
    VETVoipAccount *voipAccount = [[VETVoipManager sharedManager] accountWithUsername:account.username];
    if (!voipAccount) {
//        voipAccount = [[VETVoipAccount alloc] initWithFullName:account.displayName username:account.username password:account.password domain:account.domain realm:@"*" encryptionType:(VETAccountEncryptionType)account.encryptionType transportType:(VETAccountTransportType)account.transportType];
        
        voipAccount = [[VETVoipAccount alloc] initWithFullName:account.displayName username:account.username password:account.password domain:account.domain realm:@"*" encryptionType:(VETAccountEncryptionType)account.encryptionType transportType:(VETAccountTransportType)account.transportType encryptionPort:SERVER_ENCRYPTION_PORT];
    }
    
    if (voipAccount.isRegistered) {
        NSLog(@"应该注销...");
        [voipAccount setRegistered:NO];
    }
    else {
        [self changeStateWithVoipAccount:voipAccount];
        status = [[VETVoipManager sharedManager] addAccount:voipAccount];
    }
    _selectedIndexPath = indexPath;
}

- (void)setPrimaryAccount:(NSIndexPath *)indexpath
{
    VETAccount *account = _accountArray[indexpath.row];
    [[VETUserManager sharedInstance] setMainUsername:account.username];
    
    // 主帐户设为红色
    VETAccountCell *cell = (VETAccountCell *)[self.tableView cellForRowAtIndexPath:indexpath];
    [cell setPrimaryAccount:YES];
    
    // 其余帐户字体为黑色
    for (NSInteger i = 0; i < _accountArray.count; i++) {
        if (i == indexpath.row) continue;
        NSIndexPath *otherIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        VETAccountCell *cell = (VETAccountCell *)[self.tableView cellForRowAtIndexPath:otherIndexPath];
        [cell setPrimaryAccount:NO];
    }
}

/**
 *  更改帐户状态
 */
- (void)changeStateWithVoipAccount:(VETVoipAccount *)voipAccount
{
    VETAccountCell *cell;
    for (NSUInteger i = 0; i < self.accountArray.count; i++) {
        VETAccount *userAccount = self.accountArray[i];
        if ([voipAccount.username isEqualToString:userAccount.username]) {
            cell = (VETAccountCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
    if (cell) {
//        cell.accountLabel.text = [NSString stringWithFormat:@"%@(%@)", voipAccount.username, VETAccountStatusString(voipAccount.accountStatus)];
        [cell setAccountStatus:voipAccount.accountStatus];
    }
}

#pragma mark - logout logining event

- (void)tapAddButton:(id)sender
{
    VETAddAccountViewController *addAccountVC = [VETAddAccountViewController new];
    [self.navigationController pushViewController:addAccountVC animated:YES];
}

#pragma mark - long press event

- (void)longPressCell:(UIGestureRecognizer *)longGes
{
    if (longGes.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [longGes locationInView:self.tableView];
        NSIndexPath *longPressIndexPath = [self.tableView indexPathForRowAtPoint:location];
        VETAccountCell *cell = (VETAccountCell *)longGes.view;
        [cell showMenu:^{
            cell.textLabel.textColor = [UIColor redColor];
            [self setPrimaryAccount:longPressIndexPath];
        }];
    }
}

#pragma mark - account register state

- (void)voipAccountRegistrationDidChange:(NSNotification *)notification
{
    VETVoipAccount *account = (VETVoipAccount *)notification.object;
    
    // 更改UI状态
    [self changeStateWithVoipAccount:account];
    
    // 只有一个帐户登录成功，默认为主帐户
    if (account.accountStatus == VETAccountStatusConnected && [[VETVoipManager sharedManager] accounts].count == 1) {
        VETAccountCell *cell = (VETAccountCell *)[self.tableView cellForRowAtIndexPath:_selectedIndexPath];
        [cell setPrimaryAccount:YES];
    }
    
    // 未增加的帐户return
    if (account.accountId == kVETVoipManagerInvalidIdentifier) {
        return ;
    }
    if ([account isRegistered]) {
        if (account.accountStatus == VETAccountStatusOffline) {
            [account setRegistered:YES];
        }
    }
    // Unavailable
    else {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
