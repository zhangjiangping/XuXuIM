//
//  FaceScanningView.h
//  民乐支付
//
//  Created by JP on 2017/7/26.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FaceScanningView;
@protocol FaceScanningViewDelegate <NSObject>

- (void)scanningView:(FaceScanningView *)scanningView didFinishScanCode:(NSString *)content;

@end

/**
 提供对二维码，条形码的扫描支持的控件
 需要注意：因为用到了定时器，当不需要用到这个view的时候，需要调用stopScanning方法，要不然对象不会施放
 */
@interface FaceScanningView : UIView

@property (nonatomic, weak) id<FaceScanningViewDelegate> delegate;
/**
 标志是否正在扫描
 */
@property (nonatomic, getter=isReading) BOOL reading;

/**
 默认是YES，设置是否开启自动扫描，
 */
@property (nonatomic) BOOL autoRead;
/**
 识别框的大小
 */
@property (nonatomic) IBInspectable CGRect boxFrame;
/**
 识别框外覆盖的颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *coverColor;

/**
 开始扫描
 */
- (void)startScanning;
/**
 停止扫描
 */
- (void)stopScanning;

- (void)setBarFrame:(CGRect)barFrame;

- (void)startRunning;

- (void)stopRunning;

@end
