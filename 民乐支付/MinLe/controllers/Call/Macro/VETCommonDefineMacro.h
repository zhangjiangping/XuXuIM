//
//  VETCommonDefineMacro.h
//  VETEphone
//
//  Created by young on 17/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#ifndef VETCommonDefineMacro_h
#define VETCommonDefineMacro_h

//#define SERVER_ADDRESS_VOS @"103.234.220.234:5070"
//#define SERVER_ADDRESS @"103.234.220.234"
//#define SERVER_ADDRESS @"123.207.7.94"
#define SERVER_ADDRESS @"sip.talk2all.net"
//#define SERVER_ADDRESS @"64:ff9b::103.234.220.234"

//#define SERVER_ADDRESS @"sip.flychat.me"
//#define SERVER_ADDRESS @"sip2.kekecall.net"

#define APP_ID @"1250340821"

// DEFINE APP SETTINGS

#define CURRENCY_NAME @"CNY"
#define CURRENCY_CODE @"¥"

#define SERVER_PREFIX @""
#define SERVER_ENCRYPTION_PORT @"5070"

//#define SERVER_ADDRESS_PANPAN @"panwin.hstsrv.net"

//  收到电话等待接听超时时间
#define WAIT_REWARD_SECONDS 58.0

//1296db
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(1.0)]

//#define MAINTHEMECOLOR RGBCOLOR(74, 144, 226)
//#define MAINTHEMECOLOR RGBCOLOR(0x00, 0xaf, 0xf0)
#define MAINTHEMECOLOR [UIColor colorWithRed:2.0/255.0 green:138.0/255.0 blue:218.0/255.0 alpha:1]
#define GRAYLINECOLOR RGBCOLOR(199, 199, 199)
#define LOGINGRAYBACKGROUNG RGBCOLOR(240, 242, 245)

//状态栏高度
#define STATUS_BAR_HEIGHT 20
//NavBar高度
#define NAVIGATION_BAR_HEIGHT 44
//状态栏 ＋ 导航栏 高度
#define STATUS_AND_NAVIGATION_HEIGHT ((STATUS_BAR_HEIGHT) + (NAVIGATION_BAR_HEIGHT))

//屏幕 rect
#define SCREEN_RECT ([UIScreen mainScreen].bounds)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define CONTENT_HEIGHT (SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT)

#define TABBARHEIGHT 49

//1像素的线
#define PointHeight  1/[[UIScreen mainScreen] scale]

//屏幕分辨率
#define SCREEN_RESOLUTION (SCREEN_WIDTH * SCREEN_HEIGHT * ([UIScreen mainScreen].scale))

#ifdef DEBUG 
#define LYLog(...) NSLog(__VA_ARGS__)
#else
#define LYLog(...)
#endif

#endif /* VETCommonDefineMacro_h */
