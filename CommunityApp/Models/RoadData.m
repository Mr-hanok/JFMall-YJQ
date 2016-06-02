//
//  RoadData.m
//  CommunityApp
//
//  Created by iss on 15/6/10.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "RoadData.h"

@implementation RoadData : BaseModel

- (instancetype)init {
    if (self = [super init]) {
        _address = @"";
        _isDefault = @"";
        _projectId = @"";
        _projectName = @"";
        _relateId = @"";
        _buildingId = @"";
        _location = @"";
        _authen = @"";
        _contactTel = @"";
        _contactName = @"";
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self)
    {
        _address = [dictionary objectForKey:@"address"];
        _isDefault = [dictionary objectForKey:  @"isDefault"];
        _projectId = [dictionary objectForKey:  @"projectId"];
        _projectName = [dictionary objectForKey:  @"projectName"];
        _relateId = [dictionary objectForKey:  @"relateId"];
        _buildingId = [dictionary objectForKey: @"buildingId" ];
        _location = [dictionary objectForKey: @"location" ];
        _authen = [dictionary objectForKey: @"authen" ];
        _contactTel = [dictionary objectForKey: @"contactTel" ];
        _contactName = [dictionary objectForKey: @"contactName" ];
    }
    
    return self;
}

@end
