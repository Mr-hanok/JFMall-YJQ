
//
//  APImOrderSubmitRequest.m
//  CommunityApp
//
//  Created by yuntai on 16/5/17.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIOrderSubmitRequest.h"

@implementation APIOrderSubmitRequest
- (ApiAccessType)accessType
{
    return kApiAccessPost;
}
- (NSString *)serviceUrl {
    return SERVER_HOST_PRODUCT;
}
- (NSString *)urlAction {
    return JFOrderSubmitAction;
}
-(void)setApiParamsWithGoodIds:(NSString *)goodIds
                  cart_session:(NSString *)cart_session
                          name:(NSString *)name
                        mobile:(NSString *)mobile
                       address:(NSString *)address
                        log_id:(NSString *)log_id
                    order_flag:(NSString *)order_flag{
    JFPub_type
    User_userId_uId
    [self.params setObject:goodIds forKey:@"goods_ids"];
    [self.params setObject:cart_session forKey:@"cart_session"];
    [self.params setObject:name forKey:@"name"];
    [self.params setObject:mobile forKey:@"mobile"];
    [self.params setObject:address forKey:@"address"];
    
    [self.params setObject:log_id forKey:@"log_id"];
    [self.params setObject:order_flag forKey:@"order_flag"];
}

@end
