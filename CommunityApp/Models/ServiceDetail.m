//
//  ServiceDetail.m
//  CommunityApp
//
//  Created by issuser on 15/6/16.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ServiceDetail.h"

@implementation ServiceDetail

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
//        _serviceId = [dictionary objectForKey:@"serviceId"];
//        _serviceName = [dictionary objectForKey:@"serviceName"];
//        _servicePrice = [dictionary objectForKey:@"servicePrice"];
//        if ([_servicePrice isEqualToString:@""]) {
//            _servicePrice = @"0.0";
//        }
//        _serviceDesc = [dictionary objectForKey:@"serviceDesc"];
//        _priceDesc  = [dictionary objectForKey:@"priceDesc"];
//        _servicePicUrl = [dictionary objectForKey:@"servicePicUrl"];
        
        _serviceName = [dictionary objectForKey:@"goodsName"];
        _servicePrice = [dictionary objectForKey:@"goodsPrice"];
        if ([_servicePrice isEqualToString:@""]) {
            _servicePrice = @"0.0";
        }
        _serviceDesc = [dictionary objectForKey:@"goodsDescription"];
        _priceDesc  = [dictionary objectForKey:@"priceDesc"];
        _servicePicUrl = [dictionary objectForKey:@"goodsUrl"];
        _paymentType = [dictionary objectForKey:@"paymentType"];
        _supportCoupons = [dictionary objectForKey:@"supportCoupons"];
        _payService = [dictionary objectForKey:@"payService"];
    }
    return self;
}

@end
