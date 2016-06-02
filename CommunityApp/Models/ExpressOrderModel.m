//
//  ExpressOrderModel.m
//  CommunityApp
//
//  Created by 酒剑 笛箫 on 15/9/30.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ExpressOrderModel.h"

@implementation ExpressOrderModel

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        _expressId = [dictionary objectForKey:@"expressId"];
        _stateId = [dictionary objectForKey:@"stateId"];
        _expressName = [dictionary objectForKey:@"expressName"];
        _expressNo = [dictionary objectForKey:@"expressNo"];
        _qrcode = [dictionary objectForKey:@"qrcode"];
        _createDate = [dictionary objectForKey:@"createDate"];
    }
    return self;
}

@end
