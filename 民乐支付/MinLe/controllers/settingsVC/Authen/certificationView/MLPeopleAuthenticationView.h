//
//  MLPeopleAuthenticationView.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/22.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLayerView.h"
#import "MLMyTextField.h"
#import "MLMinLeTextField.h"

@interface MLPeopleAuthenticationView : BaseLayerView
@property (nonatomic, strong) MLMinLeTextField *nameTextField;
@property (nonatomic, strong) MLMinLeTextField *phoneTextField;
@property (nonatomic, strong) MLMinLeTextField *haomaTextField;
@property (nonatomic, strong) MLMinLeTextField *jcTextField;
@property (nonatomic, strong) MLMinLeTextField *qcTextField;
@property (nonatomic, strong) MLMinLeTextField *dzTextField;
@property (nonatomic, strong) MLMinLeTextField *yingYeTextField;

@property (nonatomic, strong) UIButton *but1;//门面照片
@property (nonatomic, strong) UIButton *but2;//办公场地照片
@property (nonatomic, strong) UIButton *but3;//收银台照片
@property (nonatomic, strong) UIButton *but4;//营业执照照片
@property (nonatomic, strong) UIButton *but5;//营业协议照片

@end
