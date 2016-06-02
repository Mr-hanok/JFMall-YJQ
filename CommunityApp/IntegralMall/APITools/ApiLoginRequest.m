//
//  ApiLoginRequest.m
//  CommunityApp
//
//  Created by yuntai on 16/5/9.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "ApiLoginRequest.h"
#import "UserModel.h"
@implementation ApiLoginRequest
- (ApiAccessType)accessType
{
    return kApiAccessPost;
}
- (NSString *)serviceUrl {
    return SERVER_HOST_PRODUCT;
}
- (NSString *)urlAction {
    return LoginAction;
}
- (void)setApiParams{
    LoginConfig *login = [LoginConfig Instance];
    UserModel *model = [login getUserInfo];
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    NSString *secret  = [NSString stringWithFormat:@"%@%@%@%@%@",model.userId,model.userName,model.userIcon,timeString,@"dfawef224"];
    NSString *key = [Common MD5With:secret];
    key = [key lowercaseString];

    [self.params setObject:model.userId forKey:@"id"];
    [self.params setObject:model.userName forKey:@"name"];
    [self.params setObject:model.userIcon forKey:@"headpath"];
    [self.params setObject:timeString forKey:@"timespan"];
    [self.params setObject:key forKey:@"key"];

    
}

@end
