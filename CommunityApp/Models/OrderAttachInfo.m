//
//  OrderAttachInfo.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/12.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "OrderAttachInfo.h"

@implementation OrderAttachInfo


-(id)initWithGoodsCount:(NSInteger)goodsCount andTotalPrice:(float)totalPrice
{
    self = [super init];
    
    if (self) {
        _deliverMethod = @"全场包邮";
        _coupon = @"0.00";
        _remark = @"请填写";
        _goodsCount = goodsCount;
        _totalPrice = totalPrice;
        _deliverPrice = @"0.00";
        _couponIds = @"";
        _useCoupon = nil;
        _useExpress = nil;
        _isUseCoupon = YES;
        _isUseSpecialOffer = NO;
    }
    
    return self;
}

-(id)initWithGoods:(NSArray *)waresArray
{
    self = [super init];
    
    if (self) {
        float totalPrice = [ShopCartModel calculationPrice:waresArray];
        BOOL isUseSpecialOffe = [ShopCartModel isUseSpecialOffer:waresArray];
        
        CGFloat specialOfferDiscountPrice = [ShopCartModel calculationSpecialOfferPrice:waresArray];
        NSInteger goodsCount = 0;
        for (ShopCartModel *model in waresArray) {
            goodsCount += model.count;
        }
        
//        int specialOffeCount = [ShopCartModel specialOffeCount:waresArray];
//        BOOL isUseCoupo = goodsCount > specialOffeCount;
        // 不管多少商品，收单特价和优惠券互斥
        BOOL isUseCoupo = ![ShopCartModel isHasSpecialOffer:waresArray];
        
        _deliverMethod = @"全场包邮";
        _coupon = @"0.00";
        _remark = @"请填写";
        _goodsCount = goodsCount;
        _totalPrice = totalPrice;
        _allPrice = totalPrice;
        _deliverPrice = @"0.00";
        _couponIds = @"";
        _useCoupon = nil;
        _useExpress = nil;
        _isUseCoupon = isUseCoupo;
        _isUseSpecialOffer = isUseSpecialOffe;
        _specialOfferDiscountPrice = specialOfferDiscountPrice;
    }
    
    return self;
}

@end
