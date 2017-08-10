//
//  ZTBDefine.h
//  ZTBCamera
//
//  Created by Tibin Zhang on 2017/5/27.
//  Copyright © 2017年 Xueshan Financial Information Service Co., Ltd. All rights reserved.
//

#ifndef ZTBDefine_h
#define ZTBDefine_h

#define kScreenBounds                     [[UIScreen mainScreen] bounds]
#define kScreenSize                          [[UIScreen mainScreen] bounds].size
#define kScreenWidth                       [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight                      [[UIScreen mainScreen] bounds].size.height

/**
 颜色值
 */
#define RGB(r,g,b)          [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBA(r,g,b,a)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define HSB(h,s,b)          [UIColor colorWithHue:(h)/360.0f saturation:(s)/100.0f brightness:(b)/100.0f alpha:1.0]
#define HSBA(h,s,b,a)    [UIColor colorWithHue:(h)/360.0f saturation:(s)/100.0f brightness:(b)/100.0f alpha:(a)]
#define RandomColor     [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

#define Max(a,b)            ((a) > (b) ? (a) : (b))
#define Min(a,b)            ((a) > (b) ? (b) : (a))

/**
 设备信息
 */
// 设备种类
#define IS_IPHONE           (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)      //判断是否为iPhone
#define IS_IPAD                 (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)      //判断是否为iPad
#define IS_IPOD                 ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])      //判断是否为ipod

// 屏幕尺寸
#define ScreenBounds                     [[UIScreen mainScreen] bounds]
#define ScreenSize                          [[UIScreen mainScreen] bounds].size
#define ScreenWidth                       [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                      [[UIScreen mainScreen] bounds].size.height

// 设备尺寸
#define iPhone4x_3_5                ([UIScreen mainScreen].bounds.size.height == 480.0f)
#define iPhone5x_4_0                ([UIScreen mainScreen].bounds.size.height == 568.0f)
#define iPhone6_6s_4_7             [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f
#define iPhoneXPlus_5_5           [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f

//由角度转换弧度 由弧度转换角度
#define degreesToRadians(x)         (M_PI * (x) / 180.0)
#define radiansToDegrees(x)         (180 * (x) / M_PI)

// 当前语言
#define kCurrentLanguage             ([[NSLocale preferredLanguages] objectAtIndex:0])


// 系统版本
#define IOS_SYSTEM_VERSION     [[[UIDevice currentDevice] systemVersion] floatValue]        //获取系统版本

#define IOS_SYSTEM_VERSION_6x       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f)     //判断 iOS 6 系统版本
#define IOS_SYSTEM_VERSION_7x       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f)     //判断 iOS 7 系统版本
#define IOS_SYSTEM_VERSION_8x       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0f)      //判断 iOS 8 系统版本
#define IOS_SYSTEM_VERSION_9x       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0f)      //判断 iOS 9 系统版本
#define IOS_SYSTEM_VERSION_10x      ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0f) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 11.0f)      //判断 iOS 10 系统版本

#define IOS_VERSION_8_OR_LATER ((IOS_SYSTEM_VERSION >= 8.0)? (YES):(NO))  // iOS 8+
#define IOS_VERSION_10_OR_LATER ((IOS_SYSTEM_VERSION >= 10.0)? (YES):(NO))  // iOS 10+

// 沙盒目录文件
#define kTemporaryDirectory             NSTemporaryDirectory()    //获取temp
#define kDocumentDirectory              [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] //获取沙盒 Document
#define kCachesDirectory                   [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] //获取沙盒 Cache

/**
 系统权限
 */
#define SYSTEM_NOTIFICATION_URL @"prefs:root=NOTIFICATIONS_ID&&path=com.xueshan.app.XSD"


//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

#endif /* ZTBDefine_h */
