//
//  VETDialPadViewController.m
//  VETEphone
//
//  Created by young on 17/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import "VETDialpadViewController.h"
#import "VETDialpadMainView.h"
#import "VETOutgoingCallingViewController.h"
#import "VETPlaySoundHelper.h"
#import "LYAlertViewHelper.h"
#import "VETCountryViewController.h"
#import "VETVoip.h"
#import "VETSearchAreaCodeManager.h"
#import "UINavigationController+LYXBarStatusStyle.h"
#import "VETLogoutHelper.h"
#import "VETCountry.h"
#import "VETCallHelper.h"
#import "VETGCDTimerHelper.h"
#import "VETReconnectHelper.h"
#import "VETAccount.h"
#import "DBUtil.h"


#pragma mark - TitleView

/***********************************************************
 *  VETStatusTitleView
 ***********************************************************/
@interface VETStatusTitleView : UIView

// @property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subTitle;
@property (nonatomic, assign) VETAccountStatus status;

@end

@interface VETStatusTitleView()

@property (nonatomic, retain) UILabel *titleLable;
@property (nonatomic, retain) UILabel *subTitleLable;

@end

@implementation VETStatusTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setupViews];
        [self setupLayouts];
    }
    return self;
}

- (void)setupViews
{
    _titleLable = [UILabel new];
    _titleLable.textColor = [UIColor blackColor];
    [self addSubview:_titleLable];
    
    _subTitleLable = [UILabel new];
    _subTitleLable.textColor = [UIColor blackColor];
    _subTitleLable.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:_subTitleLable];
}

- (void)setupLayouts
{
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    [_subTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_centerY).mas_offset(2);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
}

- (void)setStatus:(VETAccountStatus)status
{
    switch (status) {
        case VETAccountStatusInitial: {
            self.titleLable.text = [CommenUtil LocalizedString:@"Call.PhoneReady"];
            break;
        }
        case VETAccountStatusOffline: {
            self.titleLable.text = [CommenUtil LocalizedString:@"Call.AccountInvalid"];
            break;
        }
        case VETAccountStatusInvalid: {
            self.titleLable.text = [CommenUtil LocalizedString:@"Call.AccountOffline"];
            break;
        }
        case VETAccountStatusConnecting: {
            self.titleLable.text = [CommenUtil LocalizedString:@"Call.AccountConnecting"];
            break;
        }
        case VETAccountStatusConnected: {
            self.titleLable.text = [CommenUtil LocalizedString:@"Call.AccountConnected"];
            break;
        }
        case VETAccountStatusDisconnecting: {
            self.titleLable.text = [CommenUtil LocalizedString:@"Call.AccountDisconnecting"];
            break;
        }
        default:
            break;
    }
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    _subTitleLable.text = subTitle;
}

@end

#pragma mark - DialpadViewController

@interface VETDialpadViewController ()<VETDialpadMainViewDelegate, UITextFieldDelegate>
{
    BOOL _isLoosenDeleteBtn;
    BOOL _isQueriedBalance;
}
@property (nonatomic, strong) VETDialpadMainView *mainView;
@property (nonatomic, retain) NSString *phoneString;
@property (nonatomic, retain) VETStatusTitleView *statusTitleView;
/*
 底部视图
 */
@property (nonatomic, strong) UIView *closeView;
@property (nonatomic, strong) UIButton *closeButton;//关闭退出按钮
@property (nonatomic, retain) UILabel *balanceNotiLabel;
@property (nonatomic, retain) UILabel *balanceLabel;
/*
 topBarView
 */
@property (nonatomic, strong) UIView *topBarView;
/*
 左上角连接状态
 */
@property (nonatomic, assign) VETAccountStatus status;
@property (nonatomic, retain) UIImageView *statusImg;
@property (nonatomic, retain) UILabel *statusLabel;
/*
 选择国家
 */
@property (nonatomic, retain) UIButton *countryButton;
@property (nonatomic, retain) UIImageView *countryImageView;
@property (nonatomic, strong) UIImageView *countryTopImageView;

