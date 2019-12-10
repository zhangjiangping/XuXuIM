//
//  VETHistorySegmentViewController.m
//  MobileVoip
//
//  Created by Liu Yang on 16/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETHistorySegmentViewController.h"
#import "VETHistoryMainView.h"
#import "DBUtil.h"
#import "VETHistoryTableView.h"
#import "VETVoip.h"
#import "LYAlertViewHelper.h"
#import "VETOutgoingCallingViewController.h"
#import "VETCallHelper.h"
#import "VETResultsContactsController.h"
#import "VETContactHelper.h"
#import "AddContactsCell.h"
#import "VETAppleContact.h"
#import "ChineseToPinyin.h"
#import "VETContactDetailViewController.h"
#import "VETContactFavoriteView.h"
#import "VETAddContactViewController.h"
#import "VETDialpadViewController.h"
#import "VETAccount.h"
#import "VETReconnectHelper.h"
#import "VETGCDTimerHelper.h"
#import "VETSearchAreaCodeManager.h"
#import "PermissionObj.h"
#import "SectionIndexTitleView.h"

@interface VETHistorySegmentViewController ()
           <UITableViewDelegate,
            UITableViewDataSource,
            UISearchBarDelegate,
            UISearchControllerDelegate,
            UISearchResultsUpdating,
            VETHistoryTableViewDelegate,
            SectionIndexTitleViewDelegate,
            VETResultsContactsDidSelectedDismissDelegate>
{
    BOOL  _isLoosenDeleteBtn;
    BOOL  _isReconectCancled;
}
@property (nonatomic, retain) UIBarButtonItem *editBarButton;
@property (nonatomic, retain) UIBarButtonItem *contatcEditBarButton;
@property (nonatomic, retain) UIBarButtonItem *cancelBarButton;
@property (nonatomic, retain) UIBarButtonItem *deleteAllBarButton;
@property (nonatomic, retain) UISegmentedControl *segmentControl;

@property (nonatomic, retain) NSArray *allHistoryArray;
@property (nonatomic, retain) NSArray *missedHistoryArray;

@property (nonatomic, strong) UIScrollView *scrrollView;
@property (nonatomic, retain) VETHistoryTableView *tableView;
@property (nonatomic, retain) UITableView *contactTableView;
@property (nonatomic, strong) SectionIndexTitleView *sectionTitleView;

@property (strong, nonatomic) NSMutableArray *dataSourceBySection;// 二维数组
@property (strong, nonatomic) NSMutableArray *sectionTitles;// section标题
@property (strong, nonatomic) NSArray *favorityArray;// 收藏的联系人
@property (strong, nonatomic) NSMutableArray *allData;// 一维数组（搜索用）
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) VETResultsContactsController *resultsTableController;

@property (nonatomic, strong) UIButton *bottomView;//底部视图

//当前用户
@property (nonatomic, strong) VETVoipAccount *currentVoipAccount;
@property (strong, readwrite, nonatomic) dispatch_source_t longDeleteBtnTimer;
@property (strong, readwrite, nonatomic) dispatch_source_t connectTimer;

@end

@implementation VETHistorySegmentViewController

