//
//  WYWebProgressLayer.h
//  FlyChat
//
//  Created by JP on 2017/4/1.
//  Copyright © 2017年 SZVetron. All rights reserved.
//

@interface WYWebProgressLayer : CAShapeLayer
{
    float _linesWidth;
}

- (instancetype)initWithLineWidth:(float)lineWidth;

- (void)finishedLoad;
- (void)startLoad;

- (void)closeTimer;

@end


