//
//  CertificationNameView.h
//  民乐支付
//
//  Created by JP on 2017/7/24.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import "BaseLayerView.h"
#import "CertificationView.h"
#import "MLMinLeTextField.h"

@protocol CertificationNameProtocol <NSObject>

- (void)selectedEnder;

@end

@interface CertificationNameView : BaseLayerView

@property (nonatomic, strong) CertificationView *fView;
@property (nonatomic, strong) CertificationView *zView;

@property (nonatomic, strong) MLMinLeTextField *nameTextField;
@property (nonatomic, strong) MLMinLeTextField *nameNumberTextField;

@property (nonatomic, weak) id <CertificationNameProtocol> nameDelegate;

@end
