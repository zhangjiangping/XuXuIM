//
//  UIView+Extension.m
//  Manager
//
//  Created by Young on 15/11/27.
//  Copyright (c) 2015年 LXJ. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

//x属性的get,set
-(void)setX:(CGFloat)x
{
    CGRect frame=self.frame;
    frame.origin.x=x;
    self.frame=frame;
}
-(CGFloat)x
{
    return self.frame.origin.x;
}
//centerX属性的get,set
-(void)setCenterX:(CGFloat)centerX
{
    CGPoint center=self.center;
    center.x=centerX;
    self.center=center;
}
-(CGFloat)centerX
{
    return self.center.x;
}
//centerY属性的get,set
-(void)setCenterY:(CGFloat)centerY
{
    CGPoint center=self.center;
    center.y=centerY;
    self.center=center;
}
-(CGFloat)centerY
{
    return self.center.y;
}
//y属性的get,set
-(void)setY:(CGFloat)y
{
    CGRect frame=self.frame;
    frame.origin.y=y;
    self.frame=frame;
}
-(CGFloat)y
{
    return self.frame.origin.y;
}
//width属性的get,set
-(void)setWidth:(CGFloat)width
{
    CGRect frame=self.frame;
    frame.size.width=width;
    self.frame=frame;
}
-(CGFloat)width
{
    return self.frame.size.width;
}
//height属性的get,set
-(void)setHeight:(CGFloat)height
{
    CGRect frame=self.frame;
    frame.size.height=height;
    self.frame=frame;
}
-(CGFloat)height
{
    return self.frame.size.height;
}
//size属性的get,set
-(void)setSize:(CGSize)size
{
    CGRect frame=self.frame;
    frame.size.width=size.width;
    frame.size.height=size.height;
    self.frame=frame;
}
-(CGSize)size
{
    return self.frame.size;
}
//origin属性的get,set,用于设置坐标
-(void)setOrigin:(CGPoint)origin
{
    CGRect frame=self.frame;
    frame.origin.x=origin.x;
    frame.origin.y=origin.y;
    self.frame=frame;
}
-(CGPoint)origin
{
    return self.frame.origin;
}

@end
