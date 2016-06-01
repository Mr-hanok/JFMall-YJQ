//
//  WaresList.h
//  CommunityApp
//
//  Created by issuser on 15/6/19.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface WaresList : BaseModel

@property (nonatomic, copy) NSString        *goodsId;           //商品ID
@property (nonatomic, copy) NSString        *goodsName;         //商品名
@property (nonatomic, copy) NSString        *goodsPrice;        //商品价格
@property (nonatomic, copy) NSString        *goodsActualPrice;  //商品实际价格
@property (nonatomic, copy) NSString        *goodsUrl;          //商品图片地址
@property (nonatomic, copy) NSString        *goodsDescription;  //商品文字说明
@property (nonatomic, copy) NSString        *limitStartTime;    //限时抢开始时间
@property (nonatomic, copy) NSString        *limitEndTime;      //限时抢结束时间
@property (nonatomic, copy) NSString        *currTime;          //当前时间
@property (nonatomic, copy) NSString        *currPage;          //当前页码
@property (nonatomic, copy) NSString        *pageSize;          //页面条数
@property (nonatomic, copy) NSString        *totalPage;         //总页数
@property (nonatomic, copy) NSString        *hasNext;           //是否有下一页
@property (nonatomic, copy) NSString        *sellerId;          //商家id可能没有，表示为自营

@property (nonatomic, copy) NSString        *totalNumber;       //商品销量
@property (nonatomic, copy) NSString        *isNewGoods;        //是否是新品（1，表示是；0表示不是）
@property (nonatomic, copy) NSString        *isSalesGoods;      //是否是促销商品（1，表示是；0表示不是）
@property (nonatomic, copy) NSString        *sellerName;        //商家名称
@property (nonatomic, copy) NSString        *shopGoodsCount;    //商家商品数量
@property (nonatomic, copy) NSString        *sgBrand;           //品牌名称
@property (nonatomic, copy) NSString        *standardModel;     //规格型号
@property (nonatomic, copy) NSString        *supportCoupons;    //支持的优惠类型 1现金券2折扣券3满减券4买赠券
@property (nonatomic, copy) NSString        *deliveryType;      //支持的配送类型
@property (nonatomic, copy) NSString        *moduleType;        //商品所属模块

@property (nonatomic, copy) NSString    *specialOfferStatus;    // 是否特价（1是 0否）
@property (nonatomic, copy) NSString    *specialOfferBuy;       // 是否购买（1是 0否）
@property (nonatomic, copy) NSString    *specialOfferPrice;     // 商品或服务原价

- (BOOL)isSpecialOfferGoods;
- (BOOL)isHasSpecialOfferRight;
- (BOOL)isSpecialOfferNoRight;

@end



@interface GoodWaresList : BaseModel

@property (nonatomic, copy) NSString    *gcName;        //分类名称
@property (nonatomic, copy) NSString    *gcId;          //分类ID
@property (nonatomic, copy) NSString    *clientShow;    //分类级别标签
@property (nonatomic, copy) NSString    *goodsUrl;      //分类图片
@property (nonatomic, retain) NSMutableArray    *goodsList; //商品列表

@end





