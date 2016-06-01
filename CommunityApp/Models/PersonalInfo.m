//
//  PersonalInfo.m
//  CommunityApp
//
//  Created by 酒剑 笛箫 on 15/8/31.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "PersonalInfo.h"

@implementation PersonalInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self)
    {
        _ownerName = [dictionary objectForKey:@"ownerName"];
        _sex = [dictionary objectForKey:@"sex"];
        _ownerPhone = [dictionary objectForKey:@"ownerPhone"];
        _customPropert = [dictionary objectForKey:@"customPropert"];
        _priviceId = [dictionary objectForKey:@"priviceId"];
        _cityId = [dictionary objectForKey:@"cityId"];
    }
    return self;
}

@end
