//
//  LYCFunctionTool.h
//  MyIOSNote
//
//  Created by Liu Yang on 08/07/2017.
//  Copyright © 2017 youngliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYCFunctionTool : NSObject

int findChar(char *str,char *find);
bool isNumberWithChar(char aChar);
bool isLetterWithChar(char aChar);

@end

