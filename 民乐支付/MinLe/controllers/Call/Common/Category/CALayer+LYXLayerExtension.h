//
//  CALayer+LYXLayerExtension.h
//  YWXClothingMatch
//
//  Created by young on 16/12/20.
//  Copyright © 2016年 young. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (LYXLayerExtension)

@property (nonatomic, weak) UIColor *borderUIColor;
//  设置border宽度为1
@property (nonatomic, assign) BOOL borderWidthOnePix;

@end
