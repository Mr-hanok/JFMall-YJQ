//
//  SurroundBusinessModel.m
//  CommunityApp
//
//  Created by issuser on 15/6/15.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "SurroundBusinessModel.h"

@implementation SurroundBusinessModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _address = [dictionary objectForKey:@"address"];
        _businessId = [dictionary objectForKey:@"businessId"];
        _businessName = [dictionary objectForKey:@"businessName"];
        _businessPicUrl = [dictionary objectForKey:@"businessPicUrl"];
        _phone  = [dictionary objectForKey:@"phone"];
        _longitude = [dictionary objectForKey:@"longitude"];
        _latitude = [dictionary objectForKey:@"latitude"];
        _distance = [dictionary objectForKey:@"distance"];
        _descp  = [dictionary objectForKey:@"description"];
        _perConsumption = [dictionary objectForKey:@"perConsumption"];
        _score = [dictionary objectForKey:@"score"];
        _label = [dictionary objectForKey:@"label"];             //标签
        _reviewNumber  = [dictionary objectForKey:@"reviewNumber"];
        _isVerified = [dictionary objectForKey:@"isVerified"];
    }
    return self;
}

@end
