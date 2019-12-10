//
//  VETCountryViewController.m
//  VETEphone
//
//  Created by Liu Yang on 28/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import "VETCountryViewController.h"
#import "VETCountryCell.h"
#import "VETResultCountryController.h"
#import "SectionIndexTitleView.h"

@interface VETCountryViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating,SectionIndexTitleViewDelegate>
{
    BOOL _popViewController;
}
@property (nonatomic, strong) UILabel *titlelable;
@property (nonatomic, strong) SectionIndexTitleView *sectionTitleView;
@property (nonatomic, copy) NSMutableArray *sectionTitleArray;
@property (nonatomic, copy) NSArray *dataSourcesArrayBySection;
@property (nonatomic, copy) NSArray *allDataSources;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) VETResultCountryController *resultsTableController;

@end

@implementation VETCountryViewController

- (void)dealloc
{
//    [self.searchController.view removeFromSuperview]; // It works!
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self setupDatas];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.sectionTitleView removeFromSuperview];
    self.sectionTitleView = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)setupDatas{
    _sectionTitleArray = [NSMutableArray new];
    _dataSourcesArrayBySection = [NSMutableArray new];
    
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"CountryCodes" ofType:@"plist"];
    NSDictionary *countryDic = [NSDictionary dictionaryWithContentsOfFile:pathStr];
    
    NSMutableArray *countryArray = @[].mutableCopy;
    [countryDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSArray *countryArr = (NSArray *)obj;
        // Key为字母.无视
        for (NSDictionary *dic in countryArr) {
            VETCountry *country = [[VETCountry alloc] initWithCode:[dic objectForKey:@"code"]
                                                          shouzimu:[dic objectForKey:@"shouzimu"]
                                                              icon:[dic objectForKey:@"icon"]
                                                            pinyin:[dic objectForKey:@"pinyin"]
                                                countryEnglishName:[dic objectForKey:@"countryEnglishName"] countryChineseName:[dic objectForKey:@"countryChineseName"]];
            [countryArray addObject:country];
        }
    }];
    _dataSourcesArrayBySection = [self sortArray:[countryArray copy]];
    _allDataSources = [countryArray copy];
    
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    [self.sectionTitleArray removeAllObjects];
    [self.sectionTitleArray addObjectsFromArray:[indexCollation sectionTitles]];
    //删除#号索引
    [self.sectionTitleArray removeLastObject];
    
    [self.tableView reloadData];
    [self.sectionTitleView updataUI:[self getSectionIndexArray]];
}

- (void)setupViews
{
    //  title view
    float titleWidth = [CommenUtil getWidthWithContent:[CommenUtil LocalizedString:@"Call.SelectCountry"] height:STATUS_AND_NAVIGATION_HEIGHT font:18];
    _titlelable = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth-titleWidth)/2, 0, titleWidth, STATUS_AND_NAVIGATION_HEIGHT)];
    _titlelable.text = [CommenUtil LocalizedString:@"Call.SelectCountry"];
    _titlelable.font = FT(18);
    _titlelable.textColor = [UIColor whiteColor];
    _titlelable.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = _titlelable;
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];

    //  search bar
    _resultsTableController = [[VETResultCountryController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_resultsTableController];
    
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.resultsTableController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.frame = CGRectMake(0, 0, screenWidth, 44);
    [self.searchController loadViewIfNeeded];
    
    if (IOS_VERSION >= 11.0) {
        //adjustsScrollViewInsets_NO(self.tableView, self);
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
        [self.tableView adjustedContentInsetDidChange];
    }
    
    [SharedApp.window addSubview:self.sectionTitleView];
}

#pragma mark - SectionIndexTitleViewDelegate

