//
//  VETSearchContacts.m
//  VETEphone
//
//  Created by Liu Yang on 31/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import "VETResultsContactsController.h"
#import "AddContactsCell.h"
#import "VETAppleContact.h"
#import "VETContactDetailViewController.h"
#import "VETCallHelper.h"
#import "VETSearchAreaCodeManager.h"

@interface VETResultsContactsController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation VETResultsContactsController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"self.tableView:%@", self.tableView);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    if (IOS_VERSION >= 11.0) {
        adjustsScrollViewInsets_NO(self.tableView, self);
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredContacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddContactsCell *cell = (AddContactsCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (cell == nil) {
        cell = [[AddContactsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    VETAppleContact *contact = self.filteredContacts[indexPath.row];
    [self configCell:cell forContacts:contact atIndexPath:indexPath];
    [cell.callBtn addTarget:self action:@selector(tapCallBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VETAppleContact *contact = [self.filteredContacts objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedDismiss:)]) {
        [self.delegate didSelectedDismiss:contact];
    }
}

- (void)tapCallBtn:(id)sender
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(searchControllerDissmiss)]) {
//        [self.delegate searchControllerDissmiss];
    
        PLCustomCellBtn *btn = (PLCustomCellBtn *)sender;
        NSIndexPath *indexPath = btn.selectIndexpath;
        VETAppleContact *contacts = [_filteredContacts objectAtIndex:indexPath.row];
        
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
            NSString *callPhone = mobileModel.mobileContent;
//            if (callPhone.length == 11) {
//                NSString *firstStr = [callPhone substringToIndex:1];
//                if ([firstStr isEqualToString:@"1"]) {
//                    callPhone = [NSString stringWithFormat:@"86 %@",callPhone];
//                    [[VETSearchAreaCodeManager sharedInstance] searchAreaCode:@"86" completion:^(VETAreaCode *areaCode) {
//                        NSLog(@"-----%@",areaCode.code);
//                    }];
//                }
//            }
            [VETCallHelper outgoingWithPhoneString:callPhone target:self];
        }
    //}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(resultsContactsHideKeyboard)]) {
        [self.delegate resultsContactsHideKeyboard];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.height = SCREEN_HEIGHT-frame.size.height;
    self.tableView.contentSize = CGSizeMake(SCREEN_WIDTH, self.tableView.height + 1);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.tableView.height = SCREEN_HEIGHT;
    self.tableView.contentSize = CGSizeMake(SCREEN_WIDTH, self.tableView.height + 1);
}

@end
