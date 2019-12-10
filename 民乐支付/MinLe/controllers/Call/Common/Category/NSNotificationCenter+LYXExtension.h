//
//  NSNotificationCenter+LYXExtension.h
//  VETEphone
//
//  Created by Liu Yang on 01/04/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (LYXExtension)

- (void)postNotificationOnMainThread:(NSNotification *)notification;

@end
