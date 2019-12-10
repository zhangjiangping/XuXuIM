//
//  CertificationView.h
//  live
//
//  Created by SZVETRON-iMAC on 2017/1/10.
//  Copyright © 2017年 SZVetron. All rights reserved.
//

#import <UIKit/UIKit.h>

//拍摄的几种状态
typedef NS_ENUM(int, TakingPicturesState){
    TakingPicturesStateDefault = 0,/**< 默认(未拍摄) */
    TakingPicturesStateEnded = 1,/**< 拍摄完成 */
};

@interface CertificationView : UIView

@property (nonatomic, strong) UIImageView *leftImg;
@property (nonatomic, strong) UIButton *rightBut;

@property (nonatomic, assign) TakingPicturesState state;

- (instancetype)initWithFrame:(CGRect)frame withLeftImgName:(NSString *)leftName withAddName:(NSString *)addName;

@end
