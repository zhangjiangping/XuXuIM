//
//  MLInformationView.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/24.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "BaseLayerView.h"

@interface MLInformationView : BaseLayerView
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UIButton *nameBut;
@property (nonatomic, strong) UIButton *sexBut;
@property (nonatomic, strong) UIButton *myPhoneBut;
- (instancetype)initWithFrame:(CGRect)frame withStr:(NSString *)editStr withImg:(UIImage *)img;

@property (nonatomic, assign) NSString *status;

@end
