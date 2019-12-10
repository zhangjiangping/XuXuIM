//
//  VETVoipConfig.h
//  MobileVoip
//
//  Created by Liu Yang on 28/04/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VETVoipConfig : NSObject

//@property (nonatomic, retain) NSString *serverAddress;
//@property (nonatomic, retain) NSString *port; // Default is nil.
//@property (nonatomic, retain) NSString *ringbackFileName;

@property (nonatomic, assign, getter = isEnableEncrypt) BOOL enableEncrypt;

// Default: 3.
@property (nonatomic, assign) NSUInteger logLevel;
// Default: 0.
@property (nonatomic, assign) NSUInteger consoleLogLevel;

@property (nonatomic, retain) NSString *logFileName;

//  default is bundleName and bundleShortVersion
@property (nonatomic, retain) NSString *userAgentString;

// Network port to use for SIP transport. Set 0 for any available port.
// Default: 0.
@property (nonatomic, assign) NSUInteger transportPort;

// Used for scaling volumes up and down (default 2.0)
@property (nonatomic, assign) CGFloat volumeScale;

// TODO:待确定transport，encrypt方式后，添加init方法。
//- (instancetype)initWith;

@end
