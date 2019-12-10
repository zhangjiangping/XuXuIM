//
//  VETCallHelper.h
//  MobileVoip
//
//  Created by Liu Yang on 09/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VETCallHelper : NSObject

+ (void)outgoingWithPhoneString:(NSString *)phoneString target:(id)target;

@end
