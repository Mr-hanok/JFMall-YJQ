//
//  APITaskCenterRequest.m
//  CommunityApp
//
//  Created by yuntai on 16/5/19.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APITaskCenterRequest.h"

@implementation APITaskCenterRequest


- (ApiAccessType)accessType
{
    return kApiAccessPost;
}
- (NSString *)serviceUrl {
    return SERVER_HOST_PRODUCT;
}
- (NSString *)urlAction {
    return JFTaskCenterAction;
}


@end