@property (nonatomic, strong) VETCountry *currentCountry;
@property (strong, readwrite, nonatomic) dispatch_source_t longDeleteBtnTimer;
//@property (strong, readwrite, nonatomic) dispatch_source_t connectTimer;

@end

@implementation VETDialpadViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:VETVoipManagerAccountRegisterStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kVETViewControllerRefreshBalanceNotification object:nil];
    NSLog(@"VETDialpadViewController界面释放成功");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    
    [self setBarContent];
    
    [self checkBalance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voipAccountRegistrationDidChange:) name:VETVoipManagerAccountRegisterStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voipRefreshBalance:) name:kVETViewControllerRefreshBalanceNotification object:nil];
}

- (void)initUI
{
    _isLoosenDeleteBtn = YES;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView = self.topBarView;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self.view addSubview:self.mainView];
    [self.view addSubview:self.closeView];
    
    _currentCountry = SharedApp.currentCountry;
    [self setupCountry:_currentCountry];
    self.mainView.encryptionStatus = [[VETUserManager sharedInstance] encryptStatus];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Action

- (void)closeAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mainview delegate

- (void)dialpadMainView:(VETDialpadMainView *)view tapCallButton:(id)sender
{
    [VETCallHelper outgoingWithPhoneString:_phoneString target:self];
}

- (void)dialpadMainView:(VETDialpadMainView *)view tapAddContactsButton:(id)sender
{
    
}

- (void)dialpadMainView:(VETDialpadMainView *)view tapCountryButton:(id)sender
{
//    VETCountryViewController *countryVC = [VETCountryViewController new];
//    [self.navigationController pushViewController:countryVC animated:YES];
}

- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberOneButton:(id)sender
{
    self.phoneString = [NSString stringWithFormat:@"%@%@", self.phoneString, @"1"];
    [VETPlaySoundHelper playSoundWithType:VETPlaySoundHelperTypeOne];
}

- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberTwoButton:(id)sender
{
    self.phoneString = [NSString stringWithFormat:@"%@%@", self.phoneString, @"2"];
    [VETPlaySoundHelper playSoundWithType:VETPlaySoundHelperTypeTwo];
}

- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberThreeButton:(id)sender
{
    self.phoneString = [NSString stringWithFormat:@"%@%@", self.phoneString, @"3"];
    [VETPlaySoundHelper playSoundWithType:VETPlaySoundHelperTypeThree];
}

- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberFourButton:(id)sender
{
    self.phoneString = [NSString stringWithFormat:@"%@%@", self.phoneString, @"4"];
    [VETPlaySoundHelper playSoundWithType:VETPlaySoundHelperTypeFour];
}

- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberFiveButton:(id)sender
{
    self.phoneString = [NSString stringWithFormat:@"%@%@", self.phoneString, @"5"];
    [VETPlaySoundHelper playSoundWithType:VETPlaySoundHelperTypeFive];
}

- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberSixButton:(id)sender
{
    self.phoneString = [NSString stringWithFormat:@"%@%@", self.phoneString, @"6"];
    [VETPlaySoundHelper playSoundWithType:VETPlaySoundHelperTypeSix];
}

- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberSevenButton:(id)sender
{
    self.phoneString = [NSString stringWithFormat:@"%@%@", self.phoneString, @"7"];
    [VETPlaySoundHelper playSoundWithType:VETPlaySoundHelperTypeSeven];
}

- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberEightButton:(id)sender
{
    self.phoneString = [NSString stringWithFormat:@"%@%@", self.phoneString, @"8"];
    [VETPlaySoundHelper playSoundWithType:VETPlaySoundHelperTypeEight];
}

- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberNineButton:(id)sender
{
    self.phoneString = [NSString stringWithFormat:@"%@%@", self.phoneString, @"9"];
    [VETPlaySoundHelper playSoundWithType:VETPlaySoundHelperTypeNine];
}

- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberStarButton:(id)sender
{
    self.phoneString = [NSString stringWithFormat:@"%@%@", self.phoneString, @"*"];
    [VETPlaySoundHelper playSoundWithType:VETPlaySoundHelperTypeStar];
}

- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberZeroButton:(id)sender
{
    self.phoneString = [NSString stringWithFormat:@"%@%@", self.phoneString, @"0"];
    [VETPlaySoundHelper playSoundWithType:VETPlaySoundHelperTypeZero];
}

- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberWellButton:(id)sender
{
    self.phoneString = [NSString stringWithFormat:@"%@%@", self.phoneString, @"#"];
    [VETPlaySoundHelper playSoundWithType:VETPlaySoundHelperTypeWell];
}

- (void)dialpadMainView:(VETDialpadMainView *)view longPressZeroButton:(id)sender
{
//    self.phoneString = [NSString stringWithFormat:@"%@%@", self.phoneString, @"+"];
//    [VETPlaySoundHelper playSoundWithType:VETPlaySoundHelperTypeZero];
}

- (void)dialpadMainView:(VETDialpadMainView *)view didDeleteTouchDownButton:(id)sender
{
    _isLoosenDeleteBtn = NO;
    self.longDeleteBtnTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(self.longDeleteBtnTimer, dispatch_time(DISPATCH_TIME_NOW, 0), NSEC_PER_SEC * 0.2, 0);
    dispatch_source_set_event_handler(self.longDeleteBtnTimer, ^{
        if (_isLoosenDeleteBtn) {
            dispatch_source_cancel(self.longDeleteBtnTimer);
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self deletePhoneLastString];
            });
        }
    });
    dispatch_resume(self.longDeleteBtnTimer);
}

- (void)dialpadMainView:(VETDialpadMainView *)view didDeleteTouchUpInsideButton:(id)sender
{
    _isLoosenDeleteBtn = YES;
}

#pragma mark - private

- (void)deletePhoneLastString
{
    VETCountry *country = [[VETUserManager sharedInstance] country];
    
    // 删除单个数字(+86 333，删除+86 后面的数字)
    if (_phoneString.length > country.code.length + 1) {
        self.phoneString = [self.phoneString substringToIndex:self.phoneString.length - 1];
        [self.mainView startCallAnimation];
    }
    // 清除已选择的国家区号
    else if (country.code.length > 0) {
        self.phoneString = @"";
        [[VETSearchAreaCodeManager sharedInstance] removeSettingAreaCode];
        [[VETUserManager sharedInstance] removeCountry];
        self.mainView.country = nil;
    }
    // +8的情况删除8
    else if (_phoneString.length == 1) {
        self.phoneString = [self.phoneString substringToIndex:self.phoneString.length - 1];
    }
}

- (void)setPhoneString:(NSString *)phoneString
{
    _phoneString = phoneString;
    
//    if (phoneString.length > 1) {
//        [[VETSearchAreaCodeManager sharedInstance] searchAreaCode:phoneString completion:^(VETAreaCode *code) {
//            if (code) {
//                _phoneString = [NSString stringWithFormat:@"%@ ", code.code];
//                [self searchCountryIcon:code.code completion:^(VETCountry *country, BOOL isSearched) {
//                    if (isSearched) {
//                        [_mainView setCountry:country];
//                        [[VETUserManager sharedInstance] settingCountry:country];
//                    } else {
//                        NSString *newCodeString = [NSString stringWithFormat:@"00%@",code.code];
//                        [self setCountry:newCodeString];
//                    }
//                }];
//            }
//        }];
//    }
//    // 清空已选择的国家
//    if (phoneString.length == 0) {
//        [[VETSearchAreaCodeManager sharedInstance] removeSettingAreaCode];
//    }
    _mainView.phoneString = _phoneString;
}

