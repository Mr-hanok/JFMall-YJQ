//
//  Coupon.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "Coupon.h"

@implementation Coupon


-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        _result = [dictionary objectForKey:@"result"];
        _startDate = [dictionary objectForKey:@"startDate"];
        _endDate = [dictionary objectForKey:@"endDate"];

        _ticketstype = [dictionary objectForKey:@"ticketstype"];
        if(_ticketstype==nil)
        {
            _ticketstype = [dictionary objectForKey:@"cpType"];
        }
        _preferentialPrice = [dictionary objectForKey:@"preferentialPrice"];
        _discount = [dictionary objectForKey:@"discount"];
        _conditionsPrice = [dictionary objectForKey:@"conditionsPrice"];
        _buyNumber = [dictionary objectForKey:@"buyNumber"];
        _givenNumber = [dictionary objectForKey:@"givenNumber"];
        _cpNo = [dictionary objectForKey:@"cpNo"];
        if (_cpNo == nil) {
            _cpNo= [dictionary objectForKey:@"couponsCode"];
        }
        _state = [dictionary objectForKey:@"state"];
        _cpId = [dictionary objectForKey:@"cpId"];
 
        _supportGoodsIds = [dictionary objectForKey:@"supportGoodsIds"];
        
        _sellerName = [dictionary objectForKey:@"sellerName"];
        if (_sellerName == nil) {
            _sellerName = [dictionary objectForKey:@"cpTitle"];
        }
        _cpModule = [dictionary objectForKey:@"cpModule"];
        _property = [dictionary objectForKey:@"property"];
        _logo = [dictionary objectForKey:@"logo"];
        if (_logo == nil) {
            _logo = [dictionary objectForKey:@"cpLogo"];
        }
    }
    
    return self;
}
-(CGFloat)billByCouponWithNum:(NSInteger)num price:(CGFloat)price
{
    CGFloat rawBill = num*price;
    CGFloat discountBill = 0;
    if ([_state isEqualToString:@"1"]==FALSE) {
        return rawBill-discountBill;
    }
    NSDate* currnt = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate* mixDate;
    NSDate* maxDate ;
    if(_startDate != nil)
       mixDate  = [formatter dateFromString:_startDate];
    if(_endDate != nil)
        maxDate  = [formatter dateFromString:_endDate];
    //判断时间
    if (mixDate) {
        NSDate* later = [currnt laterDate:mixDate];
        if(later != currnt)
        {
            return rawBill-discountBill;//过期
        }
    }
    if (maxDate) {
        NSDate* earlier = [currnt earlierDate:maxDate];
        if(earlier != currnt)
        {
            return rawBill-discountBill;//过期
        }
    }
    //（'1':'现金券','2':'折扣券','3':'满减券','4':'买赠券', '5':'福利券'）
    if ([_ticketstype isEqualToString:@"1"])
    {
        discountBill = [_preferentialPrice floatValue];
    }else if ([_ticketstype isEqualToString:@"2"])
    {
        discountBill = rawBill* [_discount floatValue];
    }
    else if ([_ticketstype isEqualToString:@"3"])
    {
        NSInteger count = 0;
        if(_conditionsPrice && [_conditionsPrice isEqualToString:@""]==FALSE)
            count = rawBill/[_conditionsPrice floatValue];
        discountBill = count*[_preferentialPrice floatValue];
    }
    else if ([_ticketstype isEqualToString:@"4"])
    {
        NSInteger count = 0;
        NSInteger mod = [_buyNumber intValue]+[_givenNumber intValue];
        if (mod!=0) {
            count = num/mod;
            rawBill = (num%mod+[_buyNumber intValue]*mod)*price;
            discountBill = 0;
        }
    }
    if ([_ticketstype isEqualToString:@"5"]) {
        discountBill = [_preferentialPrice floatValue];
    }
    
    return rawBill-discountBill<0?0:rawBill-discountBill;
}


- (CGFloat)getDiscountMoneyWithPrice:(CGFloat)price
{
    CGFloat discountBill = 0.0;
    
    //（'1':'现金券','2':'折扣券','3':'满减券','4':'买赠券', '5':'福利券'）
    if ([_ticketstype isEqualToString:@"1"])
    {
        if ((price - [_conditionsPrice floatValue]) >= 0 ) {
            if ((price - [_preferentialPrice floatValue]) >= 0) {
                discountBill = [_preferentialPrice floatValue];
            }else {
                discountBill = price;
            }
        }
    }else if ([_ticketstype isEqualToString:@"2"])
    {
        if (![_discount isEqualToString:@""] && (price - [_conditionsPrice floatValue] >= 0)) {
            discountBill = price - price * ([_discount floatValue] / 100);
        }
    }
    else if ([_ticketstype isEqualToString:@"3"])
    {
        if (_conditionsPrice == nil || [_conditionsPrice isEqualToString:@""]) {
            discountBill = 0.0;
        }else {
            if ( (price - [_conditionsPrice floatValue]) >= 0) {
                discountBill = [_preferentialPrice floatValue];
            }else {
                discountBill = 0.0;
            }
        }
    }
    else if ([_ticketstype isEqualToString:@"4"])
    {
        discountBill = 0.0;
    }
    if ([_ticketstype isEqualToString:@"5"])
    {
        if ((price - [_preferentialPrice floatValue]) < 0) {
            discountBill = price;
        }else {
            discountBill = [_preferentialPrice floatValue];
        }
    }
    
    return discountBill;
}



@end
