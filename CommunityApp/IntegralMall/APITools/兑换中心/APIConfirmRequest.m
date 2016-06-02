
//
//  APIConfirmRequest.m
//  CommunityApp
//
//  Created by yuntai on 16/5/17.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIConfirmRequest.h"

@implementation APIConfirmRequest
- (ApiAccessType)accessType
{
    return kApiAccessPost;
}
- (NSString *)serviceUrl {
    return SERVER_HOST_PRODUCT;
}
- (NSString *)urlAction {
    return JFConfirmationAction;
}
-(void)setApiParamsWithGoodIds:(NSString *)goodIds{
    JFPub_type
    User_userId_uId
    [self.params setObject:goodIds forKey:@"goods_ids"];
}

@end
