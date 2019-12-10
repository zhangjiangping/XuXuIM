//
//  VETAddAccountViewController.m
//  VETEphone
//
//  Created by Liu Yang on 28/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import "VETAddAccountViewController.h"
#import "LYAlertViewHelper.h"
#import "VETAccount.h"
#import "DBUtil.h"
#import "UIBarButtonItem+Extension.h"

@interface VETAddAccountViewController ()

@end

@implementation VETAddAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"OK") style:UIBarButtonItemStylePlain target:self action:@selector(tapCancelButton:)];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back_icon" highImageName:@"back_icon" target:self action:@selector(tapCancelButton:)];
    self.navigationItem.leftBarButtonItem.tintColor = MAINTHEMECOLOR;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"OK", @"OK") style:UIBarButtonItemStylePlain target:self action:@selector(tapConfirmButton:)];
    self.navigationItem.rightBarButtonItem.tintColor = MAINTHEMECOLOR;
    
    self.transportType = VETTransportTypeUDP;
    self.encryptionType = VETEncryptionTypeNone;
    [self.transportSeg addTarget:self action:@selector(tapTransportSeg:) forControlEvents:UIControlEventValueChanged];
    [self.encryptionSeg addTarget:self action:@selector(tapEncryptionSeg:) forControlEvents:UIControlEventValueChanged];
}

- (void)tapCancelButton:(id)sender
{
    LYLog(@"transport seg :%ld", self.transportSeg.selectedSegmentIndex);
    LYLog(@"encryption seg :%ld", self.encryptionSeg.selectedSegmentIndex);
    
    BOOL displayNameHaveValue = (self.displayTextfield.text.length > 0);
    BOOL userNameHaveValue = (self.usernameTextfield.text.length > 0);
    BOOL passwordHaveValue = (self.passwordTextfield.text.length > 0);
    BOOL domainHaveValue = (self.domainTextfield.text.length > 0);
    //  如果都没填，就可以直接取消
    if (!displayNameHaveValue && !userNameHaveValue && !passwordHaveValue && !domainHaveValue) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"Cancel to save lost records", @"Setting") preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"YES", "OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"NO", "OK") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)tapConfirmButton:(id)sender
{
    if (![self inputValid])  return;
    
    VETAccount *account = [VETAccount new];
    account.username = self.usernameTextfield.text;
    account.password = self.passwordTextfield.text;
    account.displayName = self.displayTextfield.text;
    
    // account domain
    if (self.portTextfield.text.length > 0) {
        account.domain = [NSString stringWithFormat:@"%@:%@", self.domainTextfield.text, self.portTextfield.text];
    }
    else {
        account.domain = self.domainTextfield.text;
    }
    account.encryptionType = self.encryptionType;
    account.transportType = self.transportType;
    
    [[DBUtil sharedManager] addAccount:account];
    //[self showHint:NSLocalizedString(@"Account save success", @"Setting")];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)inputValid
{
    if (!(self.displayTextfield.text.length > 0)) {
        [self alertView:NSLocalizedString(@"display name is null", @"Setting")];
        return NO;
    }
    if (!(self.usernameTextfield.text.length > 0 )) {
        [self alertView:NSLocalizedString(@"Account is null", @"Setting")];
        return NO;
    }
    if (!(self.passwordTextfield.text.length > 0 )) {
        [self alertView:NSLocalizedString(@"Password is null", @"Setting")];
        return NO;
    }
    if (!(self.domainTextfield.text.length > 0 )) {
        [self alertView:NSLocalizedString(@"Domain is null", @"Setting")];
        return NO;
    }
    return YES;
}

- (void)alertView:(NSString *)content
{
    [LYAlertViewHelper alertViewStrongWithTagert:self title:@"" content:content confirmEvent:nil];
}

#pragma mark - Segment event 

- (void)tapTransportSeg:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    LYLog(@"tapTransportSeg :%ld", seg.selectedSegmentIndex);
    if (self.encryptionType == VETEncryptionTypeRC4) {
        if (self.transportType != VETTransportTypeUDP) {
            [LYAlertViewHelper alertViewStrongWithTagert:self title:@"" content:NSLocalizedString(@"RC4 only support UDP", @"Setting") confirmEvent:nil];
        }
        self.transportType = VETTransportTypeUDP;
    }
}

- (void)tapEncryptionSeg:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    LYLog(@"tapEncryptionSeg :%d", seg.selectedSegmentIndex);
    self.encryptionType = seg.selectedSegmentIndex;
    // 选择RC4，只能是UDP传输
    if (self.encryptionType == VETEncryptionTypeRC4) {
        self.transportType = VETTransportTypeUDP;
    }
}

@end
