//
//  MLInformationView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/24.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLInformationView.h"
#import "UIView+Responder.h"
#import "UIViewController+XHPhoto.h"
#import "MLChangeNameViewController.h"
#import "MLNextStepPhoneViewController.h"
#import "UIImage+MLMyimage.h"
#import "MLInformationViewController.h"

@interface MLInformationView ()
{
    NSArray *array;
}
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *sexLable;
@property (nonatomic, strong) UILabel *myLable;
@property (nonatomic, strong) UIImageView *nameImg;
@property (nonatomic, strong) UIImageView *sexImg;
@property (nonatomic, strong) UIImageView *myPhoneImg;
@property (nonatomic, strong) UIView *layerView;

@property (nonatomic, strong) NSString *nameState;
@end

@implementation MLInformationView

- (instancetype)initWithFrame:(CGRect)frame withStr:(NSString *)editStr withImg:(UIImage *)img
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.layerView];
        [self addSubview:self.img];
        [self addSubview:self.nameLable];
        [self addSubview:self.sexLable];
        [self addSubview:self.nameBut];
        [self addSubview:self.sexBut];
        [self addSubview:self.myLable];
        [self addSubview:self.myPhoneBut];
        
        _img.image = img;
    }
    return self;
}

- (UIView *)layerView
{
    if (!_layerView) {
        _layerView = [[UIView alloc] initWithFrame:CGRectMake((widths-104)/2, 28, 104, 104)];
        _layerView.layer.cornerRadius = 52;
        _layerView.backgroundColor = [UIColor whiteColor];
        _layerView.alpha = 0.5;
    }
    return _layerView;
}

- (UIImageView *)img
{
    if (!_img) {
        _img = [[UIImageView alloc] initWithFrame:CGRectMake((widths-100)/2, 30, 100, 100)];
        _img.layer.cornerRadius = 50;
        _img.clipsToBounds = YES;
        _img.userInteractionEnabled = YES;
        _img.contentMode = UIViewContentModeScaleAspectFill;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playAction:)];
        [_img addGestureRecognizer:tap];
    }
    return _img;
}

- (UILabel *)nameLable
{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.img.frame)+30, 75, 30)];
        _nameLable.text = [NSString stringWithFormat:@"%@:",[CommenUtil LocalizedString:@"Me.UserName"]];
        _nameLable.alpha = 0.6;
    }
    return _nameLable;
}

- (UILabel *)sexLable
{
    if (!_sexLable) {
        _sexLable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.nameLable.frame)+20, 75, 30)];
        _sexLable.text = [NSString stringWithFormat:@"%@:",[CommenUtil LocalizedString:@"Me.Sex"]];
        _sexLable.alpha = 0.6;
    }
    return _sexLable;
}

- (UIButton *)nameBut
{
    if (!_nameBut) {
        _nameBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _nameBut.frame = CGRectMake(CGRectGetMaxX(self.nameLable.frame), CGRectGetMinY(self.nameLable.frame), widths-CGRectGetMaxX(self.nameLable.frame)-15, 30);
        _nameBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _nameBut.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_nameBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_nameBut addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [_nameBut addSubview:self.nameImg];
    }
    return _nameBut;
}
//代表可修改编辑的图片
- (UIImageView *)nameImg
{
    if (!_nameImg) {
        _nameImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.nameBut.frame)-20, 5, 20, 20)];
        _nameImg.image = [UIImage imageNamed:@"infor.jpg"];
        _nameImg.clipsToBounds = YES;
    }
    return _nameImg;
}

- (UIButton *)sexBut
{
    if (!_sexBut) {
        _sexBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _sexBut.frame = CGRectMake(CGRectGetMaxX(self.sexLable.frame), CGRectGetMinY(self.sexLable.frame), widths-CGRectGetMaxX(self.sexLable.frame)-15, 30);
        _sexBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _sexBut.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_sexBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sexBut addTarget:self action:@selector(chooseSexAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sexBut addSubview:self.sexImg];
    }
    return _sexBut;
}
//代表可修改编辑的图片
- (UIImageView *)sexImg
{
    if (!_sexImg) {
        _sexImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.sexBut.frame)-20, 5, 20, 20)];
        _sexImg.image = [UIImage imageNamed:@"infor.jpg"];
        _sexImg.clipsToBounds = YES;
    }
    return _sexImg;
}

