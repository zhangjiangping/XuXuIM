//
//  NSArray+LYXExtension.m
//  YWXClothingMatch
//
//  Created by young on 17/02/2017.
//  Copyright © 2017 young. All rights reserved.
//

#import "NSArray+LYXExtension.h"

@implementation NSArray (LYXExtension)

+ (id)sortRandomlyWithArrary:(id)arrary
{
    NSMutableArray *mutableArrary;
    if ([arrary isKindOfClass:[NSMutableArray class]]) {
        mutableArrary = [arrary mutableCopy];
    }
    else if ([arrary isKindOfClass:[NSArray class]]){
        mutableArrary = [NSMutableArray arrayWithArray:arrary];
    }
    NSUInteger count = [mutableArrary count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [mutableArrary exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    if ([arrary isKindOfClass:[NSMutableArray class]]) {
        return [mutableArrary mutableCopy];
    }
    else {
        return [mutableArrary copy];
    }
}

@end
