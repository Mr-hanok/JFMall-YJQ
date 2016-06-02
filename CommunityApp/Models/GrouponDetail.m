//
//  GrouponDetail.m
//  CommunityApp
//
//  Created by issuser on 15/8/13.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GrouponDetail.h"

@implementation GrouponDetail
-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        _goodsId = [dictionary objectForKey:@"goodsId"];           //商品ID
        _goodsName = [dictionary objectForKey:@"goodsName"];         //商品名称
        _goodsPrice = [dictionary objectForKey:@"goodsPrice"];        //商品原价
        _goodsActualPrice = [dictionary objectForKey:@"goodsActualPrice"];  //商品实际价格
        _goodsUrl = [dictionary objectForKey:@"goodsUrl"];          //商品图片，多个用，分开
        _goodsDescription = [dictionary objectForKey:@"goodsDescription"];  //商品文字说明
        _isNewGoods = [dictionary objectForKey:@"isNewGoods"];        //新商品  默认显示，值为1
        _salesGoods = [dictionary objectForKey:@"salesGoods"];        //促销商品默认显示，值为1
        _service = [dictionary objectForKey:@"service"];           //支持服务，多个用，分开
        _sgBrand = [dictionary objectForKey:@"sgBrand"];           //品牌产地
        _standardModel = [dictionary objectForKey:@"standardModel"];     //规格型号
        _totalNumber = [dictionary objectForKey:@"totalNumber"];       //库存量 ---最新接口不再提供此字段
        _moduleType = [dictionary objectForKey:@"moduleType"];        //模块类型 （1 邻聚街 2 精选商品 3 限时抢 4 商家团购 5跳蚤市场 6到家服务 7普通商品）
        _sellerId = [dictionary objectForKey:@"sellerId"];          //商家id，没有，表示为自营
        _supportCoupons = [dictionary objectForKey:@"supportCoupons"];    //支持的优惠类型 1现金券2折扣券3满减券4买赠券
        _deliveryType = [dictionary objectForKey:@"deliveryType"];      //支持的配送类型
        _evaluations = [dictionary objectForKey:@"evaluations"];       //评价
        _shopGoodsCount = [dictionary objectForKey:@"shopGoodsCount"];    //商家商品数量
        _sellerName = [dictionary objectForKey:@"sellerName"];        //商家名称
        _label = [dictionary objectForKey:@"label"];             //标签
    }
    return self;
}
@end
