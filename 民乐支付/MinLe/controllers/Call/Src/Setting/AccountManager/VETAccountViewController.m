//
//  VETAccountViewController.m
//  MobileVoip
//
//  Created by Liu Yang on 16/05/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETAccountViewController.h"

/***********************************************************
 *  VETInputboxView
 ***********************************************************/
@interface VETInputboxView : UIView

@property (nonatomic, retain) UILabel *hintLable;
@property (nonatomic, retain) UITextField *contentTextfield;

@end

@implementation VETInputboxView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setupViews];;
        [self setupLayouts];
    }
    return self;
}

- (void)setupViews
{
    _hintLable = [UILabel new];
    [self addSubview:_hintLable];
    _hintLable.textColor = [UIColor blackColor];
    _hintLable.font = [UIFont systemFontOfSize:17.0];
    
    _contentTextfield = [UITextField new];
    [self addSubview:_contentTextfield];
    _contentTextfield.font = [UIFont systemFontOfSize:15.0];
}

- (void)setupLayouts
{
    [_hintLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(15);
        make.bottom.mas_equalTo(self.mas_centerY).mas_offset(0);
    }];
    [_contentTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_hintLable);
        make.top.mas_equalTo(self.mas_centerY).mas_offset(2);
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
}

@end

/***********************************************************
 *  VETSegmentView
 ***********************************************************/

@implementation VETSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setupViews];;
        [self setupLayouts];
    }
    return self;
}

- (void)setupViews
{
    _hintLable = [UILabel new];
    [self addSubview:_hintLable];
    _hintLable.textColor = [UIColor blackColor];
    _hintLable.font = [UIFont systemFontOfSize:17.0];
    
    _segmentControl = [UISegmentedControl new];
    [self addSubview:_segmentControl];
}

- (void)setupLayouts
{
    [_hintLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(15);
        make.bottom.mas_equalTo(self.mas_centerY).mas_offset(0);
    }];
    [_segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_hintLable);
        make.top.mas_equalTo(self.mas_centerY).mas_offset(2);
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
}

@end

/***********************************************************
 *  VETAccountViewController
 ***********************************************************/

@interface VETAccountViewController ()

@property (nonatomic, retain) VETInputboxView *displayView;

@property (nonatomic, retain) UIView *detailView;
@property (nonatomic, retain) UIView *lineView;
@property (nonatomic, retain) VETInputboxView *userNameView;
@property (nonatomic, retain) VETInputboxView *passwordView;
@property (nonatomic, retain) VETInputboxView *domainView;
@property (nonatomic, retain) VETSegmentView *transportView;
@property (nonatomic, retain) VETSegmentView *encryptionView;
@property (nonatomic, retain) VETInputboxView *encryptionPort;

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIView *containerView;

@end

@implementation VETAccountViewController

- (void)dealloc
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViews];
    [self setupLayouts];
}

