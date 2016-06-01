//
//  APIGoodsDetailRequest.m
//  CommunityApp
//
//  Created by yuntai on 16/5/10.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIGoodsDetailRequest.h"

@implementation APIGoodsDetailRequest
- (ApiAccessType)accessType
{
    return kApiAccessPost;
}
- (NSString *)serviceUrl {
    return SERVER_HOST_PRODUCT;
}
- (NSString *)urlAction {
    return JFGoodsDetailAction;
}
- (void)setApiParamsWithGoodsId:(NSString *)goodid{
    JFPub_type
    User_userId_uId
    [self.params setObject:goodid forKey:@"id"];
}

@end
