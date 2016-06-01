//
//  APIClient.h
//  yilingdoctorCRM
//
//  Created by zhangxi on 14/10/27.
//  Copyright (c) 2014年 yuntai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIRequest.h"

@interface APIClient : NSObject

#pragma mark Signal Mode

+ (APIClient *)sharedInstance;

+ (void)execute:(APIRequest *)api;

@end
