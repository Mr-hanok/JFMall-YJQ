//
//  WaresDetail.h
//  CommunityApp
//
//  Created by issuser on 15/6/19.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"
#import "WaresList.h"

@interface WaresDetail : BaseModel


@property (nonatomic, copy) NSString        *goodsId;           //商品ID
@property (nonatomic, copy) NSString        *goodsType;         //商品类型（1 实物商品， 2 虚拟商品）
@property (nonatomic, copy) NSString        *goodsName;         //商品名称
@property (nonatomic, copy) NSString        *goodsPrice;        //商品原价(实际价格)
@property (nonatomic, copy) NSString        *goodsActualPrice;  //商品实际价格（原价）
@property (nonatomic, copy) NSString        *goodsUrl;          //商品图片，多个用，分开
@property (nonatomic, copy) NSString        *goodsDescription;  //商品文字说明
@property (nonatomic, copy) NSString        *isNewGoods;        //新商品  默认显示，值为1
@property (nonatomic, copy) NSString        *salesGoods;        //促销商品默认显示，值为1
@property (nonatomic, copy) NSString        *service;           //支持服务，多个用，分开
@property (nonatomic, copy) NSString        *sgBrand;           //品牌产地
@property (nonatomic, copy) NSString        *standardModel;     //规格型号
@property (nonatomic, copy) NSString        *totalNumber;       //库存量 ---最新接口不再提供此字段
@property (nonatomic, copy) NSString        *remainCount;       //规格型号下的库存量
@property (nonatomic, copy) NSString        *moduleType;        //模块类型 （1 邻聚街 2 精选商品 3 限时抢 4 商家团购 5跳蚤市场 6到家服务 7普通商品）
@property (nonatomic, copy) NSString        *sellerId;          //商家id，没有，表示为自营
@property (nonatomic, copy) NSString        *supportCoupons;    //支持的优惠类型 1现金券2折扣券3满减券4买赠券
@property (nonatomic, copy) NSString        *deliveryType;      //支持的配送类型

@property (nonatomic, copy) NSString        *evaluations;       //评价
@property (nonatomic, assign) NSInteger       shopGoodsCount;     //商家商品数量
@property (nonatomic, copy) NSString        *sellerName;        //商家名称

@property (nonatomic, copy) NSString        *label;             //标签

@property (nonatomic, copy) NSString        *limitStartTime;    //限时抢开始时间
@property (nonatomic, copy) NSString        *limitEndTime;      //限时抢结束时间

@property (nonatomic, copy) NSString        *selectedStyle;     //选中的规格型号
@property (nonatomic, copy) NSString        *paymentType;       //支付方式，1表示在线支付，2表示货到付款
@property (nonatomic, copy) NSString        *isPutGoods;        //是否上架   0否 1是
@property (nonatomic, copy) NSString        *storeRemainCount;  //库存量

// 首单特价
@property (nonatomic, copy) NSString    *specialOfferStatus;    // 是否特价（1是 0否）
@property (nonatomic, copy) NSString    *specialOfferBuy;       // 是否购买（1是 0否）
@property (nonatomic, copy) NSString    *specialOfferPrice;     // 商品或服务原价
@property (nonatomic, copy) NSString    *sellerPhone;     // 商品或服务原价

-(id)initWithWaresList:(WaresList *)wares;

- (BOOL)isSpecialOfferGoods;

- (BOOL)isHasSpecialOfferRight;

- (BOOL)isSpecialOfferNoRight;

- (CGFloat)calculationTotlePrice;

@end
