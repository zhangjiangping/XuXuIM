//
//  LHSIDCardScaningView.m
//  身份证识别
//
//  Created by huashan on 2017/2/17.
//  Copyright © 2017年 LiHuashan. All rights reserved.
//

#import "LHSIDCardScaningView.h"

@interface IDCardCornerView : UIView
{
    UIBezierPath *_lefTopCorner;
    UIBezierPath *_rightTopCorner;
    UIBezierPath *_leftBottomCorner;
    UIBezierPath *_rightBottomCorner;
}

/**
 *  边角线的宽度
 */
@property (nonatomic) CGFloat lineWidth;

/**
 *  边角线的长度
 */
@property (nonatomic) CGFloat cornerLength;

@property (strong, nonatomic) UIColor *cornerColor;

@end

@implementation IDCardCornerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGPoint originPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    
    [[UIColor whiteColor] set];
    
    //重绘左上角
    [_lefTopCorner removeAllPoints];
    _lefTopCorner = nil;
    _lefTopCorner = [self newPath];
    [_lefTopCorner moveToPoint:originPoint];
    [_lefTopCorner addLineToPoint:CGPointMake(originPoint.x, originPoint.y+self.cornerLength)];
    [_lefTopCorner moveToPoint:originPoint];
    [_lefTopCorner addLineToPoint:CGPointMake(originPoint.x+self.cornerLength, originPoint.y)];
    [_lefTopCorner stroke];
    
    originPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
    //重绘右上角
    [_rightTopCorner removeAllPoints];
    _rightTopCorner = nil;
    _rightTopCorner = [self newPath];
    [_rightTopCorner moveToPoint:originPoint];
    [_rightTopCorner addLineToPoint:CGPointMake(originPoint.x-self.cornerLength, originPoint.y)];
    [_rightTopCorner moveToPoint:originPoint];
    [_rightTopCorner addLineToPoint:CGPointMake(originPoint.x, originPoint.y+self.cornerLength)];
    [_rightTopCorner stroke];
    
    originPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    //重绘左下角
    [_leftBottomCorner removeAllPoints];
    _leftBottomCorner = nil;
    _leftBottomCorner = [self newPath];
    [_leftBottomCorner moveToPoint:originPoint];
    [_leftBottomCorner addLineToPoint:CGPointMake(originPoint.x, originPoint.y-self.cornerLength)];
    [_leftBottomCorner moveToPoint:originPoint];
    [_leftBottomCorner addLineToPoint:CGPointMake(originPoint.x+self.cornerLength, originPoint.y)];
    [_leftBottomCorner stroke];
    
    
    originPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    //重绘右下角
    [_rightBottomCorner removeAllPoints];
    _rightBottomCorner = nil;
    _rightBottomCorner = [self newPath];
    [_rightBottomCorner moveToPoint:originPoint];
    [_rightBottomCorner addLineToPoint:CGPointMake(originPoint.x-self.cornerLength, originPoint.y)];
    [_rightBottomCorner moveToPoint:originPoint];
    [_rightBottomCorner addLineToPoint:CGPointMake(originPoint.x, originPoint.y-self.cornerLength)];
    [_rightBottomCorner stroke];
    
}

#pragma mark - Setter && Getter

- (CGFloat)lineWidth {
    if (_lineWidth < 1) {
        _lineWidth = CGRectGetWidth(self.bounds)/50;
    }
    
    return _lineWidth;
}

- (CGFloat)cornerLength {
    if (_cornerLength < 5) {
        _cornerLength = CGRectGetWidth(self.bounds)/15;
    }
    return _cornerLength;
}

#pragma mark - Private

- (UIBezierPath *)newPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = self.lineWidth;
    
    return path;
}

@end

// iPhone5/5c/5s/SE 4英寸 屏幕宽高：320*568点 屏幕模式：2x 分辨率：1136*640像素
#define iPhone5or5cor5sorSE ([UIScreen mainScreen].bounds.size.height == 568.0)

