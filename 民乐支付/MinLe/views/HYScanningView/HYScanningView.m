//
//  HYScanningView.m
//  QRCodeTest
//
//  Created by yanghaha on 15/12/8.
//  Copyright © 2015年 yanghaha. All rights reserved.
//

#import "HYScanningView.h"
#import <AVFoundation/AVFoundation.h>
#import "PermissionObj.h"

@interface CornerView : UIView {
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

@implementation CornerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGPoint originPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    
    [self.cornerColor set];
    
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

@interface HYScanningView () <AVCaptureMetadataOutputObjectsDelegate> {
    AVCaptureMetadataOutput *_output;
}

@property (nonatomic, strong) UIBezierPath *coverPath;      //
@property (nonatomic, strong) UIBezierPath *boxPath;        //扫描框
@property (nonatomic, strong) UIImageView *scanningLineImageView; //扫描线图片
@property (nonatomic, strong) AVCaptureSession *captureSession; //图像捕获会话
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;  //预览捕获的图像图层
@property (nonatomic, strong) CAShapeLayer *coverLayer;      //透明覆盖图层
@property (nonatomic, strong) NSTimer *timer;   //定时器

@property (nonatomic, strong) CornerView *cornerView;
@property (nonatomic, strong) UILabel *messageLable;  //提示文字

@end

@implementation HYScanningView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _autoRead = YES;
        _reading = NO;
        [self setupUI];
        [self updateOutputRectOfInterest];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _autoRead = YES;
    _reading = NO;
    [self setupUI];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateUI];
    
    if (self.autoRead) {
        [self startScanning];
    }
}

- (void)drawRect:(CGRect)rect {
    [self updateOutputRectOfInterest];
}

- (void)dealloc {
    
}

#pragma mark - Setter & Getter

- (UIImageView *)scanningLineImageView
{
    if (!_scanningLineImageView) {
        _scanningLineImageView = [[UIImageView alloc] init];
        _scanningLineImageView.image = [UIImage imageNamed:@"scan_line"];
        _scanningLineImageView.clipsToBounds = YES;
    }
    return _scanningLineImageView;
}

- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        
        _captureSession = [[AVCaptureSession alloc] init];
        
        NSError *error;
        
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        if (!input) {
            NSLog(@"input初始化失败%@", [error localizedDescription]);
        } else {
            [_captureSession addInput:input];
        }
        
        _output = [[AVCaptureMetadataOutput alloc] init];
        
        [_captureSession addOutput:_output];
        [self updateOutputMetadataObjectTypes];
        dispatch_queue_t dispatchQueue = dispatch_queue_create("ScanningQueue", NULL);
        [_output setMetadataObjectsDelegate:self queue:dispatchQueue];
    }
    
    return _captureSession;
}

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer {
    if (!_videoPreviewLayer) {
        _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    
    return _videoPreviewLayer;
}

- (CAShapeLayer *)coverLayer {
    if (!_coverLayer) {
        _coverLayer = [CAShapeLayer layer];
        _coverLayer.fillRule = kCAFillRuleEvenOdd;
        _coverLayer.opacity = 0.5;
    }
    
    return _coverLayer;
}

- (NSTimer *)timer {
    if (!_timer) {
        NSTimeInterval duration = [self timerDuration];
        _timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(moveScanningLine) userInfo:nil repeats:YES];
    }
    
    return _timer;
}

- (void)setType:(HYScanningViewType)type {
    _type = type;
    
    [self updateOutputMetadataObjectTypes];
}

- (UIColor *)coverColor {
    
    if (!_coverColor) {
        _coverColor = [[UIColor grayColor] colorWithAlphaComponent:.5];
    }
    
    return _coverColor;
}

- (void)setCornerColor:(UIColor *)cornerColor {
    _cornerColor = cornerColor;
    self.cornerView.cornerColor = _cornerColor;
}

- (CGRect)boxFrame {
    if (CGRectIsEmpty(_boxFrame)) {
        _boxFrame = self.bounds;
    }
    return _boxFrame;
}

- (CornerView *)cornerView {
    if (!_cornerView) {
        _cornerView = [[CornerView alloc] init];
    }
    return _cornerView;
}

- (UILabel *)messageLable
{
    if (!_messageLable) {
        _messageLable = [[UILabel alloc] init];
        _messageLable.textAlignment = NSTextAlignmentCenter;
        _messageLable.textColor = [UIColor whiteColor];
        _messageLable.font = FT(15);
        _messageLable.alpha = 0.7;
        _messageLable.numberOfLines = 0;
    }
    return _messageLable;
}

//外部调用
- (void)setBarFrame:(CGRect)barFrame
{
    _boxFrame = barFrame;
    [self updateUI];
}

#pragma mark - Private

