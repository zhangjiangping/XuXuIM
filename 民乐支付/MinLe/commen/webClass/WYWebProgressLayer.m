//
//  WYWebProgressLayer.m
//  FlyChat
//
//  Created by JP on 2017/4/1.
//  Copyright © 2017年 SZVetron. All rights reserved.
//

#import "WYWebProgressLayer.h"
#import "NSTimer+addition.h"

static NSTimeInterval const kFastTimeInterval = 0.003;

@implementation WYWebProgressLayer {
    CAShapeLayer *_layer;
    
    NSTimer *_timer;
    CGFloat _plusWidth; ///< 增加点
}

- (instancetype)initWithLineWidth:(float)lineWidth
{
    if (self = [super init]) {
        _linesWidth = lineWidth;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.lineWidth = _linesWidth;
    self.strokeColor = [UIColor greenColor].CGColor;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:kFastTimeInterval target:self selector:@selector(pathChanged:) userInfo:nil repeats:YES];
    [_timer pause];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, _linesWidth)];
    [path addLineToPoint:CGPointMake(SCREEN_WIDTH, _linesWidth)];
    
    self.path = path.CGPath;
    self.strokeEnd = 0;
    _plusWidth = 0.01;
}

- (void)pathChanged:(NSTimer *)timer {
    self.strokeEnd += _plusWidth;
    
    if (self.strokeEnd > 0.8) {
        _plusWidth = 0.002;
    }
}

- (void)startLoad {
    [_timer resumeWithTimeInterval:kFastTimeInterval];
}

- (void)finishedLoad {
    [self closeTimer];
    
    self.strokeEnd = 1.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        [self removeFromSuperlayer];
    });
}

- (void)dealloc {
    //    NSLog(@"progressView dealloc");
    [self closeTimer];
}

#pragma mark - private
- (void)closeTimer {
    [_timer invalidate];
    _timer = nil;
}

@end

