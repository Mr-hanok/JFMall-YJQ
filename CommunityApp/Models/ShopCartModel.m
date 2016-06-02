//
//  ShopCartModel.m
//  CommunityApp
//
//  Created by issuser on 15/6/30.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ShopCartModel.h"

@implementation ShopCartModel

NSString *const kPaymentTypeOnline = @"1";
NSString *const kPaymentTypeOffline = @"2";

/* 创建用户购物车信息一览表
 * type: 0-商品；1-服务
 * wsid: 商品id 或 服务id
 * wsname: 商品名 或 服务名
 * count: 商品数量
 * originalprice: 商品或服务原价
 * currentprice: 商品或服务现价
 * picurl: 图片URL
 * supportservice: 支持的服务
 * servicetime: 预约服务时间
 * intocarttime: 商品加入购物车时间
 */
-(id)initWithFMResultSet:(FMResultSet *)rs
{
    self = [super initWithFMResultSet:rs];
    if (self) {
        self.cartId = [rs intForColumn:@"id"];
        self.type = [rs intForColumn:@"type"];
        self.wsId = [rs stringForColumn:@"wsid"];
        if (self.wsId == nil) {
            self.wsId = @"";
        }
        
        self.wsName = [rs stringForColumn:@"wsname"];
        if (self.wsName == nil) {
            self.wsName = @"";
        }
        
        self.goodsType = [rs stringForColumn:@"goodsType"];
        if (self.goodsType == nil) {
            self.goodsType = @"";
        }
        
        self.count = [rs intForColumn:@"count"];
        self.originalPrice = [rs stringForColumn:@"originalprice"];
        if (self.originalPrice == nil) {
            self.originalPrice = @"";
        }
        
        self.currentPrice = [rs stringForColumn:@"currentprice"];
        if (self.currentPrice == nil) {
            self.currentPrice = @"";
        }
        
        self.picUrl = [rs stringForColumn:@"picurl"];
        if (self.picUrl == nil) {
            self.picUrl = @"";
        }
        
        self.supportService = [rs stringForColumn:@"supportservice"];
        if (self.supportService == nil) {
            self.supportService = @"";
        }
        
        self.serviceTime = [rs stringForColumn:@"servicetime"];
        if (self.serviceTime == nil) {
            self.serviceTime = @"";
        }
        
        self.intoCartTime = [rs stringForColumn:@"intocarttime"];
        if (self.intoCartTime == nil) {
            self.intoCartTime = @"";
        }
        
        self.appointmentType = [rs intForColumn:@"appointmentType"];

        self.sellerId = [rs stringForColumn:@"sellerId"];
        if (self.sellerId == nil) {
            self.sellerId = @"";
        }
        
        self.sellerName = [rs stringForColumn:@"sellername"];
        if (self.sellerName == nil) {
            self.sellerName = @"";
        }
        
        self.deliveryType = [rs stringForColumn:@"deliverytype"];
        if (self.deliveryType == nil) {
            self.deliveryType = @"";
        }
        
        self.waresStyle = [rs stringForColumn:@"waresstyle"];
        if (self.waresStyle == nil) {
            self.waresStyle = @"";
        }
        
        self.projectId = [rs stringForColumn:@"projectid"];
        if (self.projectId == nil) {
            self.projectId = @"";
        }
        self.moduleType = [rs stringForColumn:@"moduleType"];
        if (self.moduleType == nil) {
            self.moduleType = @"";
        }
        self.paymentType = [rs stringForColumn:@"paymentType"];
        self.storeRemainCount = [rs stringForColumn:@"storeRemainCount"];
        self.isPutGoods = [rs stringForColumn:@"isPutGoods"];
        
        
        self.specialOfferStatus = [rs stringForColumn:@"specialOfferStatus"];
        if (self.specialOfferStatus == nil) {
            self.specialOfferStatus = @"";
        }
        self.specialOfferBuy = [rs stringForColumn:@"specialOfferBuy"];
        if (self.specialOfferBuy == nil) {
            self.specialOfferBuy = @"";
        }
        self.specialOfferPrice = [rs stringForColumn:@"specialOfferPrice"];
        if (self.specialOfferPrice == nil) {
            self.specialOfferPrice = @"";
        }
    }
    return self;
}