- (void)scrollTableSectionWithSectionIndex:(NSInteger)sectionIndex
{
    NSInteger newSectionIndex = sectionIndex - 1;
    NSInteger sectionCount = [_dataSourcesArrayBySection count];
    if (newSectionIndex < sectionCount) {
        NSLog(@"----点击的sectionIndex下标%ld",sectionIndex);
        NSInteger rowIndex = [[_dataSourcesArrayBySection objectAtIndex:(sectionIndex)] count];
        if (rowIndex > 0) {
            [self.tableView scrollToRow:0 inSection:newSectionIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
        } else {
            NSLog(@"出错啦");
        }
    }
}

#pragma mark - UITableView DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_dataSourcesArrayBySection objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataSourcesArrayBySection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    VETCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[VETCountryCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    VETCountry *country = [_dataSourcesArrayBySection objectAtIndex:indexPath.section][indexPath.row];
    [self configCell:cell forCountryInfo:country atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VETCountry *country;
    if (tableView == self.resultsTableController.tableView) {
        country = self.resultsTableController.filteredCountry[indexPath.row];
    }
    else {
        country = [_dataSourcesArrayBySection objectAtIndex:indexPath.section][indexPath.row];
    }
    if (self.isSaveCountry) {
        [[VETUserManager sharedInstance] settingCountry:country];
    }
    
    if (self.countryBlock) {
        self.countryBlock(country);
    }
    
    if (self.searchController.active) {
        _popViewController = YES;
        [self.searchController dismissViewControllerAnimated:YES completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([[_dataSourcesArrayBySection objectAtIndex:(section)] count] == 0){
        return 0;
    }
    else{
        return 22;
    }}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return [self getSectionIndexArray];
//}

- (NSArray *)getSectionIndexArray
{
    NSMutableArray * existTitles = [NSMutableArray array];
    //section数组为空的title过滤掉，不显示
    for (int i = 0; i < [self.sectionTitleArray count]; i++) {
        if (![_dataSourcesArrayBySection count]) break;
        if ([_dataSourcesArrayBySection count] > i && [[_dataSourcesArrayBySection objectAtIndex:i] count] > 0) {
            [existTitles addObject:[self.sectionTitleArray objectAtIndex:i]];
        }
    }
    return self.sectionTitleArray;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([[_dataSourcesArrayBySection objectAtIndex:(section)] count] == 0){
        return nil;
    }
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:RGBCOLOR(0xf2, 0xf2, 0xf2)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 22)];
    label.textColor = MAINTHEMECOLOR;
    [label setText:[self.sectionTitleArray objectAtIndex:(section)]];
    [contentView addSubview:label];
    return contentView;
}

#pragma mark - private method

- (NSArray *)sortArray:(NSArray *)arr
{
    // 建立索引
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    [self.sectionTitleArray removeAllObjects];
    [self.sectionTitleArray addObjectsFromArray:[indexCollation sectionTitles]];
    
    // 返回27，是a-z和#
    NSInteger highSection = [self.sectionTitleArray count];
    
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (NSUInteger i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    for (VETCountry *country in arr) {
        if (country.sortText && country.sortText.length > 0) {
            NSMutableArray *array = [sortedArray objectAtIndex:0];
            [array addObject:country];
        }
        else {
            NSString *firstLetter = country.countryEnglishName;
            if (firstLetter && firstLetter.length > 0 && sortedArray && sortedArray.count > 0)
            {
                NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
                NSMutableArray *array = [sortedArray objectAtIndex:section + 1];
                [array addObject:country];
            }
        }
    }
    
    for (NSUInteger i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(VETCountry *obj1, VETCountry *obj2) {
            NSString *firstLetter = obj1.countryEnglishName;
            NSString *secondLetter = obj2.countryEnglishName;
            if (firstLetter && firstLetter.length > 0) {
                firstLetter = [[firstLetter substringWithRange:NSMakeRange(1, 1)] uppercaseString];
            }
            
            if (secondLetter && secondLetter.length > 0) {
                secondLetter = [[secondLetter substringWithRange:NSMakeRange(1, 1)] uppercaseString];
            }
            return [firstLetter caseInsensitiveCompare:secondLetter];
        }];
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    // 删除第一个#号索引
    [sortedArray removeObjectAtIndex:0];
    return [sortedArray copy];
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
    NSMutableArray *searchResults = [_allDataSources mutableCopy];
    
    //  去除首尾空格
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //  break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    // build all the "AND" expressions for each value in the searchString
    //
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
        //        [searchItemsPredicate addObject:finalPredicate];
        
        //        NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
        [andMatchPredicates addObject:finalPredicate];
    }
    
    NSCompoundPredicate *finalCompoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
    
    VETResultCountryController *resultController = (VETResultCountryController *)self.searchController.searchResultsController;
    resultController.filteredCountry = searchResults;
    [resultController.tableView reloadData];
}

- (void)presentSearchController:(UISearchController *)searchController {
//      self.tableView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0);
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
    self.navigationController.navigationBar.translucent = YES;
    if (IOS_VERSION >= 11) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways ;
        [self.tableView adjustedContentInsetDidChange];
    }
}

-(void)willDismissSearchController:(UISearchController *)searchController
{
    self.navigationController.navigationBar.translucent = NO;
    if (IOS_VERSION >= 11) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        [self.tableView adjustedContentInsetDidChange];
    }
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"didDismissSearchController");
    //[self.navigationController popViewControllerAnimated:YES];
    
}

- (SectionIndexTitleView *)sectionTitleView
{
    if (!_sectionTitleView) {
        _sectionTitleView = [[SectionIndexTitleView alloc] initWithFrame:CGRectMake(screenWidth-15, STATUS_AND_NAVIGATION_HEIGHT, 15, screenHeight) withIndexArray:[self getSectionIndexArray]];
        _sectionTitleView.delegate = self;
    }
    return _sectionTitleView;
}

@end
