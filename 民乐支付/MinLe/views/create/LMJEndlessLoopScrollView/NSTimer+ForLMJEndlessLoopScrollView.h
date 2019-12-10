//
//  NSTimer+ForLMJEndlessLoopScrollView.h
//  LMJEndlessLoopScroll
//
//  Created by Major on 16/3/10.
//  Copyright © 2016年 iOS开发者公会. All rights reserved.
//
//  iOS开发者公会-技术1群 QQ群号：87440292
//  iOS开发者公会-技术2群 QQ群号：232702419
//  iOS开发者公会-议事区  QQ群号：413102158
//

#import <Foundation/Foundation.h>

@interface NSTimer (ForLMJEndlessLoopScrollView)

// 暂停
- (void)pause;
// 重新开始
- (void)restart;
// 延迟一定时间启动
- (void)restartAfterTimeInterval:(NSTimeInterval)interval;

@end