- (void)setCountry:(NSString *)code
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"CountryCodes" ofType:@"plist"];
        NSDictionary *countryDic = [NSDictionary dictionaryWithContentsOfFile:pathStr];
        [countryDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSArray *countryArr = (NSArray *)obj;
            for (NSDictionary *dic in countryArr) {
                if ([[dic objectForKey:@"code"] isEqualToString:code]) {
                    VETCountry *countryNew =
                    [[VETCountry alloc] initWithCode:code
                                            shouzimu:[dic objectForKey:@"shouzimu"]
                                                icon:[dic objectForKey:@"icon"]
                                              pinyin:[dic objectForKey:@"pinyin"]
                                  countryEnglishName:[dic objectForKey:@"countryEnglishName"]
                                  countryChineseName:[dic objectForKey:@"countryChineseName"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_mainView setCountry:countryNew];
                        [[VETUserManager sharedInstance] settingCountry:countryNew];
                    });
                    return ;
                }
            }
        }];
    });
}

- (void)searchCountryIcon:(NSString *)areaCode completion:(void(^)(VETCountry *, BOOL isSearched))block
{
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"CountryCodes" ofType:@"plist"];
    NSDictionary *countryDic = [NSDictionary dictionaryWithContentsOfFile:pathStr];
    
    //    NSMutableArray *countryArray = @[].mutableCopy;
    [countryDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSArray *countryArr = (NSArray *)obj;
        // Key为字母.无视
        for (NSDictionary *dic in countryArr) {
            NSString *code = [dic objectForKey:@"code"];
            // 去除开头的00
            if ([code hasPrefix:@"00"]) {
                code = [code substringFromIndex:2];
            }
            if ([code isEqualToString:areaCode]) {
                NSLog(@"test");
                VETCountry *country = [[VETCountry alloc] initWithCode:[dic objectForKey:@"code"] shouzimu:[dic objectForKey:@"shouzimu"] icon:[dic objectForKey:@"icon"] pinyin:[dic objectForKey:@"pinyin"] countryEnglishName:[dic objectForKey:@"countryEnglishName"] countryChineseName:[dic objectForKey:@"countryChineseName"]];
                block(country, YES);
                *stop = YES;
            }
        }
    }];
    block(nil, NO);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

#pragma mark - Getter

- (VETDialpadMainView *)mainView
{
    if (_mainView == nil) {
        _mainView = [[VETDialpadMainView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBARHEIGHT-STATUS_AND_NAVIGATION_HEIGHT)];
        _mainView.delegate = self;
        _mainView.phoneTextfield.delegate = self;
        _mainView.userInteractionEnabled = YES;
    }
    return _mainView;
}

- (UIView *)closeView
{
    if (!_closeView) {
        _closeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mainView.frame), SCREEN_WIDTH, TABBARHEIGHT)];
        _closeView.backgroundColor = [UIColor whiteColor];
        
        [_closeView addSubview:self.balanceNotiLabel];
        [_closeView addSubview:self.balanceLabel];
        [_closeView addSubview:self.closeButton];
    }
    return _closeView;
}

- (UILabel *)balanceNotiLabel
{
    if (!_balanceNotiLabel) {
        NSString *str = [CommenUtil LocalizedString:@"Call.Balance:"];
        float ww = [CommenUtil getWidthWithContent:str height:TABBARHEIGHT font:14];
        _balanceNotiLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ww, TABBARHEIGHT)];
        _balanceNotiLabel.textColor = blueRGB;
        _balanceNotiLabel.text = str;
        _balanceNotiLabel.font = FT(14);
    }
    return _balanceNotiLabel;
}

