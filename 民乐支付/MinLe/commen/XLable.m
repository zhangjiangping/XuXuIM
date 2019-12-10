//
//  XLable.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/10.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "XLable.h"

@implementation XLable

- (BOOL)canBecomeFirstResponder {
    
    return YES;
}

// 可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    return (action == @selector(copy:));
}

//针对于响应方法的实现
-(void)copy:(id)sender {
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}

//UILabel默认是不接收事件的，我们需要自己添加touch事件
- (void)attachTapHandler {
    
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:touch];
}

//绑定事件
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self attachTapHandler];
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self attachTapHandler];
}

- (void)handleTap:(UIGestureRecognizer *)recognizer {
    [self becomeFirstResponder];
    if (recognizer.state == UIGestureRecognizerStateBegan ) {
        UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:[CommenUtil LocalizedString:@"Common.Copy"]
                                                          action:@selector(copy:)];
        [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
        [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
    }
}

@end
