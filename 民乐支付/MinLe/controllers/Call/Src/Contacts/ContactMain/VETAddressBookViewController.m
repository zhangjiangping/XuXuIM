//
//  DYContactsListViewController.m
//  DYBluetoothLock
//
//  Created by Young on 15/11/12.
//  Copyright (c) 2015年 youngLiu. All rights reserved.
//

#import "VETAddressBookViewController.h"
#import <MessageUI/MessageUI.h>
#import "ChineseToPinyin.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AddContactsCell.h"
#import "UIColor+FlatColor.h"
#import "VETAddContactViewController.h"
#import "VETResultsContactsController.h"
#import "VETVoip.h"
#import "LYAlertViewHelper.h"
#import <ContactsUI/ContactsUI.h>
#import "VETContactHelper.h"
#import "VETContactDetailViewController.h"
#import "VETAppleContact.h"
#import "DBUtil.h"
#import "VETContactFavoriteView.h"
#import <ChameleonFramework/Chameleon.h>
#import "VETCallHelper.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface VETAddressBookViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>
{
    
}

// 二维数组
@property (strong, nonatomic) NSMutableArray *dataSourceBySection;
// section标题
@property (strong, nonatomic) NSMutableArray *sectionTitles;

// 收藏的联系人
@property (strong, nonatomic) NSArray *favorityArray;

// 一维数组（搜索用）
@property (strong, nonatomic) NSMutableArray *allData;
@property (nonatomic, strong) UISearchController *searchController;
// our secondary search results table view
@property (nonatomic, strong) VETResultsContactsController *resultsTableController;

//@property (nonatomic, retain) UITableView *tableView;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation VETAddressBookViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kVETViewControllerRefreshContactNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self initDatas];
    [self getAddressBook];
    [self queryFavorityContact];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
//    [self.tabBarController.navigationController setNavigationBarHidden:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAdressBook:) name:kVETViewControllerRefreshContactNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.automaticallyAdjustsScrollViewInsets = YES;
//    [self.tabBarController.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBarItem.title = NSLocalizedString(@"Contacts", @"Contacts");
    self.tabBarController.navigationItem.title = NSLocalizedString(@"Contacts", @"Contacts");
    self.tableView.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStyleDone target:self action:@selector(addContactButton)];
    barButton.tintColor = MAINTHEMECOLOR;
    barButton.imageInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.tabBarController.navigationItem.rightBarButtonItem = barButton;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)initDatas
{
    _dataSourceBySection = [NSMutableArray array];
    _sectionTitles = [NSMutableArray array];
    _allData = [NSMutableArray array];
}

- (void)setupViews
{
    //  title view
    self.tabBarController.navigationItem.title = NSLocalizedString(@"Contacts", @"Contacts");;
    
//    _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - TABBARHEIGHT);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //  search bar
    _resultsTableController = [[VETResultsContactsController alloc] init];
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.backgroundColor = RGBCOLOR(0xc9, 0xc9, 0xce);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.view bringSubviewToFront:self.searchController.searchBar];
    
    self.resultsTableController.tableView.delegate = self;
    self.searchController.delegate = self;
//    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
}

#pragma mark - Table view data source

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
//    [self configCell:cell forContacts:contact atIndexPath:indexPath];
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
    cell.lb_up.text = NSLocalizedString(@"Favorites", @"Contacts");
    cell.callBtn.hidden = YES;
    return cell;
}

//- (UITableViewCell *)setupContactCell:(UITableView *)tableView indexpath:(NSIndexPath *)indexpath
//{
//    
//}

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
        return 0;
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    [label setText:[self.sectionTitles objectAtIndex:(newSection)]];
    [contentView addSubview:label];
    return contentView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VETAppleContact *contact;
    // did select result contacts
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
    [self.navigationController pushViewController:detailContactVC animated:YES];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
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

#pragma mark - address book

