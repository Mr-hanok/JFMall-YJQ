//
//  OrderPostRepair.m
//  CommunityApp
//
//  Created by iss on 15/6/19.
//  Copyright (c) 2015年 iss. All rights reserved.
//  报事订单模型

#import "OrderPostRepair.h"

@implementation OrderPostRepair

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self)
    {
        _address= [dictionary objectForKey:@"address"];
        _createDate = [dictionary objectForKey:@"createDate"];
        _linkName = [dictionary objectForKey:@"linkName"];
        _linkTel = [dictionary objectForKey:@"linkTel"];
        _orderId= [dictionary objectForKey:@"orderId"];
        _orderNum= [dictionary objectForKey:@"orderNum"];
        _serviceId= [dictionary objectForKey:@"serviceId"];
        _serviceName = [dictionary objectForKey:@"serviceName"];
        _statu = [dictionary objectForKey:@"state"];
        _stateId= [dictionary objectForKey:@"stateId"];
        _type = [dictionary objectForKey:@"type"];
        _userId = [dictionary objectForKey:@"userId"];
        _filePath = [dictionary objectForKey:@"filePath"];
    }
    
    return self;
}

@end
