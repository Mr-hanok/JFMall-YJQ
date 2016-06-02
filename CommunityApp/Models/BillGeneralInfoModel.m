//
//  BillGeneralInfoModel.m
//  CommunityApp
//
//  Created by issuser on 15/7/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BillGeneralInfoModel.h"

@implementation BillGeneralInfoModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self)
    {
        _prepaidAmount = [dictionary objectForKey:@"prepaidAmount"];
        _unpaidAmount = [dictionary objectForKey:@"unpaidAmount"];
    }
    
    return self;
}

@end
