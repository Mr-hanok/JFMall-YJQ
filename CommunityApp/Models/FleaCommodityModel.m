//
//  FleaCommodityModel.m
//  CommunityApp
//
//  Created by iss on 8/13/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "FleaCommodityModel.h"

@implementation FleaCommodityListModel
-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        _stId = [dictionary objectForKey:@"stId"];
        _stNo = [dictionary objectForKey:@"stNo"];
        _title = [dictionary objectForKey:@"title"];
        _price = [dictionary objectForKey:@"price"];
        _positionName = [dictionary objectForKey:@"positionName"];
        _createTime = [dictionary objectForKey:@"createTime"];
        _picture = [dictionary objectForKey:@"picture"];
        _hasNext = [dictionary objectForKey:@"hasNext"];
    }
    return self;
}
@end
@implementation FleaCommodityDetailModel

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        _stNo = [dictionary objectForKey:@"stNo"];
        _title = [dictionary objectForKey:@"title"];
        _price = [dictionary objectForKey:@"price"];
        _degree = [dictionary objectForKey:@"degree"];
        _person = [dictionary objectForKey:@"person"];
        _phone = [dictionary objectForKey:@"phone"];
        _positionName = [dictionary objectForKey:@"positionName"];
        _cityId = [dictionary objectForKey:@"cityId"];
        _createTime = [dictionary objectForKey:@"createTime"];
        _desc = [dictionary objectForKey:@"description"];
        _classifyName = [dictionary objectForKey:@"classifyName"];
        _gcId = [dictionary objectForKey:@"gcId"];
        _picture = [dictionary objectForKey:@"picture"];
        _state = [dictionary objectForKey:@"state"];
    }
    return self;
}
@end