- (void)dealloc
{
    [self removeNotification];
    NSLog(@"VETHistorySegmentViewController界面释放成功");
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self setupViews];
    
    [self initData];
    
    [self addNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
    [self hideNavigationBarColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)setupViews
{
    _isLoosenDeleteBtn = YES;
    _cancelBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    _editBarButton = [[UIBarButtonItem alloc] initWithTitle:[CommenUtil LocalizedString:@"Common.Edit"] style:UIBarButtonItemStylePlain target:self action:@selector(tapEditButton:)];
    _contatcEditBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add-contact"] style:UIBarButtonItemStylePlain target:self action:@selector(contactEditAction:)];
    _deleteAllBarButton = [[UIBarButtonItem alloc] initWithTitle:[CommenUtil LocalizedString:@"Common.Empty"] style:UIBarButtonItemStylePlain target:self action:@selector(tapDeleteAllButton:)];
    
    _segmentControl = [[UISegmentedControl alloc] initWithItems:@[[CommenUtil LocalizedString:@"Call.History"],[CommenUtil LocalizedString:@"Call.Contact"]]];
    [_segmentControl addTarget:self action:@selector(tapSegment:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName];
    [_segmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    _segmentControl.selectedSegmentIndex = 0;

    self.navigationItem.rightBarButtonItem = _editBarButton;
    self.navigationItem.leftBarButtonItem = _cancelBarButton;
    self.navigationItem.titleView = _segmentControl;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;//设置不延伸到边缘
    self.automaticallyAdjustsScrollViewInsets = YES;//设置不从最顶部开始
    self.extendedLayoutIncludesOpaqueBars = YES;//处理searchBar跳动问题
    [self.view addSubview:self.scrrollView];
    [self.view addSubview:self.bottomView];
}

- (void)initData
{
    _dataSourceBySection = [NSMutableArray array];
    _sectionTitles = [NSMutableArray array];
    _allData = [NSMutableArray array];
    
    [self refreshHistory];
    [self showPermissionObj];
    [self queryFavorityContact];
}


#pragma mark - VETResultsContactsDidSelectedDismissDelegate

- (void)didSelectedDismiss:(VETAppleContact *)contact
{
    VETContactDetailViewController *detailContactVC = [VETContactDetailViewController new];
    detailContactVC.contact = contact;
    self.searchController.active = NO;
    [self.navigationController pushViewController:detailContactVC animated:YES];
}

- (void)resultsContactsHideKeyboard
{
    [self.searchController.searchBar resignFirstResponder];
}

- (void)searchControllerDissmiss
{
    self.searchController.active = NO;
}

#pragma mark - SectionIndexTitleViewDelegate

- (void)scrollTableSectionWithSectionIndex:(NSInteger)sectionIndex
{
    NSInteger sectionCount = [_dataSourceBySection count];
    if (_favorityArray.count > 0) {
        sectionCount = sectionCount + 1;
        sectionIndex = sectionIndex + 1;
    }
    if (sectionIndex < sectionCount) {
        NSLog(@"----点击的sectionIndex下标%ld",sectionIndex);
        NSInteger rowIndex = sectionIndex;
        if (_favorityArray.count > 0) {
            if (sectionIndex == 0) {
                rowIndex = _favorityArray.count + 1;
            } else {
                rowIndex = [[_dataSourceBySection objectAtIndex:(sectionIndex - 1)] count];
            }
        } else {
            rowIndex = [[_dataSourceBySection objectAtIndex:(sectionIndex)] count];
        }
        if (rowIndex > 0) {
            [_contactTableView scrollToRow:0 inSection:sectionIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
        } else {
            NSLog(@"出错啦");
        }
    }
}

#pragma mark - Event

//点击键盘按钮
- (void)keyPadAction:(UIButton *)sender
{
    VETDialpadViewController *dialPadVc = [[VETDialpadViewController alloc] init];
    dialPadVc.recoderStatus = self.status;
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.navigationController pushViewController:dialPadVc animated:YES];
    } else {
        [self.navigationController pushViewController:dialPadVc animated:YES];
    }
}

- (void)cancelAction:(id)sender
{
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)contactEditAction:(id)sender
{
    [self addContactButton];
}

- (void)tapEditButton:(id)sender
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    _editBarButton.title = self.tableView.editing ? [CommenUtil LocalizedString:@"Common.Done"] : [CommenUtil LocalizedString:@"Common.Edit"];
    self.navigationItem.leftBarButtonItem = self.tableView.editing ? _deleteAllBarButton : _cancelBarButton;
}

- (void)tapDeleteAllButton:(id)sender
{
    if (_segmentControl.selectedSegmentIndex == 0) {
        [[DBUtil sharedManager] deleteAllRecentContactsRecordByLoginMobNum:[[VETUserManager sharedInstance] currentUsername]];
        [self refreshHistory];
    }
}

#pragma mark - private

/*
 *  刷新编辑按钮，若换页则取消编辑状态
 */
- (void)cancelEditButtonOrNot
{
    if (self.tableView.editing) {
        [self.tableView setEditing:NO animated:YES];
    }
    _editBarButton.title = [CommenUtil LocalizedString:@"Common.Edit"];
    self.navigationItem.rightBarButtonItem = _editBarButton;
    self.navigationItem.leftBarButtonItem = _cancelBarButton;
}

//点击联系人更换右上角编辑按钮
- (void)showContactEditButton
{
    if (self.tableView.editing) {
        [self.tableView setEditing:NO animated:YES];
    }
    self.navigationItem.leftBarButtonItem = _cancelBarButton;
    self.navigationItem.rightBarButtonItem = _contatcEditBarButton;
}

- (void)refreshHistory
{
    NSLog(@"----当前用户名%@",[[VETUserManager sharedInstance] currentUsername]);
    NSArray *array = [[DBUtil sharedManager] findAllRecentContactsRecordByLoginMobNum:[[VETUserManager sharedInstance] currentUsername]];
    self.allHistoryArray = [NSMutableArray arrayWithArray:array];
    self.tableView.dataArray = self.allHistoryArray;
    [self.tableView reloadData];
}

#pragma mark - VETHistoryTableView delagate

- (void)historyTableView:(VETHistoryTableView *)tableView withPhone:(NSString *)phone type:(VETHistoryTableViewType)type {
    //    [[VETCallHelper sharedInstance] callWithPhone:phone withTarget:self];
}

- (void)historyTableView:(VETHistoryTableView *)tableView didSelectRow:(VETCallRecord *)callRecord type:(VETHistoryTableViewType)type {
    [VETCallHelper outgoingWithPhoneString:callRecord.account target:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VETHistoryViewControllerRefreshHistoryNotification object:nil];
}

- (void)historyTableView:(VETHistoryTableView *)tableView didDeleteRow:(NSIndexPath *)indexPath record:(VETCallRecord *)callRecord type:(VETHistoryTableViewType)type
{
    [[DBUtil sharedManager] deleteRecentContactRecordById:callRecord.dbId];
    [self refreshHistory];
}

#pragma mark - ContactTableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //  显示收藏栏
    if (_favorityArray.count > 0) {
        return [_dataSourceBySection count] + 1;
    }
    return [_dataSourceBySection count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //  有收藏栏情况
    if (_favorityArray.count > 0) {
        if (section == 0) {
            return _favorityArray.count + 1;
        }
        else {
            return [[_dataSourceBySection objectAtIndex:(section - 1)] count];
        }
    }
    return [[_dataSourceBySection objectAtIndex:(section)] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AddFriendCell";
    AddContactsCell *cell = (AddContactsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AddContactsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    VETAppleContact *contact;
    if (_favorityArray.count > 0) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            contact = [_favorityArray objectAtIndex:indexPath.row];
            return [self setupFavoriteCell:tableView indexpath:indexPath];
        }
        else if (indexPath.section == 0) {
            contact = [_favorityArray objectAtIndex:indexPath.row - 1];
        }
        else {
            contact = [_dataSourceBySection objectAtIndex:indexPath.section - 1][indexPath.row];
        }
    }
    else {
        contact = [_dataSourceBySection objectAtIndex:indexPath.section][indexPath.row];
    }
    cell.contact = contact;
    cell.callBtn.selectIndexpath = indexPath;
    [cell.callBtn addTarget:self action:@selector(tapCallBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (UITableViewCell *)setupFavoriteCell:(UITableView *)tableView indexpath:(NSIndexPath *)indexpath
{
    static NSString *CellIdentifier = @"favoriteCell";
    AddContactsCell *cell = (AddContactsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AddContactsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.imgV.image = [UIImage imageNamed:@"contact_favorite"];
    cell.lb_up.text = [CommenUtil LocalizedString:@"Call.Favorites"];
    cell.callBtn.hidden = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSInteger newSection = section;
    // 收藏栏headerview height
    if (_favorityArray.count > 0) {
        if (section == 0) {
            return 0.0;
        }
        else {
            newSection = section - 1;
        }
    }
    if ([[_dataSourceBySection objectAtIndex:(newSection)] count] == 0) {
        return 0.01;
    }
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSInteger newSection = section;
    // 收藏栏headerview
    if (_favorityArray.count > 0) {
        if (section == 0) {
            VETContactFavoriteView *view = [[VETContactFavoriteView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 06.0)];
            return view;
        }
        else {
            newSection = section - 1;
        }
    }
    if ([[_dataSourceBySection objectAtIndex:(newSection)] count] == 0){
        return nil;
    }
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:RGBCOLOR(0xf2, 0xf2, 0xf2)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    [label setText:[self.sectionTitles objectAtIndex:(newSection)]];
    [contentView addSubview:label];
    return contentView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VETAppleContact *contact;
    // did select result contacts list
    if (tableView == self.resultsTableController.tableView) {
        contact = [self.resultsTableController.filteredContacts objectAtIndex:indexPath.row];
    }
    // did select contacts list
    else {
        if (_favorityArray.count > 0) {
            // favorite提示页
            if (indexPath.section == 0 && indexPath.row == 0) {
                return;
            }
            // 收藏的Contact
            else if (indexPath.section == 0) {
                contact = _favorityArray[indexPath.row - 1];
            }
            else {
                contact = [_dataSourceBySection objectAtIndex:indexPath.section - 1][indexPath.row];
            }
        }
        else {
            contact = [_dataSourceBySection objectAtIndex:indexPath.section][indexPath.row];
        }
    }
    VETContactDetailViewController *detailContactVC = [VETContactDetailViewController new];
    detailContactVC.contact = contact;
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.navigationController pushViewController:detailContactVC animated:YES];
    } else {
        [self.navigationController pushViewController:detailContactVC animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchController.searchBar resignFirstResponder];
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return [self getSectionIndexArray];
//}

- (NSArray *)getSectionIndexArray
{
    NSMutableArray * existTitles = [NSMutableArray array];
    //section数组为空的title过滤掉，不显示
    for (int i = 0; i < [self.sectionTitles count]; i++) {
        if (![_dataSourceBySection count]) break;
        if ([_dataSourceBySection count] > i && [[_dataSourceBySection objectAtIndex:i] count] > 0) {
            [existTitles addObject:[self.sectionTitles objectAtIndex:i]];
        }
    }
    return existTitles;
}

#pragma mark - Contact dataSource

- (void)showPermissionObj
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"contactPermission"]) {
        [self showAleartVcWithTitle:[CommenUtil LocalizedString:@"Call.MatchingContacts"] withMessage:[CommenUtil LocalizedString:@"Call.ContactPermissionMsg"] withTureBlock:^{
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"contactPermission"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self showContactPermission];
        } withCancelBlock:^{
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"contactPermission"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.contactTableView addSubview:[self getNoPermissionLable:[CommenUtil LocalizedString:@"Call.RefusedContactMatch"]]];
        }];
    } else {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"contactPermission"] isEqualToString:@"1"]) {
            [self showContactPermission];
        } else {
            [self.contactTableView addSubview:[self getNoPermissionLable:[CommenUtil LocalizedString:@"Call.RefusedContactMatch"]]];
        }
    }
}

