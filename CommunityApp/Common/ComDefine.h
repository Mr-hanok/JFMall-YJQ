//
//  ComDefine.h
//  CommonApp
//
//  Created by SunX on 15/7/15.
//  Copyright (c) 2015年 SunX. All rights reserved.
//

/**
 *  一些公共属性define
 */

//----------------------------------- 网络环境设置 ------------------------------------
//默认是正式环境  上线必需注释这两项  优先选择DEBUG的环境

// 设置测试环境
#define APP_DAILY

// 设置预发环境
//#define APP_PRERELEASE


//----------------------------------- 是否会打印log ------------------------------------
#if defined APP_DAILY

#define APP_DEBUG

#elif defined APP_PRERELEASE

#define APP_DEBUG

#else

#endif


#ifdef APP_DEBUG
#define NSLog(...)  NSLog(__VA_ARGS__)
#define DLog(fmt, ...)  NSLog((@"[File:%@][Line: %d]%s " fmt),[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#define NSLog(...)
#define DLog(...)
#endif


//----------------------------------- arc ------------------------------------