- (UILabel *)myLable
{
    if (!_myLable) {
        _myLable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.sexLable.frame)+20, 75, 30)];
        _myLable.text = [NSString stringWithFormat:@"%@:",[CommenUtil LocalizedString:@"Me.BindingNumber"]];
        _myLable.alpha = 0.6;
    }
    return _myLable;
}

- (UIButton *)myPhoneBut
{
    if (!_myPhoneBut) {
        _myPhoneBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _myPhoneBut.frame = CGRectMake(CGRectGetMaxX(self.myLable.frame), CGRectGetMinY(self.myLable.frame), widths-CGRectGetMaxX(self.myLable.frame)-15, 30);
        _myPhoneBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _myPhoneBut.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_myPhoneBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_myPhoneBut addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
        [_myPhoneBut addSubview:self.myPhoneImg];
    }
    return _myPhoneBut;
}

- (UIImageView *)myPhoneImg
{
    if (!_myPhoneImg) {
        _myPhoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.myPhoneBut.frame)-20, 5, 20, 20)];
        _myPhoneImg.image = [UIImage imageNamed:@"infor.jpg"];
        _myPhoneImg.clipsToBounds = YES;
    }
    return _myPhoneImg;
}

//修改手机号码

- (void)pushAction:(UIButton *)sender
{
    [self.viewController.navigationController pushViewController:[[MLNextStepPhoneViewController alloc] init] animated:YES];
}

//修改名字
- (void)chooseAction:(UIButton *)sender
{
    MLInformationViewController *inVC = (MLInformationViewController *)self.viewController;
    if (![_nameState isEqualToString:@"1"]) {
        MLChangeNameViewController *changeNameVC = [[MLChangeNameViewController alloc] init];
        changeNameVC.block = ^(NSString *name) {
            if (![name isEqualToString:self.nameBut.titleLabel.text]) {
                //刷新状态
                [inVC upLoadReuest];
                
                [self changeNameRequest:name];
            }
        };
        [inVC.navigationController pushViewController:changeNameVC animated:YES];
    } else {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Me.NameChangeOnes"] showView:nil];
    }
}

- (void)changeNameRequest:(NSString *)name
{
    [[MCNetWorking sharedInstance] createPostWithUrlString:changeNameURL withParameter:@{@"username":name,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} withComplection:^(id responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            [self.nameBut setTitle:name forState:UIControlStateNormal];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@", error);
    }];
}

//修改性别
- (void)chooseSexAction:(UIButton *)sender
{
    array = @[[CommenUtil LocalizedString:@"Me.Secret"],[CommenUtil LocalizedString:@"Me.Female"],[CommenUtil LocalizedString:@"Me.Male"],@""];
    //从底部弹出选择框
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [ac addAction:[UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Me.Secret"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self sexRequestWithSexName:array[0] withIndex:0];//接口请求
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Me.Female"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self sexRequestWithSexName:array[1] withIndex:1];//接口请求
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Me.Male"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self sexRequestWithSexName:array[2] withIndex:2];//接口请求

    }]];
    [ac addAction:[UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Common.Cancle"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self.viewController presentViewController:ac animated:YES completion:nil];
}

//修改性别请求接口
- (void)sexRequestWithSexName:(NSString *)str withIndex:(NSInteger)index
{
    if (index != 3) {
        [[MCNetWorking sharedInstance] myPostWithUrlString:update_sexURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"sex":str} withComplection:^(id responseObject) {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            if ([responseObject[@"status"] isEqual:@1]) {
                //成功后处理事件
                [self.sexBut setTitle:array[index] forState:UIControlStateNormal];
            }
        } withFailure:^(NSError *error) {
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
            NSLog(@"%@", error);
        }];
    }
}

//点击从相册中获取
- (void)playAction:(UIButton *)sender
{
    /*
     edit:照片需要裁剪:传YES,不需要裁剪传NO(默认NO)
     */
    [self.viewController showCanEdit:YES photo:^(UIImage *photo) {
        //处理传回来的图片
        UIImage *myImage = [photo resetImgFrame:self.img withImage:photo];
        NSDictionary *dic = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
        [[MCNetWorking sharedInstance] myImageRequestWithUrlString:update_picURL withParameter:dic withKey:@"path_img" withImageArray:@[photo] withComplection:^(id responseObject) {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            if ([responseObject[@"status"] isEqual:@1]) {
                _img.image = myImage;
            }
        } withFailure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }];
}

- (NSString *)status
{
    return _nameState;
}

- (void)setStatus:(NSString *)status
{
    _nameState = status;
}

@end





















