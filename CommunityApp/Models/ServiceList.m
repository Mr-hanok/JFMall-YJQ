//
//  ServiceList.m
//  CommunityApp
//
//  Created by issuser on 15/6/19.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ServiceList.h"

@implementation ServiceList

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
//        _serviceId = [dictionary objectForKey:@"serviceId"];
//        _serviceName = [dictionary objectForKey:@"serviceName"];
//        _serviceLogoUrl = [dictionary objectForKey:@"serviceLogoUrl"];
        _serviceId = [dictionary objectForKey:@"goodsId"];
        _serviceName = [dictionary objectForKey:@"goodsName"];
        _serviceLogoUrl = [dictionary objectForKey:@"goodsUrl"];
        
    }
    return self;
}

@end
