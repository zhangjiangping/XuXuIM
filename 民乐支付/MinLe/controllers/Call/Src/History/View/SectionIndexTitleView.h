//
//  SectionIndexTitleView.h
//  minlePay
//
//  Created by JP on 2017/10/25.
//  Copyright © 2017年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SectionIndexTitleViewDelegate <NSObject>

- (void)scrollTableSectionWithSectionIndex:(NSInteger)sectionIndex;

@end

@interface SectionIndexTitleView : UIView

- (instancetype)initWithFrame:(CGRect)frame withIndexArray:(NSArray *)indexArray;

- (void)updataUI:(NSArray *)sectionIndexArray;

@property (nonatomic, weak) id <SectionIndexTitleViewDelegate> delegate;

@end
