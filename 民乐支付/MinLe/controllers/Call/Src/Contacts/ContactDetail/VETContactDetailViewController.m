//
//  VETContactDetailViewController.m
//  MobileVoip
//
//  Created by Liu Yang on 26/05/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETContactDetailViewController.h"
#import "VETAppleContact.h"
#import "VETContactDetailMainView.h"
#import "UITableView+LYXExtension.h"
#import "UIBarButtonItem+Extension.h"
#import "VETNavigationController.h"
#import "DBUtil.h"
#import "VETRatesViewController.h"
#import "VETCallHelper.h"

// Code:183 .Call 3 state changed to EARLY (183 Session Progress)
@interface VETContactDetailViewController ()<UITableViewDelegate, UITableViewDataSource, VETContactDetailMainViewDelegate, VETContactDetailPhoneCellDelegate, UIViewControllerTransitioningDelegate>
{
    CGFloat _cunrrentTopViewHeight;
}

@property (nonatomic, retain) VETContactDetailMainView *mainView;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UILabel *titlelable;

@end

@implementation VETContactDetailViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews
{
    float titleWidth = [CommenUtil getWidthWithContent:self.contact.fullName height:STATUS_AND_NAVIGATION_HEIGHT font:18];
    _titlelable = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth-titleWidth)/2, 0, titleWidth, STATUS_AND_NAVIGATION_HEIGHT)];
    _titlelable.text = self.contact.fullName;
    _titlelable.font = FT(18);
    _titlelable.textColor = [UIColor whiteColor];
    _titlelable.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = _titlelable;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.window.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainView];
    
    [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(64);
        make.left.and.right.and.bottom.mas_equalTo(self.view);
    }];
    _mainView.phoneNumberTableView.delegate = self;
    _mainView.phoneNumberTableView.dataSource = self;
    _mainView.delegate = self;
    [_mainView.phoneNumberTableView removeExtraLine:LYXTableViewRemoveExtraLineTypeIncludeLastLine];
    
    [_mainView.phoneNumberTableView.panGestureRecognizer addTarget:self action:@selector(handlePan:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (VETContactDetailMainView *)mainView
{
    if (_mainView == nil) {
        _mainView = [[VETContactDetailMainView alloc] init];
        _mainView.phoneNumberTableView.delegate = self;
        _mainView.contact = _contact;
        
        // 更新favorite button 状态.
        NSArray *favoriteArr =[[DBUtil sharedManager] queryFavoritedContact];
        for (VETAppleContact *favoriteContact in favoriteArr) {
            if ([_contact.fullName isEqualToString:favoriteContact.fullName]) {
                _mainView.favoriteButton.selected = YES;
            }
        }
    }
    return _mainView;
}

- (void)setContact:(VETAppleContact *)contact
{
    _contact = contact;
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contact.mobileArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AddFriendCell";
    VETContactDetailPhoneCell *cell = (VETContactDetailPhoneCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[VETContactDetailPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.mobileModel = _contact.mobileArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

#pragma mark - VETContactDetailPhoneCell delegate

- (void)detailPhoneCell:(VETContactDetailPhoneCell *)cell didTapCallBtn:(UIButton *)callButton model:(VETMobileModel *)model
{
    [VETCallHelper outgoingWithPhoneString:model.mobileContent target:self];
}

// TODO:black color是黑色
- (void)detailPhoneCell:(VETContactDetailPhoneCell *)cell didTapRatesBtn:(UIButton *)ratesButton model:(VETMobileModel *)model
{
    VETRatesViewController *ratesVC = [VETRatesViewController new];
    ratesVC.transitioningDelegate = self;
    ratesVC.phoneNumber = model.mobileContent;
    
    CATransition *transition = [CATransition animation];
    transition.repeatCount = 1;
    transition.type = @"oglFlip";
    //    - 确定子类型(方向等)
    transition.subtype = kCATransitionFromLeft;
    transition.duration = 0.6;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self presentViewController:ratesVC animated:NO completion:nil];
}

#pragma mark - pan
- (void)handlePan:(UIPanGestureRecognizer *)sender
{
    static CGFloat initialTouchPointY;
    static CGFloat topViewMinimumHeight = 80.0;
    CGFloat topViewMacHeight = SCREEN_HEIGHT * 0.35;
    
    CGPoint touchPoint = [sender locationInView:self.view];
    NSLayoutConstraint *layoutConstraint = [_mainView.topHeightConstraint valueForKey:@"layoutConstraint"];
    CGFloat topViewHeight = layoutConstraint.constant;
    
    switch ( sender.state ) {
        case UIGestureRecognizerStateBegan: {
            initialTouchPointY = touchPoint.y;
            _cunrrentTopViewHeight = topViewHeight;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            _cunrrentTopViewHeight = topViewHeight;
            // 放大(20是statusbar的高度)
            if (_cunrrentTopViewHeight > topViewMacHeight / 2 + 20) {
                layoutConstraint.constant = topViewMacHeight;
                [UIView animateWithDuration:0.3 animations:^{
                    [_mainView layoutIfNeeded];
                }];
            }
            // 放小
            else {
                layoutConstraint.constant = topViewMinimumHeight;
                [UIView animateWithDuration:0.3 animations:^{
                    [_mainView layoutIfNeeded];
                }];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat offsetY = (initialTouchPointY - touchPoint.y);
            CGPoint dragVelocity = [sender velocityInView:self.view];
            // 下拉
            if (dragVelocity.y >= 0) {
                if (layoutConstraint.constant < topViewMacHeight && _cunrrentTopViewHeight - offsetY > topViewHeight) {
                    layoutConstraint.constant = _cunrrentTopViewHeight - offsetY;
                }
            }
            // 上拉
            else{
                if (layoutConstraint.constant > topViewMinimumHeight && _cunrrentTopViewHeight - offsetY < topViewMacHeight) {
                    layoutConstraint.constant = _cunrrentTopViewHeight - offsetY;
                }
            }
            break;
        }
        default: {
            break;
        }
    }
}

#pragma mark - event 

- (void)tapEdit:(id)sender
{
    
}

#pragma mark - main view delegate

- (void)mainView:(VETContactDetailMainView *)mainView didTapFavorityBtn:(id)sender
{
    UIButton *favoriteBtn = (UIButton *)sender;
    // 取消收藏
    if (favoriteBtn.selected) {
        [[DBUtil sharedManager] deleteFavoriteContact:_contact.fullName];
        favoriteBtn.selected = NO;
    }
    // 收藏
    else {
        [[DBUtil sharedManager] insertFavoriteContact:_contact];
        favoriteBtn.selected = YES;
    }
    [[DBUtil sharedManager] queryFavoritedContact];
    [[NSNotificationCenter defaultCenter] postNotificationName:kVETViewControllerRefreshContactNotification object:nil];
}

@end
