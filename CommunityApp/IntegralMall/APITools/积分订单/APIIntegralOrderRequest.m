//
//  APIIntrgralOrderRequest.m
//  CommunityApp
//
//  Created by yuntai on 16/5/19.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIIntegralOrderRequest.h"

@implementation APIIntegralOrderRequest
- (ApiAccessType)accessType
{
    return kApiAccessPost;
}
- (NSString *)serviceUrl {
    return SERVER_HOST_PRODUCT;
}
- (NSString *)urlAction {
    return JFOrderListAction;
}
- (void)setApiParamsWithType:(NSString *)type{
    JFPub_type
    User_userId_uId
//    [self.params setObject:@"o7dRNwQGqqVz42IuJBqZRTaKnD7E" forKey:@"uid"];
    [self.params setObject:[NSString stringWithFormat:@"%ld",self.requestCurrentPage] forKey:@"curp"];
    [self.params setObject:type forKey:@"type"];
}

@end
