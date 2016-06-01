//
//  WaresList.m
//  CommunityApp
//
//  Created by issuser on 15/6/19.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "WaresList.h"

@implementation WaresList

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _goodsId = [dictionary objectForKey:@"goodsId"];
        _goodsName = [dictionary objectForKey:@"goodsName"];
        _goodsPrice = [dictionary objectForKey:@"goodsPrice"];
        _goodsActualPrice = [dictionary objectForKey:@"goodsActualPrice"];
        _goodsUrl = [dictionary objectForKey:@"goodsUrl"];
        
        _goodsDescription = [dictionary objectForKey:@"goodsDescription"];
        _limitStartTime = [dictionary objectForKey:@"limitStartTime"];
        _limitEndTime = [dictionary objectForKey:@"limitEndTime"];
        _currTime = [dictionary objectForKey:@"currTime"];
        _currPage = [dictionary objectForKey:@"currPage"];
        _pageSize = [dictionary objectForKey:@"pageSize"];
        _totalPage = [dictionary objectForKey:@"totalPage"];
        _hasNext = [dictionary objectForKey:@"hasNext"];
        _sellerId = [dictionary objectForKey:@"sellerId"];
        
        _totalNumber = [dictionary objectForKey:@"totalNumber"];
        _isNewGoods = [dictionary objectForKey:@"newGoods"];
        _isSalesGoods = [dictionary objectForKey:@"salesGoods"];
        _sellerName = [dictionary objectForKey:@"sellerName"];
        _shopGoodsCount = [dictionary objectForKey:@"shopGoodsCount"];
        _sgBrand = [dictionary objectForKey:@"sgBrand"];
        _standardModel = [dictionary objectForKey:@"standardModel"];
        _supportCoupons = [dictionary objectForKey:@"supportCoupons"];
        _deliveryType = [dictionary objectForKey:@"deliveryType"];
        _moduleType = [dictionary objectForKey:@"moduleType"];
        
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

@end



@implementation GoodWaresList

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _gcName = [dictionary objectForKey:@"gcName"];
        _gcId = [dictionary objectForKey:@"gcId"];
        _clientShow = [dictionary objectForKey:@"clientShow"];
        _goodsUrl = [dictionary objectForKey:@"goodsUrl"];
        _goodsList =[[NSMutableArray alloc] init];
        
        NSString *strGoodsList = [dictionary objectForKey:@"GoodsList"];
        NSError *error = nil;
        if (strGoodsList != nil && strGoodsList.length > 0 && ![strGoodsList isEqualToString:@"[]"]) {
            NSString *strList = [strGoodsList substringWithRange:NSMakeRange(1, strGoodsList.length-2)];
            NSArray *strArray = [strList componentsSeparatedByString:@"},"];
            
            NSInteger   index = 0;
            for (NSString *strGoods in strArray) {
                index++;
                NSString *goodsString = strGoods;
                if (index < strArray.count) {
                    goodsString = [strGoods stringByAppendingString:@"}"];
                }
                NSData *data = [goodsString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                if (dic.count > 0) {
                    [_goodsList addObject:[[WaresList alloc] initWithDictionary:dic]];
                }
            }
        }
    }
    
    return self;
}

@end



