//
//  VETHistoryViewController.m
//  LYXAnimatoinDemo
//
//  Created by Liu Yang on 22/03/2017.
//  Copyright © 2017 young. All rights reserved.
//

#import "VETHistoryViewController_Old.h"
#import "VETHistoryMainView.h"
#import "VETNavMenuView.h"
#import "DBUtil.h"
#import "VETHistoryTableView.h"
#import "VETScrollPageView.h"
#import "VETVoip.h"
#import "LYAlertViewHelper.h"
#import "VETOutgoingCallingViewController.h"
#import "VETCallHelper.h"

@interface VETHistoryViewController_Old ()<VETNavMenuViewDelagate, VETHistoryMainViewDelegate, VETHistoryTableViewDelegate>
{
    NSUInteger _lastIndex;
}
@property (nonatomic, retain) VETHistoryMainView *historyView;
@property (nonatomic, retain) VETNavMenuView *navMenuView;
@property (nonatomic, retain) UIBarButtonItem *editBarButton;
@property (nonatomic, retain) UIBarButtonItem *deleteAllBarButton;

@end

@implementation VETHistoryViewController_Old

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:VETHistoryViewControllerRefreshHistoryNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self refreshHistory];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHistory) name:VETHistoryViewControllerRefreshHistoryNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.navigationItem.titleView = nil;
//    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self.tabBarController.navigationController setNavigationBarHidden:NO];
    if (_historyView.allHistoryArray.count != 0 && self.tabBarController.navigationItem.rightBarButtonItem == nil) {
        self.tabBarController.navigationItem.rightBarButtonItem = _editBarButton;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.navigationController setNavigationBarHidden:NO];

    [self.tabBarController.navigationItem setTitleView:self.navMenuView];
    if (_historyView.allHistoryArray.count == 0) {
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
    }
    else {
        self.tabBarController.navigationItem.rightBarButtonItem = _editBarButton;
    }
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
}

- (void)setupViews {
    [self.view addSubview:self.historyView];
    
    _editBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", @"History") style:UIBarButtonItemStylePlain target:self action:@selector(tapEditButton:)];
    _editBarButton.tintColor = MAINTHEMECOLOR;
    
    _deleteAllBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Delete All", @"History") style:UIBarButtonItemStylePlain target:self action:@selector(tapDeleteAllButton:)];
    _deleteAllBarButton.tintColor = MAINTHEMECOLOR;
    
//    self.tabBarController.tabBar.translucent = NO;
}

- (VETHistoryMainView *)historyView {
    if (_historyView == nil) {
        _historyView = [[VETHistoryMainView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - STATUS_AND_NAVIGATION_HEIGHT - TABBARHEIGHT)];
        _historyView.delegate = self;
        _historyView.leftView.historyDelegate = self;
        _historyView.rightView.historyDelegate = self;
    }
    return _historyView;
}

- (VETNavMenuView *)navMenuView {
    if (_navMenuView == nil) {
        _navMenuView = [[VETNavMenuView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
        _navMenuView.delegate = self;
        _navMenuView.currentIndex = 0;
    }
    return _navMenuView;
}

#pragma mark - event

- (void)navMenuView:(VETNavMenuView *)menuView tapMissedButton:(UIButton *)missedButton {
    [self cancelEditButtonOrNot];
    _navMenuView.currentIndex = 1;
    _historyView.currentIndex = 1;
    _lastIndex = 1;
}

- (void)navMenuView:(VETNavMenuView *)menuView tapAllButton:(UIButton *)allButton {
    [self cancelEditButtonOrNot];
    _navMenuView.currentIndex = 0;
    _historyView.currentIndex = 0;
    _lastIndex = 0;
}

- (void)tapEditButton:(id)sender {
    if (_navMenuView.currentIndex == 0) {
        self.historyView.leftView.editing = !self.historyView.leftView.editing;
        _editBarButton.title = self.historyView.leftView.editing ? NSLocalizedString(@"Done", @"Common") : NSLocalizedString(@"Edit", @"Common");
        self.tabBarController.navigationItem.leftBarButtonItem = self.historyView.leftView.editing ? _deleteAllBarButton : nil;
    }
    else {
        self.historyView.rightView.editing = !self.historyView.rightView.editing;
        _editBarButton.title = self.historyView.rightView.editing ? NSLocalizedString(@"Done", @"Common") : NSLocalizedString(@"Edit", @"Common");
        self.tabBarController.navigationItem.leftBarButtonItem = self.historyView.rightView.editing ? _deleteAllBarButton : nil;
    }
}

- (void)tapDeleteAllButton:(id)sender {
    if (_navMenuView.currentIndex == 0) {
        [[DBUtil sharedManager] deleteAllRecentContactsRecordByLoginMobNum:[[VETUserManager sharedInstance] currentUsername]];
        [self refreshHistory];
    }
    else {
        [[DBUtil sharedManager] deleteAllMissedContactsRecordByLoginMobNum:[[VETUserManager sharedInstance] currentUsername]];
        [self refreshHistory];
    }
}

#pragma mark - private

/*
 *  刷新编辑按钮，若换页则取消编辑状态
 */
- (void)cancelEditButtonOrNot {
    if (_navMenuView.currentIndex == _lastIndex) {
        return ;
    }
    _editBarButton.title = NSLocalizedString(@"Edit", @"Common");
    _historyView.leftView.editing = NO;
    _historyView.rightView.editing = NO;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
}

- (void)refreshHistory {
    NSArray *array = [[DBUtil sharedManager] findAllRecentContactsRecordByLoginMobNum:[[VETUserManager sharedInstance] currentUsername]];
    _historyView.allHistoryArray = array;
    NSArray *missedArray = [[DBUtil sharedManager] findAllMissedContactsRecordByLoginMobNum:[[VETUserManager sharedInstance] currentUsername]];
    _historyView.missedHistoryArray = missedArray;
    if (_historyView.allHistoryArray.count == 0) {
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
    }
    else {
        self.tabBarController.navigationItem.rightBarButtonItem = _editBarButton;
    }
}

#pragma mark - VETHistoryTableView delagate

- (void)historyTableView:(VETHistoryTableView *)tableView withPhone:(NSString *)phone type:(VETHistoryTableViewType)type {
//    [[VETCallHelper sharedInstance] callWithPhone:phone withTarget:self];
}

- (void)historyTableView:(VETHistoryTableView *)tableView didSelectRow:(VETCallRecord *)callRecord type:(VETHistoryTableViewType)type {
    [VETCallHelper outgoingWithPhoneString:callRecord.account target:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VETHistoryViewControllerRefreshHistoryNotification object:nil];
}

- (void)historyTableView:(VETHistoryTableView *)tableView didDeleteRow:(VETCallRecord *)callRecord type:(VETHistoryTableViewType)type {
    [[DBUtil sharedManager] deleteRecentContactRecordById:callRecord.dbId];
    [self refreshHistory];
}

#pragma mark - scrollView delegate
//  拖动进度传递给NavMenuView
- (void)historyView:(VETHistoryMainView *)historyView pageProgress:(CGFloat)pageProgress {
    _navMenuView.currentProgress = pageProgress;
}

- (void)historyView:(VETHistoryMainView *)historyView currentIndex:(CGFloat)currentIndex {
    [self cancelEditButtonOrNot];
    _navMenuView.currentIndex = currentIndex;
    _lastIndex = currentIndex;
}

@end
