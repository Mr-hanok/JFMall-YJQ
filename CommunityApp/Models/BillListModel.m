//
//  BillListModel.m
//  CommunityApp
//
//  Created by issuser on 15/7/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BillListModel.h"

@implementation BillListModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self)
    {
        _receivableId = [dictionary objectForKey:@"receivableId"];
        _fiName = [dictionary objectForKey:@"fiName"];
        _billDate = [dictionary objectForKey:@"billDate"];
        _receivable = [dictionary objectForKey:@"receivable"];
        _settlementStatus = [dictionary objectForKey:@"settlementStatus"];
        _billType = [dictionary objectForKey:@"billType"];
    }
    
    return self;
}


@end
