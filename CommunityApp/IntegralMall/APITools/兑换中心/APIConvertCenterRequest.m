//
//  APIConvertCenterRequest.m
//  CommunityApp
//
//  Created by yuntai on 16/5/12.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIConvertCenterRequest.h"

@implementation APIConvertCenterRequest
- (instancetype)init
{
    self = [super init];
    if (self) {
        JFPub_type
        User_userId_uId
    }
    return self;
}

- (ApiAccessType)accessType
{
    return kApiAccessPost;
}
- (NSString *)serviceUrl {
    return SERVER_HOST_PRODUCT;
}
- (NSString *)urlAction {
    return JFConvertCenterAction;
}

@end