-(NSString *)handlerTelphone:(NSString *)phone
{
    if (phone.length > 15 || phone.length < 11) {
        return nil;
    }
    NSString *finalPhone;
    /* 如果是+86 */
    NSString *topThree = [phone substringToIndex:3];
    if ([topThree isEqualToString:@"+86"] && phone.length == 14)
    {
        finalPhone = [phone substringFromIndex:3];
    }
    
    /* 如果有- */
    else if (phone.length == 13 && [phone containsString:@"-"]) {
        NSMutableString *phoneStr = [NSMutableString string];
        [phoneStr appendString:[phone substringToIndex:3]];
        [phoneStr appendString:[phone substringWithRange:NSMakeRange(4, 4)]];
        [phoneStr appendString:[phone substringWithRange:NSMakeRange(9, 4)]];
        finalPhone = phoneStr;
    }
    else  finalPhone = phone;
    if (finalPhone.length == 11){
        return finalPhone;
    }
    return nil;
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

#pragma mark - events

- (void)getAddressBook
{
    [_dataSourceBySection removeAllObjects];
    [_allData removeAllObjects];
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_0) {
        [VETContactHelper getContactsBigiOS9WithCompletion:
         ^(NSArray *arr) {
             NSArray *excludeFavoritedContact = [self excludeFavoritedContact:arr];
             [_dataSourceBySection addObjectsFromArray:[self sortDataArray:excludeFavoritedContact]];   // 显示Cell
             [_allData addObjectsFromArray:arr]; // 搜索用
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
             });
        } error:
         ^(VETContactsErrorType errorType, NSError *error) {
             if (errorType == VETContactsErrorTypeNotGranted) {
                 UILabel *notiLb = [[UILabel alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT / 2 - 65, SCREEN_WIDTH - 20 * 2, 42)];
                 notiLb.text = NSLocalizedString(@"Please at setting ""Setting-privacy-addressbook""option,allow vephone visit your address book", @"Contact");
                 notiLb.numberOfLines = 2;
                 notiLb.font=[UIFont systemFontOfSize:14.0];
                 [self.tableView addSubview:notiLb];
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
                [self.tableView reloadData];
            });
        } error:^(VETContactsErrorType errorType, NSError *error) {
            if (errorType == VETContactsErrorTypeNotGranted) {
                UILabel *notiLb = [[UILabel alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT / 2 - 65, SCREEN_WIDTH - 20 * 2, 42)];
                notiLb.text=NSLocalizedString(@"Please at setting ""Setting-privacy-addressbook""option,allow vephone visit your address book", @"Contact");
                notiLb.numberOfLines=2;
                notiLb.font=[UIFont systemFontOfSize:14.0];
                [self.tableView addSubview:notiLb];
                return;
            }
        }];
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

-(void)tapCallBtn:(id)sender
{
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
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Common") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [actionSheet addAction:actionCancel];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    // 只有一个手机号
    else {
        VETMobileModel *mobileModel = contacts.mobileArray[0];
        [VETCallHelper outgoingWithPhoneString:mobileModel.mobileContent target:self];
    }
//    VETMobileModel *mobileModel = [contact.mobileArray firstObject];
//    NSString *callString = [contacts.telsArr firstObject];
//    if (!([[VETVoipManager sharedManager] accounts].count > 0)) {
//        [LYAlertViewHelper alertViewStrongWithTagert:self title:@"" content:NSLocalizedString(@"请登录", @"PhoneView")
//                                        confirmEvent:nil];
//        return;
//    }
//    if (!(callString.length > 0)) {
//        [LYAlertViewHelper alertViewStrongWithTagert:self title:@"" content:NSLocalizedString(@"Mobile phone number can't be empty", @"PhoneView")
//                                        confirmEvent:nil];
//        return;
//    }
//    NSString *mainUsername = [[VETUserManager sharedInstance] mainUsername];
//    
//    VETVoipAccount *account = [[VETVoipManager sharedManager] accountWithUsername:mainUsername];
//    if (!account) {
//        LYLog(@"未设置主帐户.");
//        return;
//    }
//    VETSIPURI *sip = [[VETSIPURI alloc] initWithUser:callString host:account.domain displayName:account.username];
//    
//    [account makeCallTo:sip completion:^(VETVoipCall *call) {
//        if (call) {
//            VETCallingViewController *callingVC = [VETCallingViewController new];
//            callingVC.callPhone = callString;
//            callingVC.type = VETCallingViewControllerCallTypeCallUp;
//            callingVC.call = call;
//            [self presentViewController:callingVC animated:YES completion:nil];
//        }
//    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:VETHistoryViewControllerRefreshHistoryNotification object:nil];
}

- (void)addContactButton
{
    VETAddContactViewController *addContactVC = [VETAddContactViewController new];
    [self.navigationController pushViewController:addContactVC animated:YES];
}

#pragma mark - searchbar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
    self.navigationController.navigationBar.translucent = NO;
}

-(void)willDismissSearchController:(UISearchController *)searchController
{
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - reload contact notification

- (void)reloadAdressBook:(id)notifi
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
        [self.tableView reloadData];
    }
    // 刚取消所有收藏，也需要刷新。
    else {
        _favorityArray = nil;
        [self.tableView reloadData];
    }
}

@end
