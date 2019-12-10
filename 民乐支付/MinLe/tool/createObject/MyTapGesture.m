//
//  MyTapGesture.m
//  live
//
//  Created by SZVetron on 28/10/16.
//  Copyright © 2016年 SZVetron. All rights reserved.
//

#import "MyTapGesture.h"

@implementation MyTapGesture


-(id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    
    if(self)
    {
        self.delegate = self;
    }
    
    return self;
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}






@end
