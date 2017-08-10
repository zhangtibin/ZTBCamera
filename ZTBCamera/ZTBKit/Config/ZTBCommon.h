//
//  ZTBCommon.h
//  ZTBCamera
//
//  Created by Tibin Zhang on 2017/6/1.
//  Copyright © 2017年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#ifndef ZTBCommon_h
#define ZTBCommon_h

#ifdef DEBUG
#define ZTBLog(fmt, ...)  NSLog((@"[line:%d] " "%s "  fmt),__LINE__, __FUNCTION__,  ##__VA_ARGS__);
#else
#define ZTBLog(...)
#endif

#define DECLARE_SINGLETON(cls_name, method_name)\
+ (cls_name*)method_name;

#define IMPLEMENT_SINGLETON(cls_name, method_name)\
+ (cls_name *)method_name {\
static cls_name *method_name;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
method_name = [[cls_name alloc] init];\
});\
return method_name;\
}

#define EMPTY_STRING(string) \
( [string isKindOfClass:[NSNull class]] || \
string == nil || [string isEqualToString:@""])

#define GET_STRING(string) (EMPTY_STRING(string) ? @"" : string)
#define L(s) NSLocalizedString((s), nil)

#define EMPTY_Array(array) \ (array == nil || \
[array isKindOfClass:[NSNull class]] || \
array.count == 0)

#define EMPTY_Dictionary(dic) \
(dic == nil || \
[dic isKindOfClass:[NSNull class]] || \
dic.allKeys == 0)

#define EMPTY_OBJECT(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//使用 ARC 和 MRC
#if __has_feature(objc_arc)
// ARC
#else
// MRC
#endif


#endif /* ZTBCommon_h */