- (void)setupUI
{
    [self.layer addSublayer:self.videoPreviewLayer];
    [self.layer addSublayer:self.coverLayer];
    [self addSubview:self.cornerView];
    [self addSubview:self.scanningLineImageView];
    [self addSubview:self.messageLable];
}

- (void)updateUI
{
    self.videoPreviewLayer.frame = self.bounds;
    self.coverLayer.frame = self.bounds;
    self.coverLayer.fillColor = self.coverColor.CGColor;
    
    [self updatePathWithBoxFrame:self.boxFrame];
    self.coverLayer.path = self.coverPath.CGPath;
    
    CGRect frame = self.boxPath.bounds;
    frame.size.height = 2;
    frame.origin.y = self.boxPath.bounds.origin.y+10;
    self.scanningLineImageView.frame = frame;
    
    self.cornerView.frame = self.boxFrame;
    self.messageLable.frame = CGRectMake(self.boxFrame.origin.x, self.boxFrame.origin.y+self.boxFrame.size.height+15, self.boxFrame.size.width, 45);
}

- (void)updateOutputRectOfInterest {
    CGRect rectOfInterest = [self.videoPreviewLayer metadataOutputRectOfInterestForRect:self.boxFrame];
    _output.rectOfInterest = rectOfInterest;
}

- (void)updateOutputMetadataObjectTypes {
    
    if ([[PermissionObj sharedInstance] isCanVideos] == NO) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(camerPermission:)]) {
            [self.delegate camerPermission:NO];
        }
    } else {
        _output.metadataObjectTypes = [self arrayTranslateType];
    }
}

- (void)updatePathWithBoxFrame:(CGRect)frame {
    [self.boxPath removeAllPoints];
    self.boxPath = nil;
    self.boxPath = [UIBezierPath bezierPathWithRect:frame];
    
    [self.coverPath removeAllPoints];
    self.coverPath = nil;
    self.coverPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.coverPath.usesEvenOddFillRule = YES;
    [self.coverPath appendPath:self.boxPath];
}

- (void)moveScanningLine {
    CGRect frame = self.scanningLineImageView.frame;
    CGFloat maxY = CGRectGetMaxY(self.boxFrame);
    if (self.scanningLineImageView.frame.origin.y >= maxY-10) {
        frame.origin.y = CGRectGetMinY(self.boxFrame)+10;
        self.scanningLineImageView.frame = frame;
    } else {
        frame.origin.y += self.offset;
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

- (NSArray *)arrayTranslateType {
    if (self.type == HYScanningViewTypeQR) {
        _messageLable.text = [CommenUtil LocalizedString:@"Collection.QRCodeAutomaticallyScan"];
        return @[AVMetadataObjectTypeQRCode];
    } else if (self.type == HYScanningViewTypeBar) {
        _messageLable.text = [CommenUtil LocalizedString:@"Collection.BarcodeAutomaticallyScan"];
        return @[AVMetadataObjectTypeEAN13Code,
                 AVMetadataObjectTypeEAN8Code,
                 AVMetadataObjectTypeCode128Code];
    } else if (self.type == HYScanningViewTypeQRBar) {
        _messageLable.text = [CommenUtil LocalizedString:@"Collection.QRCodeAndBarcodeAutomaticallyScan"];
        return @[AVMetadataObjectTypeEAN13Code,
                 AVMetadataObjectTypeEAN8Code,
                 AVMetadataObjectTypeCode128Code,
                 AVMetadataObjectTypeQRCode];
    }
    
    return @[AVMetadataObjectTypeQRCode];
}

//解决AVCaptureVideoPreviewLayer调用metadataOutputRectOfInterestForRect获取RectOfInterest为零的bug
- (void)fixRectOfInterestZero {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGRect rectOfInterest = CGRectZero;
        while (CGRectIsEmpty(rectOfInterest)) {
            rectOfInterest = [self.videoPreviewLayer metadataOutputRectOfInterestForRect:self.boxFrame];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _output.rectOfInterest = rectOfInterest;
            if (self.autoRead) {
                [self startScanning];
            }
        });
    });
}

#pragma mark - Message

- (void)startScanning {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied ||
        status == AVAuthorizationStatusRestricted) {
        NSLog(@"请检测相机权限");
        return;
    }
    
    if (!self.isReading) {
        self.reading = YES;
        [self.captureSession startRunning];
        self.timer.fireDate = [NSDate date];
    }
}

- (void)stopScanning {
    if (self.reading) {
        self.reading = NO;
        [self.captureSession stopRunning];
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects && metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = metadataObjects[0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopScanning];
            if ([self.delegate respondsToSelector:@selector(scanningView:didFinishScanCode:)]) {
                [self.delegate scanningView:self didFinishScanCode:metadataObj.stringValue];
            }
        });
    }
}

@end
