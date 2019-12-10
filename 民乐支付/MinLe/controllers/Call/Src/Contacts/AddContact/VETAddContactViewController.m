//
//  VETAddContactViewController.m
//  VETEphone
//
//  Created by Liu Yang on 29/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import "VETAddContactViewController.h"
#import <ContactsUI/ContactsUI.h>
#import "VETContactHelper.h"
#import "VETAppleContact.h"
#import "VETSelectMobileTypeViewController.h"
#import <Contacts/Contacts.h>

/***********************************************************
 *  VETUserInfoCell
 ***********************************************************/
@implementation VETUserInfoCell

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
    /*
     *  头像View
     */
    _avatarView = [UIView new];
    [self.contentView addSubview:_avatarView];
    
    _avatarImageView = [UIImageView new];
    [_avatarView addSubview:_avatarImageView];
    _avatarImageView.image = [UIImage imageNamed:@"avatar"];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    
//    _addLabel = [UILabel new];
//    [_avatarView addSubview:_addLabel];
//    _addLabel.textColor = MAINTHEMECOLOR;
//    _addLabel.text = NSLocalizedString(@"Add", @"Contact");
    
    /*
     *  Name View
     */
    _nameView = [UIView new];
    [self.contentView addSubview:_nameView];
    
    //  Firt name view
    _firstNameView = [UIView new];
    [_nameView addSubview:_firstNameView];

    _firstNameTextfield = [UITextField new];
    [_firstNameView addSubview:_firstNameTextfield];
    _firstNameTextfield.placeholder = [CommenUtil LocalizedString:@"Call.FirstName"];
    
    _line1View = [UIView new];
    [_firstNameView addSubview:_line1View];
    _line1View.backgroundColor = GRAYLINECOLOR;
    
    //  Last name view
    _lastNameView = [UIView new];
    [_nameView addSubview:_lastNameView];
    
    _lastNameTextfield = [UITextField new];
    [_lastNameView addSubview:_lastNameTextfield];
    _lastNameTextfield.placeholder = [CommenUtil LocalizedString:@"Call.LastName"];
    
    _line2View = [UIView new];
    [_lastNameView addSubview:_line2View];
    _line2View.backgroundColor = GRAYLINECOLOR;
}

- (void)setupLayouts
{
    /*
     *  头像View
     */
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(0.3);
    }];
    
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_avatarView.mas_centerX);
        make.top.mas_equalTo(_avatarView).mas_offset(5);
        make.width.mas_equalTo(_avatarImageView.mas_height);
        make.width.mas_equalTo(@70);
    }];
    
//    [_addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_avatarImageView.mas_bottom).mas_offset(5);
//        make.centerX.mas_equalTo(_avatarView.mas_centerX);
//    }];
    
    /*
     *  Name View
     */
    CGFloat textfieldHeight = 55.0;
    [_nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_avatarView.mas_bottom);
        make.left.mas_equalTo(_avatarView).mas_offset(15);
        make.right.mas_equalTo(_avatarView).mas_offset(0);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
    [_firstNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameView);
        make.left.and.right.mas_equalTo(_nameView);
        make.height.mas_equalTo(@(textfieldHeight));
    }];
    
    [_firstNameTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_firstNameView).mas_offset(15);
        make.top.and.bottom.and.right.mas_equalTo(_firstNameView);
    }];
    
    [_line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_firstNameView).mas_offset(0);
        make.right.mas_equalTo(_firstNameView).mas_offset(0);
        make.height.mas_equalTo(@(PointHeight));
        make.bottom.mas_equalTo(_firstNameView);
    }];
    
    [_lastNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_firstNameView.mas_bottom);
        make.left.and.right.mas_equalTo(_nameView);
        make.height.mas_equalTo(@(textfieldHeight));
    }];
    
    [_lastNameTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_firstNameView).mas_offset(15);
        make.top.and.bottom.and.right.mas_equalTo(_lastNameView);
    }];
    
    [_line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_firstNameView).mas_offset(0);
        make.right.mas_equalTo(_firstNameView).mas_offset(0);
        make.height.mas_equalTo(@(PointHeight));
        make.bottom.mas_equalTo(_lastNameView);
    }];
}

@end

#pragma mark - VETMobileCell
/***********************************************************
 *  VETMobileCell
 ***********************************************************/

@implementation VETMobileCell

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
    _typeButton = [PLCustomCellBtn new];
    [self.contentView addSubview:_typeButton];
    [_typeButton setTitleColor:MAINTHEMECOLOR forState:UIControlStateNormal];
    _typeButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    _typeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    _typeButton.titleLabel.x = 0;
    
    _contentTextfield = [UITextField new];
    _contentTextfield.placeholder = [CommenUtil LocalizedString:@"Call.Phone"];
    [self.contentView addSubview:_contentTextfield];
    
    _lineView = [UIView new];
    [self.contentView addSubview:_lineView];
    _lineView.backgroundColor = GRAYLINECOLOR;
}

- (void)setupLayouts
{
    [_typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@100);
    }];
    
    [_typeButton.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_typeButton);
        make.centerY.mas_equalTo(_typeButton.mas_centerY);
    }];
    
    [_contentTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_typeButton.mas_right);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(15);
        make.right.mas_equalTo(self.contentView).mas_offset(0);
        make.height.mas_equalTo(@(PointHeight));
        make.bottom.mas_equalTo(self.contentView);
    }];
}

@end

#pragma mark - VETAddContactViewController

/***********************************************************
 *  VETAddContactViewController
 ***********************************************************/

@interface VETAddContactViewController () <VETSelectMobileTypeViewControllerDelegate, UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSIndexPath *_lastIndexpath;
    UITextField *_firstNameTextfield;
    UITextField *_lastNameTextfield;
}

