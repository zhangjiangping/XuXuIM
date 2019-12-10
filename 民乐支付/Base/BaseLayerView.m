//
//  BaseLayerView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/22.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "BaseLayerView.h"

@implementation BaseLayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.shadowOffset = CGSizeMake(0, 1); //设置阴影的偏移量
        self.layer.shadowRadius = 1.0;  //设置阴影的半径
        self.layer.shadowColor = [UIColor blackColor].CGColor; //设置阴影的颜色为黑色
        self.layer.shadowOpacity = 0.2; //设置阴影的不透明度
        self.backgroundColor = [UIColor whiteColor];
        
//        CGColorSpaceRef colorSpace = CGColorGetColorSpace([[UIColor redColor] CGColor]);
    }
    return self;
}

- (void)hideLayer
{
    self.layer.cornerRadius = 5;
    self.layer.shadowOffset = CGSizeMake(0, 0); //设置阴影的偏移量
    self.layer.shadowRadius = 0.0;  //设置阴影的半径
    self.layer.shadowColor = [UIColor clearColor].CGColor; //设置阴影的颜色为黑色
    self.layer.shadowOpacity = 0.0; //设置阴影的不透明度
}

@end