- (void)setupViews
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_scrollView];
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _containerView = [[UIView alloc] initWithFrame:self.view.frame];
    [_scrollView addSubview:_containerView];
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 1)];
    
    /*
     *  account view
     */
    _displayView = [VETInputboxView new];
    [_containerView addSubview:_displayView];
    _displayView.contentTextfield.placeholder = NSLocalizedString(@"Please enter displayname", @"Setting");
    _displayView.hintLable.text = NSLocalizedString(@"Display name", @"Setting");
    _displayTextfield = _displayView.contentTextfield;
    
    /*
     *  detail view
     */
    _detailView = [UIView new];
    [_containerView addSubview:_detailView];
    
    _lineView = [UIView new];
    [_detailView addSubview:_lineView];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    
    _userNameView = [VETInputboxView new];
    [_detailView addSubview:_userNameView];
    _userNameView.contentTextfield.placeholder = NSLocalizedString(@"Please enter username", @"Setting");
    _userNameView.hintLable.text = NSLocalizedString(@"Username", @"Setting");
    _usernameTextfield = _userNameView.contentTextfield;
    
    _passwordView = [VETInputboxView new];
    [_detailView addSubview:_passwordView];
    _passwordView.contentTextfield.placeholder = NSLocalizedString(@"Please enter password", @"Setting");
    _passwordView.contentTextfield.secureTextEntry = YES;
    _passwordView.hintLable.text = NSLocalizedString(@"Password", @"Setting");
    _passwordTextfield = _passwordView.contentTextfield;
    
    _domainView = [VETInputboxView new];
    [_detailView addSubview:_domainView];
    _domainView.contentTextfield.placeholder = NSLocalizedString(@"Please enter domain", @"Setting");
    _domainView.hintLable.text = NSLocalizedString(@"Domain", @"Setting");
    _domainTextfield = _domainView.contentTextfield;

    _transportView = [VETSegmentView new];
    [_detailView addSubview:_transportView];
    _transportView.hintLable.text = NSLocalizedString(@"Transport", @"Setting");
    [_transportView.segmentControl insertSegmentWithTitle:@"TCP" atIndex:0 animated:NO];
    [_transportView.segmentControl insertSegmentWithTitle:@"UDP" atIndex:1 animated:NO];
    [_transportView.segmentControl insertSegmentWithTitle:@"TLS" atIndex:2 animated:NO];
    _transportSeg = _transportView.segmentControl;
    
    _encryptionView = [VETSegmentView new];
    [_detailView addSubview:_encryptionView];
    _encryptionView.hintLable.text = NSLocalizedString(@"Encryption", @"Setting");
    [_encryptionView.segmentControl insertSegmentWithTitle:@"RC4" atIndex:0 animated:NO];
    [_encryptionView.segmentControl insertSegmentWithTitle:@"SRTP" atIndex:1 animated:NO];
    [_encryptionView.segmentControl insertSegmentWithTitle:@"NONE" atIndex:2 animated:NO];
    _encryptionSeg = _encryptionView.segmentControl;
    
    _encryptionPort = [VETInputboxView new];
    [_detailView addSubview:_encryptionPort];
    _encryptionPort.contentTextfield.placeholder = NSLocalizedString(@"Please enter encryption port", @"Setting");
    _encryptionPort.hintLable.text = NSLocalizedString(@"Encryption port", @"Setting");
    _portTextfield = _encryptionPort.contentTextfield;
}

- (void)setupLayouts
{
    CGFloat padding = 15;
    CGFloat inputBoxHeight = 55.0;
    
    [_displayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_containerView).offset(padding);
        make.top.mas_equalTo(_containerView);
        make.right.mas_equalTo(_containerView).offset(-padding);
        make.height.mas_equalTo(@(inputBoxHeight));
    }];
    
    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_containerView).offset(padding);
        make.top.mas_equalTo(_displayView.mas_bottom);
        make.right.mas_equalTo(_containerView).offset(-padding);
        make.bottom.mas_equalTo(_containerView);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_detailView).offset(0);
        make.left.mas_equalTo(_containerView).offset(padding);
        make.right.mas_equalTo(_containerView).offset(0);
        make.height.mas_equalTo(@(PointHeight));
    }];
    
    [_userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lineView.mas_bottom).offset(5);
        make.left.mas_equalTo(_containerView).offset(padding);
        make.height.mas_equalTo(@(inputBoxHeight));
        make.right.mas_equalTo(_detailView);
    }];
    
    [_passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_userNameView.mas_bottom).offset(0);
        make.left.mas_equalTo(_containerView).offset(padding);
        make.height.mas_equalTo(@(inputBoxHeight));
        make.right.mas_equalTo(_detailView);
    }];
    
    [_domainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_passwordView.mas_bottom).offset(0);
        make.left.mas_equalTo(_containerView).offset(padding);
        make.height.mas_equalTo(@(inputBoxHeight));
        make.right.mas_equalTo(_detailView);
    }];
    
//    make.bottom.mas_equalTo(_detailView.mas_bottom);
    [_transportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_domainView.mas_bottom).offset(0);
        make.left.mas_equalTo(_containerView).offset(padding);
        make.height.mas_equalTo(@(inputBoxHeight));
        make.right.mas_equalTo(_detailView);
    }];
    
    [_encryptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_transportView.mas_bottom).offset(0);
        make.left.mas_equalTo(_containerView).offset(padding);
        make.height.mas_equalTo(@(inputBoxHeight));
        make.right.mas_equalTo(_detailView);
    }];
    
    [_encryptionPort mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_encryptionView.mas_bottom).offset(0);
        make.left.mas_equalTo(_containerView).offset(padding);
        make.height.mas_equalTo(@(inputBoxHeight));
        make.right.mas_equalTo(_detailView);
    }];
}

- (void)setEncryptionType:(VETEncryptionType)encryptionType
{
    _encryptionType = encryptionType;
    _encryptionSeg.selectedSegmentIndex = encryptionType;
}

- (void)setTransportType:(VETTransportType)transportType
{
    _transportType = transportType;
    _transportSeg.selectedSegmentIndex = transportType;
}

@end