// iPhone6/6s/7 4.7英寸 屏幕宽高：375*667点 屏幕模式：2x 分辨率：1334*750像素
#define iPhone6or6sor7 ([UIScreen mainScreen].bounds.size.height == 667.0)

// iPhone6 Plus/6s Plus/7 Plus 5.5英寸 屏幕宽高：414*736点 屏幕模式：3x 分辨率：1920*1080像素
#define iPhone6Plusor6sPlusor7Plus ([UIScreen mainScreen].bounds.size.height == 736.0)

@interface LHSIDCardScaningView () {
    CAShapeLayer *_IDCardScanningWindowLayer;
    NSTimer *_timer;
    CGRect myRect;
}
@property (nonatomic, assign) IDCardType type;
@property (nonatomic, strong) IDCardCornerView *cornerView;
@property (nonatomic, strong) UIImageView *scanningLineImageView;

@end

@implementation LHSIDCardScaningView

- (instancetype)initWithFrame:(CGRect)frame withType:(IDCardType)type
{
    if (self = [super initWithFrame:frame]) {
        
        _type = type;
        
        self.backgroundColor = [UIColor clearColor];
        
        // 添加扫描窗口
        [self addScaningWindow];
        
        // 添加定时器
        [self addTimer];
    }
    
    return self;
}

#pragma mark - 添加扫描窗口
- (void)addScaningWindow {
    // 中间包裹线
    _IDCardScanningWindowLayer = [CAShapeLayer layer];
    _IDCardScanningWindowLayer.position = self.layer.position;
    CGFloat width = iPhone5or5cor5sorSE ? 240 : (iPhone6or6sor7 ? 270 : 300);
    _IDCardScanningWindowLayer.bounds = (CGRect){CGPointZero, {width, width * 1.574}};
    [self.layer addSublayer:_IDCardScanningWindowLayer];
    
    //最里层镂空
    UIBezierPath *transparentRoundedRectPath = [UIBezierPath bezierPathWithRoundedRect:_IDCardScanningWindowLayer.frame cornerRadius:_IDCardScanningWindowLayer.cornerRadius];
    
    // 最外层背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.frame];
    [path appendPath:transparentRoundedRectPath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.6;
    [self.layer addSublayer:fillLayer];
    
    myRect = _IDCardScanningWindowLayer.frame;
    //人像
    UIImageView *headIV = [[UIImageView alloc] init];
    headIV.contentMode = UIViewContentModeScaleAspectFill;
    if (_type == IDCardTypePositive) {
        CGFloat facePathWidth = iPhone5or5cor5sorSE ? 125: (iPhone6or6sor7? 150: 180);
        CGFloat facePathHeight = facePathWidth * 0.812;
        self.facePathRect = (CGRect){CGRectGetMaxX(myRect) - facePathWidth - 35, CGRectGetMaxY(myRect) - facePathHeight - 25,facePathWidth,facePathHeight};
        headIV.frame = _facePathRect;
        headIV.image = [UIImage imageNamed:@"idcard_first_head"];
        headIV.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    } else if (_type == IDCardTypeReverse) {
        CGFloat facePathHeight = iPhone5or5cor5sorSE ? 65: (iPhone6or6sor7 ? 90 : 120);
        CGFloat facePathWidth = facePathHeight * 1.04;
        self.facePathRect = (CGRect){CGRectGetMaxX(myRect) - facePathWidth - 24, CGRectGetMinY(myRect)+24, facePathWidth, facePathHeight};
        headIV.frame = _facePathRect;
        headIV.image = [UIImage imageNamed:@"idcard_second_emblem"];
    } else {
        CGFloat facePathWidth = iPhone5or5cor5sorSE ? 125: (iPhone6or6sor7? 150: 180);
        CGFloat facePathHeight = facePathWidth * 0.812;
        self.facePathRect = (CGRect){CGRectGetMaxX(myRect) - facePathWidth - 35, CGRectGetMaxY(myRect) - facePathHeight - 25,facePathWidth,facePathHeight};
        headIV.frame = _facePathRect;
    }
    [self addSubview:headIV];
    
    // 提示标签
    CGPoint center = self.center;
    center.x = CGRectGetMinX(_IDCardScanningWindowLayer.frame) - 20;
    [self addTipLabelWithCenter:center];
    
    _cornerView = [[IDCardCornerView alloc] initWithFrame:myRect];
    [self addSubview:_cornerView];
    
    _scanningLineImageView = [[UIImageView alloc] init];
    _scanningLineImageView.image = [UIImage imageNamed:@"idcard_scan_line"];
    _scanningLineImageView.clipsToBounds = YES;
    [self addSubview:_scanningLineImageView];
    
    CGRect frame = myRect;
    frame.size.width = 2;
    frame.size.height = CGRectGetHeight(myRect)-6;
    frame.origin.x = CGRectGetMaxX(myRect);
    frame.origin.y = CGRectGetMinY(myRect)+3;
    self.scanningLineImageView.frame = frame;
}

#pragma mark - 添加提示标签
- (void)addTipLabelWithCenter:(CGPoint)center {
    UILabel *tipLabel = [[UILabel alloc] init];
    if (_type == IDCardTypePositive) {
        tipLabel.text = [CommenUtil LocalizedString:@"Authen.ScanFaceMsg"];
    }  else if (_type == IDCardTypeReverse) {
        tipLabel.text = [CommenUtil LocalizedString:@"Authen.ScanEmblemMsg"];
    } else {
        tipLabel.text = [CommenUtil LocalizedString:@"Authen.ScanBankMsg"];
    }
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    tipLabel.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    [tipLabel sizeToFit];
    
    tipLabel.center = center;
    [self addSubview:tipLabel];
}

#pragma mark - 添加定时器
- (void)addTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(moveScanningLine) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [_timer fire];
    }
}

