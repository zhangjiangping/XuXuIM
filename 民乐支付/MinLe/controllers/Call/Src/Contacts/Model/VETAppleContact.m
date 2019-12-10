//
//  VETAppleContacts.m
//  VETEphone
//
//  Created by Liu Yang on 30/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import "VETAppleContact.h"

@implementation VETAppleContact

- (void)setFirstName:(NSString *)firstName
{
    _firstName = firstName;
    _fullName = [NSString stringWithFormat:@"%@ %@", _lastName, firstName];
}

- (void)setLastName:(NSString *)lastName
{
    _lastName = lastName;
    _fullName = [NSString stringWithFormat:@"%@ %@",lastName, _firstName];
}

@end

@implementation VETMobileModel

- (instancetype)initWithMobileType:(NSString *)mobileType mobileNumber:(NSString *)mobileContent
{
    if (self = [super init]) {
        _mobileType = mobileType;
        _mobileContent = mobileContent;
    }
    return self;
}

@end