- (void)showContactPermission
{
    __block VETHistorySegmentViewController *blockSelf = self;
    [[PermissionObj sharedInstance] getContactPermission:^(BOOL isPermission) {
        if (!isPermission) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [blockSelf showPermission:[CommenUtil LocalizedString:@"Call.Contacts"]];
                [blockSelf.contactTableView addSubview:[blockSelf getNoPermissionLable:[CommenUtil LocalizedString:@"Call.ContactPerNotOpen"]]];
            });
        } else {
            [blockSelf getAddressBook];
        }
    }];
}

- (void)getAddressBook
{
    [_dataSourceBySection removeAllObjects];
    [_allData removeAllObjects];
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_0) {
        [VETContactHelper getContactsBigiOS9WithCompletion:^(NSArray *arr) {
             NSArray *excludeFavoritedContact = [self excludeFavoritedContact:arr];
             [_dataSourceBySection addObjectsFromArray:[self sortDataArray:excludeFavoritedContact]];   // 显示Cell
             [_allData addObjectsFromArray:arr]; // 搜索用
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self removeNotiLable];
                 [self.contactTableView reloadData];
                 [self.sectionTitleView updataUI:[self getSectionIndexArray]];
             });
         } error:^(VETContactsErrorType errorType, NSError *error) {
             if (errorType == VETContactsErrorTypeNotGranted) {
                 [self.contactTableView addSubview:[self getNoPermissionLable:[CommenUtil LocalizedString:@"Call.ContactPerNotOpen"]]];
                 return;
             }
         }];
    }
    else {
        [VETContactHelper getContactsSmalliOS9WithCompletion:^(NSArray *arr) {
            NSArray *excludeFavoritedContact = [self excludeFavoritedContact:arr];
            [_dataSourceBySection addObjectsFromArray:[self sortDataArray:excludeFavoritedContact]]; // 显示Cell
            [_allData addObjectsFromArray:arr]; // 搜索用
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeNotiLable];
                [self.contactTableView reloadData];
                [self.sectionTitleView updataUI:[self getSectionIndexArray]];
            });
        } error:^(VETContactsErrorType errorType, NSError *error) {
            if (errorType == VETContactsErrorTypeNotGranted) {
                [self.contactTableView addSubview:[self getNoPermissionLable:[CommenUtil LocalizedString:@"Call.ContactPerNotOpen"]]];
                return;
            }
        }];
    }
}

