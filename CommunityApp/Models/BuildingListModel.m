//
//  BuildingListModel.m
//  CommunityApp
//
//  Created by issuser on 15/7/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BuildingListModel.h"

@implementation BuildingListModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self)
    {
        _buildingId = [dictionary objectForKey:@"buildingId"];
        _address = [dictionary objectForKey:@"address"];
        _houseId = [dictionary objectForKey:@"houseId"];
        _location= [dictionary objectForKey:@"location"];
        _buildAddress= [dictionary objectForKey:@"buildAddress"];
        _isDefault= [dictionary objectForKey:@"isDefault"];
        _authType = [dictionary objectForKey:@"authType"];

    }
    
    return self;
}

@end
