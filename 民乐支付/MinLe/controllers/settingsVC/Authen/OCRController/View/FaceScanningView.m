//
//  HYScanningView.m
//  QRCodeTest
//
//  Created by yanghaha on 15/12/8.
//  Copyright © 2015年 yanghaha. All rights reserved.
//

#import "FaceScanningView.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Extend.h"

@interface FaceScanningView () <AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic, strong) AVCaptureSession *captureSession; //图像捕获会话
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;  //预览捕获的图像图层
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) CAShapeLayer *coverLayer;//透明覆盖图层
@property (nonatomic, strong) NSTimer *timer; //定时器
@property (nonatomic, strong) NSNumber *ouputSetting;
@property (nonatomic, strong) dispatch_queue_t queue;// 队列

@property (nonatomic, strong) UILabel *messageLable; //提示文字

@end

@implementation FaceScanningView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _autoRead = YES;
        _reading = NO;
        [self setupUI];
    }
    return self;
}

#pragma mark - Setter & Getter

- (AVCaptureSession *)captureSession
{
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        NSError *error;
        AVCaptureDevice *captureDevice = [self frontCamera];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        if (!input) {
            NSLog(@"input初始化失败%@", [error localizedDescription]);
        } else {
            [_captureSession addInput:input];
        }
        
        if ([_captureSession canAddOutput:self.videoDataOutput]) {
            [_captureSession addOutput:self.videoDataOutput];
        }
        
        if ([_captureSession canAddOutput:self.output]) {
            [_captureSession addOutput:self.output];
            //输出格式要放在addOutPut之后，否则奔溃
            _output.metadataObjectTypes = @[AVMetadataObjectTypeFace];
        }
    }
    return _captureSession;
}

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer
{
    if (!_videoPreviewLayer) {
        _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _videoPreviewLayer;
}

- (AVCaptureMetadataOutput *)output
{
    if (!_output) {
        _output = [[AVCaptureMetadataOutput alloc] init];
         [_output setMetadataObjectsDelegate:self queue:self.queue];
    }
    return _output;
}

#pragma mark videoDataOutput

- (NSNumber *)ouputSetting
{
    if (!_ouputSetting) {
        _ouputSetting = @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange);
    }
    return _ouputSetting;
}

#pragma mark queue
- (dispatch_queue_t)queue {
    if (_queue == nil) {
        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return _queue;
}

- (AVCaptureVideoDataOutput *)videoDataOutput
{
    if (_videoDataOutput == nil) {
        _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        _videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
        _videoDataOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey:self.ouputSetting};
        [_videoDataOutput setSampleBufferDelegate:self queue:self.queue];
    }
    return _videoDataOutput;
}

- (CAShapeLayer *)coverLayer
{
    if (!_coverLayer) {
        _coverLayer = [CAShapeLayer layer];
        _coverLayer.fillRule = kCAFillRuleEvenOdd;
        _coverLayer.opacity = 0.5;
    }
    
    return _coverLayer;
}