-(void)timerFire:(id)notice {
    [self setNeedsDisplay];
}

- (void)clearTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)dealloc
{
    [self clearTimer];
}

- (void)moveScanningLine {
    CGRect frame = self.scanningLineImageView.frame;
    CGFloat minX = CGRectGetMinX(myRect);
    if (self.scanningLineImageView.frame.origin.x <= minX) {
        frame.origin.x = CGRectGetMaxX(myRect);
        self.scanningLineImageView.frame = frame;
    } else {
        frame.origin.x -= self.offset;
        NSTimeInterval duration = [self timerDuration];
        
        [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            self.scanningLineImageView.frame = frame;
        } completion:nil];
    }
}

- (CGFloat)timerDuration {
    return 0.025;
}

- (CGFloat)offset {
    return 2.5;
}

- (void)drawRect:(CGRect)rect {
    rect = _IDCardScanningWindowLayer.frame;
    
//    // 水平扫描线
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    static CGFloat moveX = 0;
//    static CGFloat distanceX = 0;
//    
//    CGContextBeginPath(context);
//    CGContextSetLineWidth(context, 2);
//    CGContextSetRGBStrokeColor(context,0.3,0.8,0.3,0.8);
//    CGPoint p1, p2;// p1, p2 连成水平扫描线;
//    
//    moveX += distanceX;
//    if (moveX >= CGRectGetWidth(rect) - 2) {
//        distanceX = -2;
//    } else if (moveX <= 2){
//        distanceX = 2;
//    }
//    
//    p1 = CGPointMake(CGRectGetMaxX(rect) - moveX, rect.origin.y);
//    p2 = CGPointMake(CGRectGetMaxX(rect) - moveX, rect.origin.y + rect.size.height);
//    
//    CGContextMoveToPoint(context,p1.x, p1.y);
//    CGContextAddLineToPoint(context, p2.x, p2.y);
//    
//    CGContextStrokePath(context);
}

@end