-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        _projectId = [dictionary objectForKey:@"projectId"];
        if (_projectId == nil) {
            _projectId = @"";
        }
        _wsId = [dictionary objectForKey:@"goodsId"];
        if (_wsId == nil) {
            _wsId = @"";
        }
        if ([dictionary objectForKey:@"shopGoodsCount"] == nil || [[dictionary objectForKey:@"shopGoodsCount"] isEqualToString:@""]) {
            _count = 1;
        }else{
            _count = [[dictionary objectForKey:@"shopGoodsCount"] integerValue];
        }
        
        _waresStyle = [dictionary objectForKey:@"standardModel"];
        if (_waresStyle == nil) {
            _waresStyle = @"";
        }
        _wsName = [dictionary objectForKey:@"goodsName"];
        if (_wsName == nil) {
            _wsName = @"";
        }
        _picUrl = [dictionary objectForKey:@"goodsUrl"];
        if (_picUrl == nil) {
            _picUrl = @"";
        }
        _currentPrice = [dictionary objectForKey:@"goodsPrice"];
        if (_currentPrice == nil) {
            _currentPrice = @"";
        }
        _originalPrice = [dictionary objectForKey:@"goodsActualPrice"];
        if (_originalPrice == nil) {
            _originalPrice = @"";
        }
        _sellerId = [dictionary objectForKey:@"sellerId"];
        if (_sellerId == nil) {
            _sellerId = @"";
        }
        _sellerName = [dictionary objectForKey:@"sellerName"];
        if (_sellerName == nil) {
            _sellerName = @"";
        }
        _supportCoupons = [dictionary objectForKey:@"supportCoupons"];
        if (_supportCoupons == nil) {
            _supportCoupons = @"";
        }
        _deliveryType = [dictionary objectForKey:@"deliveryType"];
        if (_deliveryType == nil) {
            _deliveryType = @"";
        }
        _moduleType = [dictionary objectForKey:@"moduleType"];
        if (_moduleType == nil) {
            _moduleType = @"";
        }
        self.goodsType = [dictionary objectForKey:@"goodsType"];
        if (self.goodsType == nil) {
            self.goodsType = @"";
        }
        _sgBrand = [dictionary objectForKey:@"sgBrand"];
        if (_sgBrand == nil) {
            _sgBrand = @"";
        }
        _paymentType = [dictionary objectForKey:@"paymentType"];
        _storeRemainCount = [dictionary objectForKey:@"storeRemainCount"];
        _isPutGoods = [dictionary objectForKey:@"isPutGoods"];
        
        
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

- (BOOL)isUseSpecialOfferRight {
    return [self isHasSpecialOfferRight] && !_isAbandonSpecialOfferUseRight;
}

- (CGFloat)calculationTotlePrice {
    CGFloat totlePrice = .0f;
    
    if ([self isUseSpecialOfferRight]) {
        if (self.specialOfferPrice.floatValue > 0) {
            totlePrice += self.specialOfferPrice.floatValue;
        }
        if (self.count > 1) {
            totlePrice += (self.count-1)*self.currentPrice.floatValue;
        }
    }
    else {
        if (self.count > 0) {
            totlePrice = self.count * self.currentPrice.floatValue;
        }
    }
    return totlePrice;
}

// 重置互斥特价商品使用状态（基于同种商品的互斥原则，有的商品即使是特价，也不能使用）
+ (void)resetSpecialOfferUseRight:(NSArray *)models {
    
    NSMutableArray *selectedModels = [[NSMutableArray alloc] init];
    NSMutableArray *wsIds = [[NSMutableArray alloc] init];
    
    for (ShopCartModel *model in models) {
        if ([model isHasSpecialOfferRight] && model.isSelected && ![wsIds containsObject:model.wsId]) {
            [selectedModels addObject:model];
            [wsIds addObject:model.wsId];
        }
    }
    
    for (ShopCartModel *model in models) {
        if ([model isHasSpecialOfferRight]) {
            if ([wsIds containsObject:model.wsId] && ![selectedModels containsObject:model]) {
                model.isAbandonSpecialOfferUseRight = YES;
            }
            else {
                model.isAbandonSpecialOfferUseRight = NO;
            }
        }
    }
}

+ (CGFloat)calculationPrice:(NSArray *)models {
    CGFloat totle = 0.0f;
    CGFloat reduce = 0.0f;
    
    NSMutableArray *wsIds = [[NSMutableArray alloc] init];
    for (ShopCartModel *model in models) {
        if ([model isHasSpecialOfferRight] && ![wsIds containsObject:model.wsId]) {
            reduce += (model.currentPrice.floatValue - model.specialOfferPrice.floatValue);
            [wsIds addObject:model.wsId];
        }
        totle += model.count * model.currentPrice.floatValue;
    }
    return totle-reduce;
}

+ (CGFloat)calculationSpecialOfferPrice:(NSArray *)models {
    CGFloat reduce = 0.0f;
    NSMutableArray *wsIds = [[NSMutableArray alloc] init];
    for (ShopCartModel *model in models) {
        if ([model isHasSpecialOfferRight] && ![wsIds containsObject:model.wsId]) {
            reduce += (model.currentPrice.floatValue - model.specialOfferPrice.floatValue);
            [wsIds addObject:model.wsId];
        }
    }
    return reduce;
}

+ (BOOL)isUseSpecialOffer:(NSArray *)models {
    BOOL isUseDiscount = NO;
    for (ShopCartModel *model in models) {
        if ([model isHasSpecialOfferRight]) {
            isUseDiscount = YES;
            break;
        }
    }
    return isUseDiscount;
}

+ (BOOL)isHasSpecialOffer:(NSArray *)models {
    BOOL isUseDiscount = NO;
    for (ShopCartModel *model in models) {
        if ([model isSpecialOfferGoods]) {
            isUseDiscount = YES;
            break;
        }
    }
    return isUseDiscount;
}

+ (int)specialOffeCount:(NSArray *)models {
    int count = 0;
    NSMutableArray *wsIds = [[NSMutableArray alloc] init];
    for (ShopCartModel *model in models) {
        if ([model isHasSpecialOfferRight] && ![wsIds containsObject:model.wsId]) {
            count++;
            [wsIds addObject:model.wsId];
        }
    }
    return count;
}

// 有没有购买过的
+ (BOOL)isSpecialOfferNoRight:(NSArray *)models {
    BOOL result = NO;
    for (ShopCartModel *model in models) {
        if ([model isSpecialOfferNoRight]) {
            result = YES;
            break;
        }
    }
    return result;
}

@end
