//
//  JFCommon.h
//  CommunityApp
//
//  Created by yuntai on 16/4/14.
//  Copyright © 2016年 iss. All rights reserved.
//

#ifndef JFCommon_h
#define JFCommon_h

#define kWindow  [[UIApplication sharedApplication].windows objectAtIndex:0]
#define User_Integral_Key   @"User_Integral_Key"


/**获取用户id*/
#define User_userId_uId     LoginConfig *login = [LoginConfig Instance];\
                            NSString *uid = [login userID];\
                            [self.params setObject:uid forKey:@"uid"];
//#define User_userId_uId  [self.params setObject:@"o7dRNwQGqqVz42IuJBqZRTaKnD7E" forKey:@"uid"];

#import "NetworkMacro.h"
#import "ValueUtils.h"
#import "APIClient.h"
#import "HUDManager.h"
#import "ApiLoginRequest.h"
#endif /* JFCommon_h */
