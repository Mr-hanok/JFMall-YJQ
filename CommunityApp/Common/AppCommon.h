//
//  SXCommon.h
//  Forum
//
//  Created by SunX on 14-5-7.
//  Copyright (c) 2014年 SunX. All rights reserved.
//

typedef enum {
    TDDManagerEnvironmentDaily,
    TDDManagerEnvironmentPreRelease,
    TDDManagerEnvironmentRelease
} TDDManagerEnvironment;

@interface AppCommon : NSObject
//统一调用此方法来push
+ (void)pushViewController:(UIViewController*)vc animate:(BOOL)animate;
//
+ (void)presentViewController:(UIViewController*)vc animated:(BOOL)animated;
//push
+ (void)pushWithVCClass:(Class)vcClass properties:(NSDictionary*)properties;

+ (void)pushWithVCClassName:(NSString*)className properties:(NSDictionary*)properties;

////是否有网络
//+ (BOOL)hasNetwork;
////返回wifi or 2g/3g
//+ (NSString*)netWorkName;
////是否是wifi
//+ (BOOL)isWifi;
//
////删除文件或文件夹
//+ (BOOL)removeDir:(NSString*)path;
////新增文件夹
//+ (BOOL)mkdir:(NSString*)path;
////当前机器的编码 如 iPad2,1
//+ (NSString *)device;
////当前系统的bundleID plist的CFBundleIdentifier字段 (显示为 Bundle identifier)
//+ (NSString*)bundleID;
////当前系统的的版本号 plist的CFBundleShortVersionString字段（显示为Bundle Version）
//+ (NSString*)appVersion;
////当前系统的的版本号 plist的CFBundleVersion字段（显示为Build Version）
//+ (NSString*)buildVersion;
//
//+ (NSString*)writeImageTofile:(UIImage*)image
//                     filePath:(NSString*)filePath
//           compressionQuality:(CGFloat)compressionQuality;
//
////获取当前时间的microtie
//+ (long long)getMicroTime;
//
////当前API环境
//+ (TDDManagerEnvironment)currentEnvironment;
//
//+ (void)saveEnvironment:(TDDManagerEnvironment)environment;
//
//+ (void)setDeviceToken:(NSString*)deviceToken;
//
//+ (NSString*)deviceToken;
//
//+ (void)setDeviceTokenData:(NSData *)deviceToken;
//
//+ (NSData *)deviceTokenData;
//
//+ (BOOL)isJailbroken;
//
//+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;

@end





