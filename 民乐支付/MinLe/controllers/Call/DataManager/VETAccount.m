//
//  VETAccount.m
//  VETEphone
//
//  Created by Liu Yang on 28/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import "VETAccount.h"

@implementation VETAccount

- (void)setEncryptionType:(VETEncryptionType)encryptionType
{
    _encryptionType = encryptionType;
    if (_encryptionType == VETEncryptionTypeRC4) {
        _domain = [NSString stringWithFormat:@"%@:5070", _domain];
    }
}

@end
