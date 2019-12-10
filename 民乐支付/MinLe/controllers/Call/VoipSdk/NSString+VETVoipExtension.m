//
//  NSString+VETVoipExtension.m
//  MobileVoip
//
//  Created by Liu Yang on 02/05/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "NSString+VETVoipExtension.h"

@implementation NSString (VETVoipExtension)

+ (NSString *)stringWithPJString:(pj_str_t)pjString {
    return [[NSString alloc] initWithBytes:pjString.ptr
                                    length:(NSUInteger)pjString.slen
                                  encoding:NSUTF8StringEncoding];
}

- (pj_str_t)pjString {
    return pj_str((char *)[self cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
