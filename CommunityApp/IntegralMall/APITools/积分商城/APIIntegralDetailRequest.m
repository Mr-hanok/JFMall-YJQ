
//
//  APIIntegralDetailRequest.m
//  CommunityApp
//
//  Created by yuntai on 16/5/17.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIIntegralDetailRequest.h"

@implementation APIIntegralDetailRequest
- (ApiAccessType)accessType
{
    return kApiAccessPost;
}
- (NSString *)serviceUrl {
    return SERVER_HOST_PRODUCT;
}
- (NSString *)urlAction {
    return JFIntegralDetailAction;
}
- (void)setApiParamsWithType:(IntegralDetailType)type{
    JFPub_type
    User_userId_uId
    [self.params setObject:[NSString stringWithFormat:@"%ld",self.requestCurrentPage] forKey:@"curp"];
    [self.params setObject:[NSString stringWithFormat:@"%ld",type] forKey:@"type"];
}

@end