- (NSTimer *)timer
{
    if (!_timer) {
        NSTimeInterval duration = [self timerDuration];
        _timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(moveScanningLine) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (UIColor *)coverColor
{
    if (!_coverColor) {
        _coverColor = [[UIColor grayColor] colorWithAlphaComponent:.5];
    }
    return _coverColor;
}

- (CGRect)boxFrame
{
    if (CGRectIsEmpty(_boxFrame)) {
        _boxFrame = self.bounds;
    }
    return _boxFrame;
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
    [self addSubview:self.messageLable];
    
    [self updateUI];
}

- (void)updateUI
{
    self.videoPreviewLayer.frame = self.bounds;
    self.coverLayer.frame = self.bounds;
    self.coverLayer.fillColor = self.coverColor.CGColor;
    self.messageLable.frame = CGRectMake(self.boxFrame.origin.x, self.boxFrame.origin.y, self.boxFrame.size.width, 45);
}

- (void)moveScanningLine
{
//    CGRect frame = self.scanningLineImageView.frame;
//    CGFloat maxY = CGRectGetMaxY(self.boxFrame);
//    if (self.scanningLineImageView.frame.origin.y >= maxY-10) {
//        frame.origin.y = CGRectGetMinY(self.boxFrame)+10;
//        self.scanningLineImageView.frame = frame;
//    } else {
//        frame.origin.y += self.offset;
//        NSTimeInterval duration = [self timerDuration];
//        
//        [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
//            self.scanningLineImageView.frame = frame;
//        } completion:nil];
//    }
}

- (CGFloat)timerDuration {
    return 0.025;
}

- (CGFloat)offset {
    return 2.5;
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

- (void)stopScanning
{
    if (self.reading) {
        self.reading = NO;
        [self.captureSession stopRunning];
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)startRunning
{
    if (![self.captureSession isRunning]) {
        [self.captureSession startRunning];
    }
}

- (void)stopRunning
{
    if ([self.captureSession isRunning]) {
        [self.captureSession stopRunning];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects && metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        
        AVMetadataObject *transformedMetadataObject = [self.videoPreviewLayer transformedMetadataObjectForMetadataObject:metadataObject];
        CGRect faceRegion = transformedMetadataObject.bounds;
        
        if (metadataObject.type == AVMetadataObjectTypeFace) {
            //只有当人脸区域的确在小框内时，才再去做捕获此时的这一帧图像
            if (CGRectContainsRect(self.boxFrame, faceRegion)) {
                self.messageLable.text = [CommenUtil LocalizedString:@"Authen.AWink"];
                // 为videoDataOutput设置代理，程序就会自动调用下面的代理方法，捕获每一帧图像
                if (!self.videoDataOutput.sampleBufferDelegate) {
                    [self.videoDataOutput setSampleBufferDelegate:self queue:self.queue];
                }
            } else {
                self.messageLable.text = [CommenUtil LocalizedString:@"Authen.ClearALittle"];
            }
        } else {
            self.messageLable.text = [CommenUtil LocalizedString:@"Authen.NotCheckFace"];
        }
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
#pragma mark 从输出的数据流捕捉单一的图像帧
// AVCaptureVideoDataOutput获取实时图像，这个代理方法的回调频率很快，几乎与手机屏幕的刷新频率一样快
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if ([self.ouputSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]] || [self.ouputSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]]) {
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        
        if ([captureOutput isEqual:self.videoDataOutput]) {
            
            UIImage *faceImage = [UIImage getImageStream:imageBuffer];
            
            if ([self faceDetectWithImage:faceImage]) {
                
                //完毕后，就将videoDataOutput的代理去掉，防止频繁调用
                if (self.videoDataOutput.sampleBufferDelegate) {
                    [self.videoDataOutput setSampleBufferDelegate:nil queue:self.queue];
                }
                //发送给控制器代理
                if ([self.delegate respondsToSelector:@selector(scanningView:didFinishScanCode:)]) {
                    [self.delegate scanningView:self didFinishScanCode:@""];
                }
            } else {
                self.messageLable.text = [CommenUtil LocalizedString:@"Authen.ClearALittle"];
            }
        }
    } else {
        NSLog(@"输出格式不支持");
    }
}

#pragma mark - 识别人脸位置，以及眨眼动作
- (BOOL)faceDetectWithImage:(UIImage *)image
{
    // 图像识别能力：可以在CIDetectorAccuracyHigh(较强的处理能力)与CIDetectorAccuracyLow(较弱的处理能力)中选择
    NSDictionary *opts = [NSDictionary dictionaryWithObject:
                          CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    // 将图像转换为CIImage
    CIImage *faceImage = [CIImage imageWithCGImage:image.CGImage];
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:opts];
    // 识别出人脸数组
    NSArray *features = [faceDetector featuresInImage:faceImage];
    // 得到图片的尺寸
    CGSize inputImageSize = [faceImage extent].size;
    //将image沿y轴对称
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, -1);
    //将图片上移
    transform = CGAffineTransformTranslate(transform, 0, -inputImageSize.height);
    
    BOOL isEye = NO;
    // 取出所有人脸
    for (CIFaceFeature *faceFeature in features){
        //获取人脸的frame
        CGRect faceViewBounds = CGRectApplyAffineTransform(faceFeature.bounds, transform);
        CGSize viewSize = self.boxFrame.size;
        CGFloat scale = MIN(viewSize.width / inputImageSize.width,
                            viewSize.height / inputImageSize.height);
        CGFloat offsetX = (viewSize.width - inputImageSize.width * scale) / 2;
        CGFloat offsetY = (viewSize.height - inputImageSize.height * scale) / 2;
        // 缩放
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
        // 修正
        faceViewBounds = CGRectApplyAffineTransform(faceViewBounds,scaleTransform);
        faceViewBounds.origin.x += offsetX;
        faceViewBounds.origin.y += offsetY;
        
        // 判断是否有左眼和右眼位置
        if (faceFeature.hasLeftEyePosition && faceFeature.hasRightEyePosition) {
            isEye = YES;
        }
    }
    return isEye;
}

//这是获取前后摄像头对象的方法
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}


- (AVCaptureDevice *)frontCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}


- (AVCaptureDevice *)backCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

@end
