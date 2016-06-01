//
//  SurroundBusinessModel.m
//  CommunityApp
//
//  Created by issuser on 15/6/15.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _userName    = [dictionary objectForKey:@"userName"];
        _propertyName  = [dictionary objectForKey:@"propertyName"];
        _propertyId  = [dictionary objectForKey:@"propertyId"];
        _userAccount    = [dictionary objectForKey:@"userAccount"];  //用户账号
        _userId   = [dictionary objectForKey:@"userId"];         //用户ID
        _passWord = [dictionary objectForKey:@"passWord"];         //用户密码
        _openfireAccount  = [dictionary objectForKey: @"openfireAccount"]; //openfire账号
        _sex  = [dictionary objectForKey:  @"sex"];           //性别
        _area = [dictionary objectForKey:  @"area"];
        _ownerPhone = [dictionary objectForKey:  @"ownerPhone"];
        _membersLevel= [dictionary objectForKey:  @"membersLevel"];
        _currentIntegral= [dictionary objectForKey:  @"currentIntegral"];
        _filePath = [dictionary objectForKey:@"filePath"];
        _ownerCall = [dictionary objectForKey:@"ownerCall"];
     }
    return self;
}

@end
