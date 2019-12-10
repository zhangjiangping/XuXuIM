//
//  HYScanningView.h
//  QRCodeTest
//
//  Created by yanghaha on 15/12/8.
//  Copyright © 2015年 yanghaha. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYScanningView;
@protocol HYScanningViewDelegate <NSObject>

- (void)scanningView:(HYScanningView *)scanningView didFinishScanCode:(NSString *)content;
- (void)camerPermission:(BOOL)isPermission;

@end

typedef enum : NSUInteger {
    HYScanningViewTypeQR,
    HYScanningViewTypeBar,
    HYScanningViewTypeQRBar,
} HYScanningViewType;

/**
 提供对二维码，条形码的扫描支持的控件
 需要注意：因为用到了定时器，当不需要用到这个view的时候，需要调用stopScanning方法，要不然对象不会施放
 */
@interface HYScanningView : UIView

@property (nonatomic, weak) UIViewController *vc;

@property (nonatomic, weak) IBOutlet id<HYScanningViewDelegate> delegate;
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
 *  边角颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *cornerColor;

/**
 扫描线的颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *scanningLineColor;

#if TARGET_INTERFACE_BUILDER
@property (nonatomic) IBInspectable NSUInteger type;
#else
@property (nonatomic) HYScanningViewType type;
#endif

/**
 开始扫描
 */
- (void)startScanning;
/**
 停止扫描
 */
- (void)stopScanning;

- (void)setBarFrame:(CGRect)barFrame;

@end
