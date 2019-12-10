//
//  NSNotificationCenter+LYXExtension.m
//  VETEphone
//
//  Created by Liu Yang on 01/04/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import "NSNotificationCenter+LYXExtension.h"
#import <pthread.h>

@implementation NSNotificationCenter (LYXExtension)

- (void)postNotificationOnMainThread:(NSNotification *)notification
{
    if (pthread_main_np()) return [self postNotification:notification];
    [[self class] performSelectorOnMainThread:@selector(lyxPostNotification:) withObject:notification waitUntilDone:NO];
}

+ (void)lyxPostNotification:(NSNotification *)notification
{
    [[self defaultCenter] postNotification:notification];
}

@end
