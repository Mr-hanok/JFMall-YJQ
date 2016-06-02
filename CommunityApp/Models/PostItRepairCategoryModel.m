//
//  PostItRepairCategoryModel.m
//  CommunityApp
//
//  Created by issuser on 15/6/15.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "PostItRepairCategoryModel.h"

@implementation PostItRepairCategoryModel

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _serviceId      = [dictionary objectForKey:@"serviceId"];
        _serviceName    = [dictionary objectForKey:@"serviceName"];
        _serviceCode    = [dictionary objectForKey:@"serviceCode"];
        _serviceLogoUrl = [dictionary objectForKey:@"serviceLogoUrl"];
        _parentId       = [dictionary objectForKey:@"parentId"];
    }
    return self;
}

@end
