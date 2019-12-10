//
//  VETDialpadButton.h
//  VETEphone
//
//  Created by young on 17/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VETDialpadButton : UIButton

@property (nonatomic, copy) NSString *subText;
@property (nonatomic, assign) CGFloat subTextOffset;   //  default 10.0

@end
