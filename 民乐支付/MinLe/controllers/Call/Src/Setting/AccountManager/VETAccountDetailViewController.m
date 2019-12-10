//
//  VETAccountDetailViewController.m
//  MobileVoip
//
//  Created by Liu Yang on 16/05/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETAccountDetailViewController.h"
#import "VETAccount.h"

@interface VETAccountDetailViewController ()

@end

@implementation VETAccountDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.displayTextfield.text = _account.displayName;
    self.usernameTextfield.text = _account.username;
    self.passwordTextfield.text = _account.password;
    self.domainTextfield.text = _account.domain;
    
    self.displayTextfield.textColor = [UIColor grayColor];
    self.usernameTextfield.textColor = [UIColor grayColor];
    self.passwordTextfield.textColor = [UIColor grayColor];
    self.domainTextfield.textColor = [UIColor grayColor];
    
    self.displayTextfield.enabled = NO;
    self.usernameTextfield.enabled = NO;
    self.passwordTextfield.enabled = NO;
    self.domainTextfield.enabled = NO;
}

- (void)setAccount:(VETAccount *)account
{
    _account = account;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
