//
//  SXCommon.m
//  Forum
//
//  Created by SunX on 14-5-7.
//  Copyright (c) 2014年 SunX. All rights reserved.
//

#import "AppCommon.h"
//#import "Reachability.h"
#import <sys/sysctl.h>
#import <Security/Security.h>

@implementation AppCommon

+ (void)pushViewController:(UIViewController*)vc animate:(BOOL)animate {
    [(UINavigationController*)[[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController] pushViewController:vc animated:animate];
}

+ (void)presentViewController:(UIViewController*)vc animated:(BOOL)animated {
    [(UINavigationController*)[[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController]
     presentViewController:vc
     animated:animated
                                                                               completion:nil];
}

+ (void)pushWithVCClass:(Class)vcClass properties:(NSDictionary*)properties {
    id obj = [vcClass new];
    
    if(comToDictionary(properties)) [obj yy_modelSetWithDictionary:properties];
    [AppCommon pushViewController:obj animate:YES];
}

+ (void)pushWithVCClassName:(NSString*)className properties:(NSDictionary*)properties {
    id obj = [NSClassFromString(className) new];
    if(comToDictionary(properties)) [obj yy_modelSetWithDictionary:properties];
    [AppCommon pushViewController:obj animate:YES];
}

//+ (BOOL)hasNetwork
//{
//    return [Reachability reachabilityForInternetConnection].currentReachabilityStatus != NotReachable;
//}
//
//+ (NSString*)netWorkName {
//    NetworkStatus status = [Reachability reachabilityForInternetConnection].currentReachabilityStatus;
//    if (status == ReachableViaWiFi) {
//        return @"wifi";
//    }
//    return @"2g/3g";
//}
//
//+ (BOOL)isWifi {
//    NetworkStatus status = [Reachability reachabilityForInternetConnection].currentReachabilityStatus;
//    if (status == ReachableViaWiFi) {
//        return YES;
//    }
//    return NO;
//}
//
//+ (BOOL)removeDir:(NSString*)path
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    return [fileManager removeItemAtPath:path error:nil];
//}
//
//+ (BOOL)mkdir:(NSString*)path
//{
//    BOOL isDir = NO;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
//    if ( !(isDir == YES && existed == YES) )
//    {
//        return [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    return NO;
//}
//
//+ (NSString *)device{
//	size_t size;
//	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
//	char *machine = malloc(size);
//	sysctlbyname("hw.machine", machine, &size, NULL, 0);
//	NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
//	free(machine);
//	return platform;
//}
//
//+ (NSString *)bundleID{
//    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
//}
//
//+ (NSString*)appVersion{
//    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//}
//
//+ (NSString*)buildVersion
//{
//    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
//}
//
//+ (NSString*)writeImageTofile:(UIImage*)image
//                     filePath:(NSString*)filePath
//           compressionQuality:(CGFloat)compressionQuality
//{
//    if (image == nil)
//        return nil;
//    @try
//    {
//        NSData *imageData = nil;
//        NSString *ext = [filePath pathExtension];
//        if ([ext isEqualToString:@"png"])
//            imageData = UIImagePNGRepresentation(image);
//        else
//        {
//            imageData = UIImageJPEGRepresentation(image, compressionQuality);
//        }
//        if ((imageData == nil) || ([imageData length] <= 0))
//            return nil;
//        
//        [imageData writeToFile:filePath atomically:YES];
//        return filePath;
//    }
//    @catch (NSException *e)
//    {
//        NSLog(@"创建分享的临时图片错误：%@",e);
//    }
//    return nil;
//}
//
//
//+ (long long)getMicroTime
//{
//    struct timeval tvStart;
//    gettimeofday (&tvStart,NULL);
//    long long tStart = (long long)1000000*tvStart.tv_sec+tvStart.tv_usec;
//    return tStart;
//}
//
//+ (TDDManagerEnvironment)currentEnvironment {
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"mtop_environment"]) {
//        return [[[NSUserDefaults standardUserDefaults] objectForKey:@"mtop_environment"] intValue];
//    }
//#if defined  MTOP_DAILY
//    return TDDManagerEnvironmentDaily;
//#elif defined MTOP_PRERELEASE
//    return TDDManagerEnvironmentPreRelease;
//#else
//    return TDDManagerEnvironmentRelease;
//#endif
//}
//
//+ (void)saveEnvironment:(TDDManagerEnvironment)environment {
//    [[NSUserDefaults standardUserDefaults] setObject:@(environment) forKey:@"mtop_environment"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+ (void)setDeviceToken:(NSString *)deviceToken {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:deviceToken forKey:@"tddmanager_device_token"];
//    [defaults synchronize];
//}
//
//+ (NSString *)deviceToken {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *token = [defaults stringForKey:@"tddmanager_device_token"];
//    return token ?: nil;
//}
//
//+ (void)setDeviceTokenData:(NSData *)deviceToken {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:deviceToken forKey:@"tddmanager_device_token_data"];
//    [defaults synchronize];
//}
//
//+ (NSData *)deviceTokenData {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSData *token = [defaults objectForKey:@"tddmanager_device_token_data"];
//    return token ?: nil;
//}
//
//+ (BOOL)isJailbroken {
//    static int jailbroken = -1;
//    
//    static NSString* cydiaPath = @"/Applications/Cydia.app";
//    static NSString* aptPath = @"/private/var/lib/apt/";
//    
//    if (-1 == jailbroken)
//    {
//        if([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]
//           || [[NSFileManager defaultManager] fileExistsAtPath:aptPath])
//        {
//            jailbroken = 1;
//        }
//        else
//        {
//            jailbroken = 0;
//        }
//    }
//    
//    return (1 == jailbroken) ? YES : NO;
//}
//
//
//+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size {
//    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return theImage;
//}

@end

