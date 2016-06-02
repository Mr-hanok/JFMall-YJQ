//
//  APIPrizeListRequest.m
//  CommunityApp
//
//  Created by yuntai on 16/6/2.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIPrizeListRequest.h"

@implementation APIPrizeListRequest
- (ApiAccessType)accessType
{
    return kApiAccessPost;
}
- (NSString *)serviceUrl {
    return SERVER_HOST_PRODUCT;
}
- (NSString *)urlAction {
    return JFPrizeListAction;
}
-(void)setApiParamsWithActivity_type:(NSString *)activity_type{
    JFPub_type
    User_userId_uId
    [self.params setObject:activity_type forKey:@"activity_type"];
}

@end