- (UIView *)getNoPermissionLable:(NSString *)msg
{
    [self removeNotiLable];
    
    UILabel *notiLb = [[UILabel alloc] initWithFrame:CGRectMake(20, (screenHeight-100-STATUS_AND_NAVIGATION_HEIGHT)/2, SCREEN_WIDTH - 20 * 2, 100)];
    notiLb.text = msg;
    notiLb.tag = 1111;
    notiLb.textAlignment = NSTextAlignmentCenter;
    notiLb.textColor = [UIColor lightGrayColor];
    notiLb.numberOfLines = 0;
    notiLb.font = [UIFont systemFontOfSize:20.0];
    notiLb.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactSetupPermission)];
    [notiLb addGestureRecognizer:tap];
    return notiLb;
}

- (void)removeNotiLable
{
    UILabel *lbl = [self.contactTableView viewWithTag:1111];
    if (lbl) {
        [lbl removeFromSuperview];
    }
}

- (void)contactSetupPermission
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"contactPermission"] isEqualToString:@"0"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"contactPermission"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self showContactPermission];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }
}

/*
 * 排除已收藏的Contact，收藏的Contact显示第一行。
 */
- (NSArray *)excludeFavoritedContact:(NSArray *)array
{
    NSArray *favoritedContactArr = [[DBUtil sharedManager] queryFavoritedContact];
    
    NSMutableArray *excludeFavoritedContactArr = @[].mutableCopy;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VETAppleContact *contact = (VETAppleContact *)obj;
        BOOL isFavoriteContact = NO;
        for (VETAppleContact *favoriteContact in favoritedContactArr) {
            if ([contact.fullName isEqualToString:favoriteContact.fullName]) {
                isFavoriteContact = YES;
            }
        }
        if (!isFavoriteContact) {
            [excludeFavoritedContactArr addObject:contact];
        }
    }];
    return [excludeFavoritedContactArr copy];
}

