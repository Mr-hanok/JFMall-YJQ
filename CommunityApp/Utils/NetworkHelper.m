//
//  AppToast.m
//  CommunityApp
//
//  Created by issuser on 15/6/3.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "NetworkHelper.h"
#import "AFNetworkReachabilityManager.h"

@implementation NetworkHelper

+ (void)startNetMonitoring
{
    // 连接状态回调处理
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         [[LoginConfig Instance] changeNetStatus:[NSNumber numberWithInt:status]];
     }];
    
    // 检测网络连接状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)stopNetMonitoring
{ 
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

@end