//
//  GroupBuyDetail.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/16.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GroupBuyDetail.h"

@implementation GroupBuyDetail

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        _goodsUrl = [dictionary objectForKey:@"goodsUrl"];
        _goodsDescription = [dictionary objectForKey:@"goodsDescription"];
        _goodsName = [dictionary objectForKey:@"goodsName"];
        _goodsPrice = [dictionary objectForKey:@"goodsPrice"];
        _groupBuyDetail = [dictionary objectForKey:@"groupBuyDetail"];
        _label = [dictionary objectForKey:@"label"];
        _needAppointment = [dictionary objectForKey:@"needAppointment"];
        _supportBack = [dictionary objectForKey:@"supportBack"];
        _shopName = [dictionary objectForKey:@"shopName"];
        _details = [dictionary objectForKey:@"details"];
        _goodsActualPrice = [dictionary objectForKey:@"goodsActualPrice"];
        _groupBuyStartTime = [dictionary objectForKey:@"groupBuyStartTime"];
        _groupBuyEndTime = [dictionary objectForKey:@"groupBuyEndTime"];
        _isFavorites = [dictionary objectForKey:@"isFavorites"];
        _supportCoupons = [dictionary objectForKey:@"supportCoupons"];
        _sellerId = [dictionary objectForKey:@"sellerId"];
    }
    
    return self;
}

@end
