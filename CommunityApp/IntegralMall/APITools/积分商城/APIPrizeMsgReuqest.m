//
//  APIPrizeMsgReuqest.m
//  CommunityApp
//
//  Created by yuntai on 16/6/3.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIPrizeMsgReuqest.h"

@implementation APIPrizeMsgReuqest
- (ApiAccessType)accessType
{
    return kApiAccessPost;
}
- (NSString *)serviceUrl {
    return SERVER_HOST_PRODUCT;
}
- (NSString *)urlAction {
    return JFGetPrizeMsgAction;
}
-(void)setApiParamsWithLog_id:(NSString *)log_id{
    JFPub_type
    User_userId_uId
    [self.params setObject:log_id forKey:@"log_id"];
}

@end