/*!
 *  排序
 */
- (NSMutableArray *)sortDataArray:(NSArray *)dataArray
{
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObject:@"@"];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //名字分section
    for (VETAppleContact *contact in dataArray) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:contact.fullName];
        if (firstLetter && firstLetter.length > 0 && sortedArray && sortedArray.count > 0)
        {
            NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
            NSMutableArray *array = [sortedArray objectAtIndex:section + 1];
            [array addObject:contact];
        }
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(VETAppleContact *obj1, VETAppleContact *obj2) {
            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1.fullName];
            if (firstLetter1 && firstLetter1.length > 1)
            {
                firstLetter1 = [[firstLetter1 substringWithRange:NSMakeRange(1, 1)] uppercaseString];
            }
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2.fullName];
            if (firstLetter2 && firstLetter2.length > 1)
            {
                firstLetter2 = [[firstLetter2 substringWithRange:NSMakeRange(1, 1)] uppercaseString];
            }
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    return sortedArray;
}

- (void)tapCallBtn:(id)sender
{
    self.searchController.active = NO;
    PLCustomCellBtn *btn = (PLCustomCellBtn*)sender;
    NSIndexPath *indexPath = btn.selectIndexpath;
    
    VETAppleContact *contacts;
    // did select result contacts
    if (self.tableView == self.resultsTableController.tableView) {
        contacts = [self.resultsTableController.filteredContacts objectAtIndex:indexPath.row];
    }
    // did select contacts list
    else {
        if (_favorityArray.count > 0) {
            // favorite提示页
            if (indexPath.section == 0 && indexPath.row == 0) {
                return;
            }
            // 收藏的Contact
            else if (indexPath.section == 0) {
                contacts = _favorityArray[indexPath.row - 1];
            }
            else {
                contacts = [_dataSourceBySection objectAtIndex:indexPath.section - 1][indexPath.row];
            }
        }
        else {
            contacts = [_dataSourceBySection objectAtIndex:indexPath.section][indexPath.row];
        }
    }
    
    [self.phoneDelegate selectPhone:contacts.mobileArray];
    if (!(contacts.mobileArray.count > 0)) return;
    
    // 多个手机号显示ActionSheet
    if (contacts.mobileArray.count > 1) {
        UIAlertController *actionSheet = [[UIAlertController alloc] init];
        for (VETMobileModel *mobileModel in contacts.mobileArray) {
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:mobileModel.mobileContent style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [VETCallHelper outgoingWithPhoneString:mobileModel.mobileContent target:self];
            }];
            [actionSheet addAction:action1];
        }
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Common.Cancle"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [actionSheet addAction:actionCancel];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    // 只有一个手机号
    else {
        VETMobileModel *mobileModel = contacts.mobileArray[0];
        NSString *callPhone = mobileModel.mobileContent;
        [VETCallHelper outgoingWithPhoneString:callPhone target:self];
    }
}

