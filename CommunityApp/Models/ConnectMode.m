//
//  ConnectMode.m
//  CommunityApp
//
//  Created by iss on 15/6/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ConnectMode.h"

@implementation ConnectMode
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self)
    {
        _callId = [dictionary objectForKey:@"callId"];
        _address = [dictionary objectForKey:@"name"];
        _telNo = [dictionary objectForKey:  @"phone"];
        _detailAddress = [dictionary objectForKey:@"detailAddress"];
    }
    
    return self;
}
@end
