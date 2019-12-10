//
//  NSString+VETVoipExtension.h
//  MobileVoip
//
//  Created by Liu Yang on 02/05/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pjsua-lib/pjsua.h>

@interface NSString (VETVoipExtension)

// Returns an NSString object created from a given PJSUA string.
+ (NSString *)stringWithPJString:(pj_str_t)pjString;

// Returns PJSUA string created from the receiver.
- (pj_str_t)pjString;

@end