@property (nonatomic, retain) NSMutableArray *mobileArray;
@property (nonatomic, retain) VETAppleContact *contacts;
@property (nonatomic, retain) UIBarButtonItem *doneBarButton;
@property (nonatomic, strong) UILabel *titlelable;

@end

@implementation VETAddContactViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = [CommenUtil LocalizedString:@"Call.NewContact"];
    float titleWidth = [CommenUtil getWidthWithContent:str height:STATUS_AND_NAVIGATION_HEIGHT font:18];
    _titlelable = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth-titleWidth)/2, 0, titleWidth, STATUS_AND_NAVIGATION_HEIGHT)];
    _titlelable.text = str;
    _titlelable.font = FT(18);
    _titlelable.textColor = [UIColor whiteColor];
    _titlelable.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = _titlelable;
    
    _doneBarButton = [[UIBarButtonItem alloc] initWithTitle:[CommenUtil LocalizedString:@"Common.Done"] style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    _doneBarButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = _doneBarButton;
    
    [self setupDatas];
}

- (void)setupDatas
{
    _mobileArray = [NSMutableArray array];
    _contacts = [VETAppleContact new];
    
    //  默认显示home
    VETMobileModel *mobile = [VETMobileModel new];
    mobile.mobileType = [CommenUtil LocalizedString:@"Call.Home"];
    [_mobileArray addObject:mobile];
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1: _mobileArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.view.height / 3.0;
    }
    else {
        return 55.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.editing = YES;
    tableView.allowsSelectionDuringEditing = YES;
    
    if (indexPath.section == 0) {
        return [self setupAvatarCell:tableView indexPath:indexPath];
    } else {
        return [self setupMobileCell:tableView indexPath:indexPath];
    }
}

- (id)setupAvatarCell:(UITableView *)tableview indexPath:(NSIndexPath *)indexpath
{
    static NSString *identifier = @"avatarCell";
    VETUserInfoCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[VETUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.shouldIndentWhileEditing = NO;
        _firstNameTextfield = cell.firstNameTextfield;
        _lastNameTextfield = cell.lastNameTextfield;
        _firstNameTextfield.delegate = self;
        _lastNameTextfield.delegate = self;
    }
    return cell;
}

- (id)setupMobileCell:(UITableView *)tableview indexPath:(NSIndexPath *)indexpath
{
    static NSString *identifier = @"mobileCell";
    VETMobileCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[VETMobileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.editing = YES;
    }
    if (indexpath.row == _mobileArray.count) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [cell.typeButton setTitle:[CommenUtil LocalizedString:@"Call.AddPhone"] forState:UIControlStateNormal];
        cell.contentTextfield.hidden = YES;
        cell.typeButton.userInteractionEnabled = NO;
        return cell;
    }
    VETMobileModel *mobileModel = _mobileArray[indexpath.row];
    cell.contentTextfield.hidden = NO;
    cell.typeButton.userInteractionEnabled = YES;
    [cell.typeButton setTitle:mobileModel.mobileType forState:UIControlStateNormal];
    cell.typeButton.selectIndexpath = indexpath;
    [cell.typeButton addTarget:self action:@selector(tapMobileButton:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == _mobileArray.count) {
        [self insertMobile:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleNone;
    }
    else {
        if (indexPath.row == _mobileArray.count) {
            return UITableViewCellEditingStyleInsert;
        }
        return UITableViewCellEditingStyleDelete;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_mobileArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert){
        [self insertMobile:indexPath];
    }
}

#pragma mark - events

- (void)insertMobile:(NSIndexPath *)indexPath
{
    VETMobileModel *defaultModel = [VETMobileModel new];
    defaultModel.mobileType = [CommenUtil LocalizedString:@"Call.Home"];
    [_mobileArray addObject:defaultModel];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(indexPath.row) inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)tapMobileButton:(id)sender
{
    PLCustomCellBtn *button = (PLCustomCellBtn *)sender;
    _lastIndexpath = button.selectIndexpath;
    VETSelectMobileTypeViewController *selectMobileTypeVC = [VETSelectMobileTypeViewController new];
    selectMobileTypeVC.delegate = self;
    [self.navigationController pushViewController:selectMobileTypeVC animated:YES];
}

- (void)done
{
    // 提取textfield字符串
    for (NSUInteger i = 0; i < _mobileArray.count; i++) {
        VETMobileModel *model = _mobileArray[i];
        // 取得mobileCell
        VETMobileCell *cell = (VETMobileCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
        model.mobileContent = cell.contentTextfield.text;
    }
    VETAppleContact *contacts = [VETAppleContact new];
    contacts.firstName = _firstNameTextfield.text;
    contacts.lastName = _lastNameTextfield.text;
    contacts.mobileArray = _mobileArray;
    [VETContactHelper saveContact:contacts];
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kVETViewControllerRefreshContactNotification object:nil];
}

#pragma mark - uitextfield delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == _firstNameTextfield) {
        if (toBeString.length > 0 || _lastNameTextfield.text.length > 0) {
            _doneBarButton.enabled = YES;
        }
        else {
            _doneBarButton.enabled = NO;
        }
    }
    else {
        if (toBeString.length > 0 || _firstNameTextfield.text.length > 0) {
            _doneBarButton.enabled = YES;
        }
        else {
            _doneBarButton.enabled = NO;
        }
    }
    return YES;
}

#pragma mark - VETAddContactViewController delegate

- (void)didTapString:(NSString *)string
{
    VETMobileModel *model = _mobileArray[_lastIndexpath.row];
    model.mobileType = string;
    [self.tableView reloadData];
}

// 点击空白处隐藏键盘 也可用作其他
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
