//
//  GrouponOrder.m
//  CommunityApp
//
//  Created by issuser on 15/8/12.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GrouponOrder.h"

@implementation GrouponOrder
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        _goodsName = [dictionary objectForKey:@"goodsName"];//下单人姓名
        _creator = [dictionary objectForKey:@"creator"];    //下单人姓名
        _linkName = [dictionary objectForKey:@"linkName"];  //联系人
        _linkTel = [dictionary objectForKey:@"linkTel"];    //联系电话
        _goodsIds = [dictionary objectForKey:@"goodsIds"];  //（商品Id：团购单价：团购数量）
        _ownerid = [dictionary objectForKey:@"ownerid"];    //下单人ID
        _sellerId = [dictionary objectForKey:@"sellerId"];  //商家ID
        _totalMoney = [dictionary objectForKey:@"totalMoney"];  //团购金额
        _couponsId = [dictionary objectForKey:@"couponsId"];    //优惠券ID
        _couponsMoney = [dictionary objectForKey:@"couponsMoney"];  //优惠金额
        _payMoney = [dictionary objectForKey:@"payMoney"];  //实际支付金额
    }
    return self;
}

@end
