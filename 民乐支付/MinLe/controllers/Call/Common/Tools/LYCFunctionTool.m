//
//  LYCFunctionTool.m
//  MyIOSNote
//
//  Created by Liu Yang on 08/07/2017.
//  Copyright © 2017 youngliu. All rights reserved.
//

#import "LYCFunctionTool.h"

@implementation LYCFunctionTool

int findChar(char *str,char *find)
{
    int i,j,n = 0;
    for(i = 0; str[i]; i++)
    {
        if(str[i] == find[0])
            for(j = 1 ;; j++)
            {
                if(find[j] == 0)return i+1;//返回位置
                if(find[j] == str[i+j]) n++;
                else break;
            }
    }
    return 0;//不存在返回0
}

bool isNumberWithChar(char aChar)
{
    if(aChar >='0' && aChar <= '9')
    {
        return true;
    }
    else {
        return false;
    }
}

bool isLetterWithChar(char aChar)
{
    if((aChar >='a' && aChar <= 'z') || (aChar >= 'A' && aChar <= 'Z'))
    {
        return true;
    }
    return false;
}

@end
