//
//  MLZHViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/12/29.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLZHViewController.h"

@interface MLZHViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UITableView *listTable;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *tureBut;
@property (nonatomic, strong) UILabel *messagelable;
@end

@implementation MLZHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI
{
    self.dataArray = [NSArray array];
    [self.view addSubview:self.naView];
    [self updata];
}

- (void)updata
{
    NSDictionary *dic = @{@"cityName":self.cityName,@"bankCode":self.bankName};
    [[MCNetWorking sharedInstance] createPostWithUrlString:getBankNumberVoneURL withParameter:dic withComplection:^(NSDictionary *responseObject) {
        NSLog(@"%@----%@",dic,responseObject[@"msg"]);
        if ([responseObject[@"status"] isEqual:@1]) {
            if (!self.textField) {
                [self.textField removeFromSuperview];
                self.textField = nil;
            }
            if (!self.messagelable) {
                [self.messagelable removeFromSuperview];
                self.messagelable = nil;
            }
            self.tureBut.hidden = YES;
            self.dataArray = responseObject[@"data"];
            [self.view addSubview:self.listTable];
        } else {
            if (!self.listTable) {
                [self.listTable removeFromSuperview];
                self.listTable = nil;
            }
            self.tureBut.hidden = NO;
            [self.view addSubview:self.messagelable];
            [self.view addSubview:self.textField];
            [self.textField becomeFirstResponder];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}

- (void)tureAction
{
    self.zhihangLable.text = self.textField.text;
    self.zhihangLable.textColor = [UIColor blackColor];
    self.lhhTextField.text = @"";
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *bankCellid = @"bankCellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bankCellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bankCellid];
    }
    cell.textLabel.text = self.dataArray[indexPath.row][@"cnaps_name"];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = self.dataArray[indexPath.row][@"cnaps_name"];
    self.zhihangLable.text = str;
    self.zhihangLable.textColor = [UIColor blackColor];
    self.lhhTextField.text = self.dataArray[indexPath.row][@"cnaps_code"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)listTable
{
    if (!_listTable) {
        _listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64) style:UITableViewStylePlain];
        _listTable.delegate = self;
        _listTable.dataSource = self;
    }
    return _listTable;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, screenWidth, 44)];
        _textField.delegate = self;
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.layer.borderWidth = 0.5;
        _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        _textField.leftViewMode = UITextFieldViewModeUnlessEditing;
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    }
    return _textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Authen.OpenBranch"]];
        [_naView addSubview:self.tureBut];
    }
    return _naView;
}

- (UIButton *)tureBut
{
    if (!_tureBut) {
        _tureBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _tureBut.frame = CGRectMake(CGRectGetWidth(self.naView.frame)-60, 14, 50, 50);
        [_tureBut setTitle:[CommenUtil LocalizedString:@"Common.Ture"] forState:UIControlStateNormal];
        [_tureBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tureBut addTarget:self action:@selector(tureAction) forControlEvents:UIControlEventTouchUpInside];
        _tureBut.titleLabel.font = FT(17);
        _tureBut.hidden = YES;
    }
    return _tureBut;
}

- (UILabel *)messagelable
{
    if (!_messagelable) {
        _messagelable = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, screenWidth-20, 36)];
        _messagelable.text = [CommenUtil LocalizedString:@"Authen.BranchManuallyEnter"];
        _messagelable.textColor = [UIColor lightGrayColor];
        _messagelable.font = FT(15);
    }
    return _messagelable;
}

#pragma mark - UITextView delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textField) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 16) {
            UIAlertController *atCL = [UIAlertController alertControllerWithTitle:[CommenUtil LocalizedString:@"Common.Prompt"] message:[CommenUtil LocalizedString:@"Authen.MoreThen16Text"] preferredStyle:UIAlertControllerStyleAlert];
            [atCL addAction:[UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Common.Know"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:atCL animated:YES completion:nil];
            return NO;
        }
    }
    return YES;
}

@end