- (void)addContactButton
{
    VETAddContactViewController *addContactVC = [VETAddContactViewController new];
    if (self.searchController.active) self.searchController.active = NO;
    [self.navigationController pushViewController:addContactVC animated:YES];
}

#pragma mark - searchbar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar becomeFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchText = searchController.searchBar.text;
    if (!searchText || !searchText.length) {
        return;
    }
    
    NSMutableArray *searchResults = [_allData mutableCopy];
    
    //  去除首尾空格
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //  break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    // build all the "AND" expressions for each value in the searchString
    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    
    for (NSString *searchString in searchItems) {
        //        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
        
        NSExpression *lhs = [NSExpression expressionForKeyPath:@"searchText"];
        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
        
        NSPredicate *finalPredicate = [NSComparisonPredicate predicateWithLeftExpression:lhs
                                                                         rightExpression:rhs
                                                                                modifier:NSDirectPredicateModifier
                                                                                    type:NSContainsPredicateOperatorType
                                                                                 options:NSCaseInsensitivePredicateOption];
        [andMatchPredicates addObject:finalPredicate];
    }
    
    NSCompoundPredicate *finalCompoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
    
    _resultsTableController.filteredContacts = searchResults;
    [_resultsTableController.tableView reloadData];
}

- (void)presentSearchController:(UISearchController *)searchController {
    //      self.tableView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0);
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
    _scrrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - bottomHeight);
    _scrrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT - bottomHeight);
    if (IOS_VERSION >= 11) {
        _scrrollView.contentInset = UIEdgeInsetsMake(-16, 0, 0, 0);
    }
    _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(_scrrollView.frame));
    _contactTableView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(_scrrollView.frame));
    _resultsTableController.tableView.frame = CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_AND_NAVIGATION_HEIGHT);
    _bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.scrrollView.frame), SCREEN_WIDTH, bottomHeight);
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    [self changebarWhiteStyle:NO];
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    _scrrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - bottomHeight);
    _scrrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - bottomHeight);
    if (IOS_VERSION >= 11) {
        _scrrollView.contentInset = UIEdgeInsetsMake(0, 0, -20, 0);
    }
    _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(_scrrollView.frame));
    _contactTableView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(_scrrollView.frame));
    _resultsTableController.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_AND_NAVIGATION_HEIGHT-bottomHeight);
    _bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.scrrollView.frame), SCREEN_WIDTH, bottomHeight);
    [self changebarWhiteStyle:YES];
}

#pragma mark - reload contact notification

- (void)reloadAdressBook:(id)noti
{
    [self getAddressBook];
    [self queryFavorityContact];
}

#pragma mark - query favority contact

- (void)queryFavorityContact
{
    NSArray *contactArray = [[DBUtil sharedManager] queryFavoritedContact];
    if (contactArray && [contactArray isKindOfClass:[NSArray class]] && contactArray.count > 0) {
        _favorityArray = contactArray;
        [self.contactTableView reloadData];
    }
    // 刚取消所有收藏，也需要刷新。
    else {
        _favorityArray = nil;
        [self.contactTableView reloadData];
    }
}

#pragma mark - segment event 