- (UILabel *)balanceLabel
{
    if (!_balanceLabel) {
        _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.balanceNotiLabel.frame), 0, SCREEN_WIDTH-15-44-CGRectGetMaxX(self.balanceNotiLabel.frame), TABBARHEIGHT)];
        _balanceLabel.text = @"N/A";
        _balanceLabel.textColor = blueRGB;
        _balanceLabel.font = FT(16);
    }
    return _balanceLabel;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _closeButton.frame = CGRectMake(SCREEN_WIDTH-44-15, 0, 44, TABBARHEIGHT);
        _closeButton.titleLabel.font = FT(16);
        _closeButton.backgroundColor = [UIColor whiteColor];
        [_closeButton setTitle:[CommenUtil LocalizedString:@"Common.Shut"] forState:UIControlStateNormal];
        [_closeButton setTitleColor:blueRGB forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateSelected];
        [_closeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

#pragma mark - Bar

- (UIView *)topBarView
{
    if (!_topBarView) {
        _topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        
        [_topBarView addSubview:self.statusImg];
        [_topBarView addSubview:self.statusLabel];
        [_topBarView addSubview:self.countryButton];
    }
    return _topBarView;
}

- (UIImageView *)statusImg
{
    if (!_statusImg) {
        _statusImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, (NAVIGATION_BAR_HEIGHT-12)/2, 12, 12)];
        _statusImg.image = [UIImage imageNamed:@"status_connecting"];
    }
    return _statusImg;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.statusImg.frame)+10, 0, 200, NAVIGATION_BAR_HEIGHT)];
        _statusLabel.text = [CommenUtil LocalizedString:@"Call.AccountConnecting"];
        _statusLabel.font = FT(14);
        _statusLabel.textColor = [UIColor whiteColor];
    }
    return _statusLabel;
}

- (UIButton *)countryButton
{
    if (!_countryButton) {
        _countryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _countryButton.frame = CGRectMake((SCREEN_WIDTH-24-11-5)/2, 0, 24+11+5, NAVIGATION_BAR_HEIGHT);
        [_countryButton addTarget:self action:@selector(tapCountryButton:) forControlEvents:UIControlEventTouchUpInside];
        [_countryButton addSubview:self.countryImageView];
        [_countryButton addSubview:self.countryTopImageView];
    }
    return _countryButton;
}

- (UIImageView *)countryImageView
{
    if (!_countryImageView) {
        _countryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (NAVIGATION_BAR_HEIGHT-24)/2, 24, 24)];
        _countryImageView.image = [UIImage imageNamed:@"CN"];
    }
    return _countryImageView;
}

- (UIImageView *)countryTopImageView
{
    if (!_countryTopImageView) {
        _countryTopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.countryImageView.frame)+5, (NAVIGATION_BAR_HEIGHT-8)/2, 11, 8)];
        _countryTopImageView.image = [UIImage imageNamed:@"choose"];
        [CommenUtil setTintColor:[UIColor whiteColor] forImgView:_countryTopImageView];
    }
    return _countryTopImageView;
}

- (void)tapCountryButton:(UIButton *)sender
{
    VETCountryViewController *countryVC = [VETCountryViewController new];
    countryVC.countryBlock = ^(VETCountry *country) {
        _currentCountry = country;
        [self setupCountry:_currentCountry];
        self.mainView.encryptionStatus = [[VETUserManager sharedInstance] encryptStatus];
    };
    [self.navigationController pushViewController:countryVC animated:YES];
}

