//
//  APIOrderDelRequest.m
//  CommunityApp
//
//  Created by yuntai on 16/5/20.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIOrderDelRequest.h"

@implementation APIOrderDelRequest
- (ApiAccessType)accessType
{
    return kApiAccessPost;
}
- (NSString *)serviceUrl {
    return SERVER_HOST_PRODUCT;
}
- (NSString *)urlAction {
    return JFOrderDelAction;
}
- (void)setApiParamsWithOrderId:(NSString *)orderid{
    JFPub_type
    User_userId_uId
    [self.params setObject:orderid forKey:@"id"];
}

@end
