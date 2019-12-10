//
//  MLHomeXiaView.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/19.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMJEndlessLoopScrollView.h"

@interface MLHomeXiaView : UIView <LMJEndlessLoopScrollViewDelegate>

@property (nonatomic, strong) LMJEndlessLoopScrollView *accountScrollView;//公告显示

//更新视图
- (void)updataView:(NSArray *)accountArray;

@end
