//
//  WaresDetail.m
//  CommunityApp
//
//  Created by issuser on 15/6/19.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "WaresDetail.h"

@implementation WaresDetail

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _goodsId = [dictionary objectForKey:@"goodsId"];
        _goodsName = [dictionary objectForKey:@"goodsName"];
        _goodsType = [dictionary objectForKey:@"goodsType"];
        if(_goodsType==nil)
            _goodsType = @"";
        _goodsPrice = [dictionary objectForKey:@"goodsPrice"];//goodsPrice//goodsActualPrice
        if(_goodsPrice==nil)
            _goodsPrice = @"";
        _goodsActualPrice = [dictionary objectForKey:@"goodsActualPrice"];
        
        YjqLog(@"%@",_goodsActualPrice);
        if(_goodsActualPrice==nil)
            _goodsActualPrice = @"";
        _goodsUrl = [dictionary objectForKey:@"goodsUrl"];
        if(_goodsUrl==nil)
            _goodsUrl = @"";
        _goodsDescription = [dictionary objectForKey:@"goodsDescription"];
        if(_goodsDescription==nil)
            _goodsDescription = @"";
        _isNewGoods = [dictionary objectForKey:@"newGoods"];
        if(_isNewGoods==nil)
            _isNewGoods = @"";
        _salesGoods = [dictionary objectForKey:@"salesGoods"];
        if(_salesGoods==nil)
            _salesGoods = @"";
        _service = [dictionary objectForKey:@"service"];
        if(_service==nil)
            _service = @"";
        _sgBrand = [dictionary objectForKey:@"sgBrand"];
        if(_sgBrand==nil)
            _sgBrand = @"";
        _standardModel = [dictionary objectForKey:@"standardModel"];
        if(_standardModel==nil)
            _standardModel = @"";
        _totalNumber = [dictionary objectForKey:@"totalNumber"];
        if(_totalNumber==nil)
            _totalNumber = @"";
        _remainCount = [dictionary objectForKey:@"remainCount"];
        if(_remainCount==nil)
            _remainCount = @"";
        _moduleType = [dictionary objectForKey:@"moduleType"];
        if(_moduleType==nil)
            _moduleType = @"";
        _sellerId = [dictionary objectForKey:@"sellerId"];
        if(_sellerId==nil)
            _sellerId = @"";
        _supportCoupons = [dictionary objectForKey:@"supportCoupons"];
        if(_supportCoupons==nil)
            _supportCoupons = @"";
        _deliveryType = [dictionary objectForKey:@"deliveryType"];
        if(_deliveryType==nil)
            _deliveryType = @"";
        _evaluations = [dictionary objectForKey:@"evaluations"];
        if(_evaluations==nil)
            _evaluations = @"";
        NSString *shopGoodsCount = [dictionary objectForKey:@"shopGoodsCount"];
        if(shopGoodsCount==nil || [shopGoodsCount isEqualToString:@""])
            _shopGoodsCount = 0;
        else
            _shopGoodsCount = shopGoodsCount.integerValue;
        _sellerName = [dictionary objectForKey:@"sellerName"];
        if(_sellerName==nil)
            _sellerName = @"";
        _label = [dictionary objectForKey:@"label"];
        if(_label==nil)
            _label = @"";
        _limitStartTime = [dictionary objectForKey:@"limitStartTime"];
        if(_limitStartTime==nil)
            _limitStartTime = @"";
        _limitEndTime = [dictionary objectForKey:@"limitEndTime"];
        if(_limitEndTime==nil)
            _limitEndTime = @"";
        _paymentType = [Common vaildString:[dictionary objectForKey:@"paymentType"]];
        _isPutGoods = [Common vaildString:[dictionary objectForKeyedSubscript:@"isPutGoods"]];
        _storeRemainCount = [Common vaildString:[dictionary objectForKey:@"storeRemainCount"]];
        
        _specialOfferStatus = [dictionary objectForKey:@"specialOfferStatus"];
        if (_specialOfferStatus == nil) {
            _specialOfferStatus = @"";
        }
        _specialOfferBuy = [dictionary objectForKey:@"specialOfferBuy"];
        if (_specialOfferBuy == nil) {
            _specialOfferBuy = @"";
        }
        _specialOfferPrice = [dictionary objectForKey:@"specialOfferPrice"];
        if (_specialOfferPrice == nil) {
            _specialOfferPrice = @"";
        }
        _sellerPhone = [dictionary objectForKey:@"sellerPhone"];
        if (_sellerPhone == nil) {
            _sellerPhone = @"";
        }
    }
    return self;
}


-(id)initWithWaresList:(WaresList *)wares
{
    self = [super init];
    if (self) {
        _goodsId = wares.goodsId;
        _goodsName = wares.goodsName;
        _goodsPrice = wares.goodsPrice;
        _goodsActualPrice = wares.goodsActualPrice;
        _goodsUrl = wares.goodsUrl;
        _goodsDescription = wares.goodsDescription;
        _isNewGoods = wares.isNewGoods;
        _salesGoods = wares.isSalesGoods;
        _service = @"";
        _sgBrand = wares.sgBrand;
        _standardModel = wares.standardModel;
        _totalNumber = wares.totalNumber;
        _sellerId = wares.sellerId;
        _sellerName = wares.sellerName;
        _supportCoupons = wares.supportCoupons;
        _deliveryType = wares.deliveryType;
        
        _specialOfferStatus = wares.specialOfferStatus;
        _specialOfferBuy = wares.specialOfferBuy;
        _specialOfferPrice = wares.specialOfferPrice;
        
        if (wares.standardModel != nil && ![wares.standardModel isEqualToString:@""]) {
            NSArray *styles = [wares.standardModel componentsSeparatedByString:@","];
            if (styles.count > 0) {
                _selectedStyle = [styles objectAtIndex:0];
            }
        }else {
            _selectedStyle = @"";
        }
    }
    return self;
}

- (BOOL)isSpecialOfferGoods {
    return [_specialOfferStatus isEqualToString:@"1"];
}

- (BOOL)isHasSpecialOfferRight {
    return [self.specialOfferStatus isEqualToString:@"1"] && [self.specialOfferBuy isEqualToString:@"0"];
}

- (BOOL)isSpecialOfferNoRight {
    return [self.specialOfferStatus isEqualToString:@"1"] && [self.specialOfferBuy isEqualToString:@"1"];
}

- (CGFloat)calculationTotlePrice {
    CGFloat totlePrice = .0f;
    
    if ([self isHasSpecialOfferRight]) {
        if (self.specialOfferPrice.floatValue > 0) {
            totlePrice += self.specialOfferPrice.floatValue;
        }
        if (self.shopGoodsCount > 1) {
            totlePrice += (self.shopGoodsCount-1)*self.goodsPrice.floatValue;
        }
    }
    else {
        if (self.shopGoodsCount > 0) {
            totlePrice = self.shopGoodsCount * self.goodsPrice.floatValue;
        }
    }
    return totlePrice;
}


@end
