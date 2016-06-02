//
//  GrouponShop.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/25.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GrouponShop.h"

@implementation GrouponShop

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _shopId = [dictionary objectForKey:@"shopId"];
        _shopName = [dictionary objectForKey:@"shopName"];
        _shopTelNo = [dictionary objectForKey:@"shopTelNo"];
        _address = [dictionary objectForKey:@"address"];
    }
    return self;
}

@end
