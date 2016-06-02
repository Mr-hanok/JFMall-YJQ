//
//  PaymentHistoryModel.m
//  CommunityApp
//
//  Created by issuser on 15/7/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "PaymentHistoryModel.h"

@implementation PaymentHistoryModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self)
    {
        _payMentAmount = [dictionary objectForKey:@"payMentAmount"];
        _payMentDate = [dictionary objectForKey:@"payMentDate"];
        _paymentTypeName = [dictionary objectForKey:@"paymentType"];
        _state = [dictionary objectForKey:@"state"];
    }
    
    return self;
}

@end
