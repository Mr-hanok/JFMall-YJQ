
//
//  APIAceptPrizeRequest.m
//  CommunityApp
//
//  Created by yuntai on 16/6/3.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIAceptPrizeRequest.h"

@implementation APIAceptPrizeRequest
//http://d.bjyijiequ.com/mallyjq/m/acceptPrize.htm
- (ApiAccessType)accessType
{
    return kApiAccessPost;
}
- (NSString *)serviceUrl {
    return SERVER_HOST_PRODUCT;
}
- (NSString *)urlAction {
    return JFAcceptPrizeAction;
}
-(void)setApiParamsWithLog_id:(NSString *)log_id{
    JFPub_type
    User_userId_uId
    [self.params setObject:log_id forKey:@"log_id"];
}

@end
