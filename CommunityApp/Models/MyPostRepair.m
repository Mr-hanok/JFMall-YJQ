//
//  MyPostRepair.m
//  CommunityApp
//
//  Created by iss on 15/6/18.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "MyPostRepair.h"

@implementation MyPostRepair:BaseModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self)
    {
        _userId = [dictionary objectForKey:@"userId"];
        _orderId = [dictionary objectForKey:@"orderId"];
        _createDate =[dictionary objectForKey:@"createDate"];
        _orderNum =[dictionary objectForKey:@"orderNum"];
        _serviceName =[dictionary objectForKey:@"serviceName"];
        _state =[dictionary objectForKey:@"state"];
        _stateId =[dictionary objectForKey:@"stateId"];
    }
    
    return self;
}
@end