- (void)tapSegment:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    NSInteger index = segment.selectedSegmentIndex;
    _scrrollView.contentOffset = CGPointMake(SCREEN_WIDTH*index, 0);
    if (segment.selectedSegmentIndex == 0) {
        NSLog(@"tapHistory");
        [self jumpToHistoryEvent];
    }
    else {
        NSLog(@"tapContact");
        [self jumpToContactEvent];
    }
}

- (void)jumpToContactEvent
{
    [self showContactEditButton];
}

- (void)jumpToHistoryEvent
{
    [self cancelEditButtonOrNot];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHistory) name:VETHistoryViewControllerRefreshHistoryNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAdressBook:) name:kVETViewControllerRefreshContactNotification object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:VETHistoryViewControllerRefreshHistoryNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kVETViewControllerRefreshContactNotification object:nil];
}

#pragma mark - Getter

- (UIScrollView *)scrrollView
{
    if (!_scrrollView) {
        _scrrollView = [[UIScrollView alloc] init];
        _scrrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - bottomHeight);
        _scrrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT- STATUS_AND_NAVIGATION_HEIGHT - bottomHeight);
        _scrrollView.scrollEnabled = NO;
        _scrrollView.showsVerticalScrollIndicator = NO;
        _scrrollView.showsHorizontalScrollIndicator = NO;
        
        [_scrrollView addSubview:self.tableView];
        [_scrrollView addSubview:self.contactTableView];
        [_scrrollView addSubview:self.sectionTitleView];
    }
    return _scrrollView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[VETHistoryTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.scrrollView.frame))];
        _tableView.historyDelegate = self;
    }
    return _tableView;
}

- (UITableView *)contactTableView
{
    if (!_contactTableView) {
        _contactTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(self.scrrollView.frame))];
        if (IOS_VERSION >= 11.0) {
            adjustsScrollViewInsets_NO(_contactTableView, self);
        }
        _contactTableView.delegate = self;
        _contactTableView.dataSource = self;
        _contactTableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _contactTableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        _contactTableView.tableFooterView = [UIView new];
        _contactTableView.tableHeaderView = self.searchController.searchBar;
        [_contactTableView registerClass:NSClassFromString(@"AddContactCell") forCellReuseIdentifier:@"AddContactCell"];
    }
    return _contactTableView;
}

- (SectionIndexTitleView *)sectionTitleView
{
    if (!_sectionTitleView) {
        _sectionTitleView = [[SectionIndexTitleView alloc] initWithFrame:CGRectMake(screenWidth*2-15, 0, 15, screenHeight) withIndexArray:[self getSectionIndexArray]];
        _sectionTitleView.delegate = self;
    }
    return _sectionTitleView;
}

- (UISearchController *)searchController
{
    if (!_searchController) {
        _resultsTableController = [[VETResultsContactsController alloc] init];
        _resultsTableController.tableView.delegate = self;
        _resultsTableController.delegate = self;
        
        _searchController = [[UISearchController alloc] initWithSearchResultsController:_resultsTableController];
        _searchController.delegate = self;
        _searchController.searchResultsUpdater = self;
        _searchController.obscuresBackgroundDuringPresentation = NO;
        
        _searchController.searchBar.delegate = self;
        _searchController.searchBar.frame = CGRectMake(0, 0, screenWidth, 44);
    }
    return _searchController;
}

- (UIButton *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.scrrollView.frame), SCREEN_WIDTH, bottomHeight);
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView addTarget:self action:@selector(keyPadAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_bottomView addSubview:[self getLineViewWithRect:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)]];
        
        float callTextHeight = [CommenUtil getHeightWithContent:[CommenUtil LocalizedString:@"Call.Dialpad"] withWidth:SCREEN_WIDTH withFont:[UIFont systemFontOfSize:16 weight:UIFontWeightLight]];
        
        UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-29)/2, (bottomHeight-(callTextHeight+29+5))/2, 29, 29)];
        bottomImageView.clipsToBounds = YES;
        bottomImageView.image = [UIImage imageNamed:@"keypad"];
        [_bottomView addSubview:bottomImageView];
        
        UILabel *callLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bottomImageView.frame)+5, SCREEN_WIDTH, callTextHeight)];
        callLable.text = [CommenUtil LocalizedString:@"Call.Dialpad"];
        callLable.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
        callLable.textAlignment = NSTextAlignmentCenter;
        [_bottomView addSubview:callLable];
    }
    return _bottomView;
}


@end