//设置国家区号
- (void)setupCountry:(VETCountry *)country
{
    self.mainView.country = country;
    self.phoneString = @"";
    self.countryImageView.image = [UIImage imageNamed:country.icon];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setStatus:(VETAccountStatus)status
{
    NSString *accountPrompt;
    UIImage *accountPromptImage;
    switch (status) {
        case VETAccountStatusInitial: {
            //连接中...
            accountPrompt = [CommenUtil LocalizedString:@"Call.AccountConnecting"];
            accountPromptImage = [UIImage imageNamed:@"status_connecting"];
            break;
        }
        case VETAccountStatusOffline: {
            //离线(即将重连)
            accountPrompt = [CommenUtil LocalizedString:@"Call.AccountOffline(WillBeReconnect)"];
            accountPromptImage = [UIImage imageNamed:@"status_invalid"];
            break;
        }
        case VETAccountStatusInvalid: {
            //帐户失效
            accountPrompt = [CommenUtil LocalizedString:@"Call.AccountInvalid"];
            accountPromptImage = [UIImage imageNamed:@"status_offline"];
            break;
        }
        case VETAccountStatusConnecting: {
            //连接中...
            accountPrompt = [CommenUtil LocalizedString:@"Call.AccountConnecting"];
            accountPromptImage = [UIImage imageNamed:@"status_connecting"];
            break;
        }
        case VETAccountStatusConnected: {
            //已连接
            accountPrompt = [CommenUtil LocalizedString:@"Call.AccountConnected"];
            accountPromptImage = [UIImage imageNamed:@"status_online"];
            break;
        }
        case VETAccountStatusDisconnecting: {
            //正在断开连接
            accountPrompt = [CommenUtil LocalizedString:@"Call.AccountDisconnecting"];
            accountPromptImage = [UIImage imageNamed:@"status_offline"];
            break;
        }
        case VETAccountStatusNetworkError: {
            //网络连接失败
            accountPrompt = [CommenUtil LocalizedString:@"Call.NetworkError"];
            accountPromptImage = [UIImage imageNamed:@"status_invalid"];
            break;
        }
        case VETAccountStatusForbid: {
            //连接被拒绝
            accountPrompt = [CommenUtil LocalizedString:@"Call.ConnectForbid"];
            accountPromptImage = [UIImage imageNamed:@"status_invalid"];
            break;
        }
        default:
            break;
    }
    self.statusLabel.text = accountPrompt;
    self.statusImg.image = accountPromptImage;
}

// 设置自定义的导航栏内容显示
- (void)setBarContent
{
    // 显示当前状态
    //VETVoipAccount *account = [[VETVoipManager sharedManager] accountWithUsername:[[VETUserManager sharedInstance] currentUsername]];
    self.status = self.recoderStatus;
    
    // 余额
    NSString *balance = [[VETUserManager sharedInstance] balance];
    if ([[CommenUtil sharedInstance] isNull:balance]) {
        balance = @"N/A";
    }
    if (![balance containsString:@"¥"]) {
        balance = [NSString stringWithFormat:@"¥%@",balance];
        [[VETUserManager sharedInstance] setBalance:balance];
    }
    self.balanceLabel.text = balance;
    //为空再查询一次
    if (!_isQueriedBalance) {
//        [[VETVoipManager sharedManager] queryBalanceBalanceCompletion:^(NSString * _Nonnull balance) {
//            _isQueriedBalance = YES;
//            NSLog(@"balance:%@", balance);
//            [[NSNotificationCenter defaultCenter] postNotificationOnMainThread:[[NSNotification alloc] initWithName:kVETViewControllerRefreshBalanceNotification object:nil userInfo:nil]];
//        }];
    }
}

//收到余额的通知
- (void)voipRefreshBalance:(id)notification
{
    LYLog(@"balance:%@", [[VETUserManager sharedInstance] balance]);
    NSString *balanceStr = [[VETUserManager sharedInstance] balance];
    if (balanceStr &&
        [balanceStr floatValue] > 0 &&
        ![[CommenUtil sharedInstance] isNull:balanceStr]) {
        self.balanceLabel.text = [NSString stringWithFormat:@"¥%@", balanceStr];
    } else {
        self.balanceLabel.text = @"N/A";
    }
}

//查询余额
- (void)checkBalance
{
    NSDictionary *dic = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
    [SharedApp.netWorking myPostWithUrlString:checkBalanceURL withParameter:dic withComplection:^(NSDictionary *responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            /*
             account ：用户编号
             money ：余额
             */
            NSString *balanceStr = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"money"]];
            if (![[CommenUtil sharedInstance] isNull:balanceStr]) {
                self.balanceLabel.text = [NSString stringWithFormat:@"¥%@", balanceStr];
            }
        }
    } withFailure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - notification

- (void)voipAccountRegistrationDidChange:(NSNotification *)notification
{
    VETVoipAccount *account = (VETVoipAccount *)notification.object;
    self.status = account.accountStatus;
}

@end
