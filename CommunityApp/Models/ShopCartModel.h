//
//  ShopCartModel.h
//  CommunityApp
//
//  Created by issuser on 15/6/30.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface ShopCartModel : BaseModel

extern NSString *const kPaymentTypeOnline;  /**< 在线支付 */
extern NSString *const kPaymentTypeOffline; /**< 货到付款 */

@property (nonatomic, assign)   NSInteger    cartId;            // 购物车ID
@property (nonatomic, assign)   NSInteger    type;              // 购物车内容类型 0-商品；1-服务
@property (nonatomic, copy) NSString         *goodsType;        // 商品类型（1 实物商品， 2 虚拟商品）
@property (nonatomic, copy)     NSString     *wsId;             // 商品id 或 服务id
@property (nonatomic, copy)     NSString     *wsName;           // 商品或服务名
@property (nonatomic, assign)   NSInteger    count;             // 商品数量
@property (nonatomic, copy)     NSString     *originalPrice;    // 商品或服务原价
@property (nonatomic, copy)     NSString     *currentPrice;     // 商品或服务现价
@property (nonatomic, copy)     NSString     *picUrl;           // 图片URL
@property (nonatomic, copy)     NSString     *supportService;   // 支持服务
@property (nonatomic, copy)     NSString     *serviceTime;      // 预约服务时间type为即时，时间半小时的时间，type为预约；都是时间为标准时间的字符串形式）
@property (nonatomic, copy) NSString        *moduleType;        //模块类型 （1 邻聚街 2 精选商品 3 限时抢 4 商家团购 5跳蚤市场 6到家服务 7普通商品）
@property (nonatomic, copy)     NSString     *intoCartTime;     // 商品加入购物车时间

@property (nonatomic, assign)   NSInteger    appointmentType;   // 预约类型（1为即时;2为预约）

@property (nonatomic, copy)     NSString     *materials;        // 订单材料(id:number,id:numer,….)

@property (nonatomic, assign)   BOOL         isSelected;        // 是否为选中状态（checkbox）

@property (nonatomic, copy)     NSString     *sellerId;         // 商家ID

@property (nonatomic, copy)     NSString     *sellerName;       // 商家名称

@property (nonatomic, copy)     NSString     *deliveryType;     // 配送方式 例如：1@ebei@客户自提@ebei@0.1,2@ebei@送货上门@ebei@0.2

@property (nonatomic, copy)     NSString     *waresStyle;       // 商品规格型号

@property (nonatomic, copy)     NSString     *projectId;        // 项目id
@property (nonatomic, copy)     NSString     *sgBrand;          // 品牌名称
@property (nonatomic, copy)     NSString     *supportCoupons;   // 支持的优惠券
@property (nonatomic, copy)     NSString     *paymentType;      //支持的支付方式，1：在线支付，2：货到付款，多个用‘，’隔开
@property (nonatomic, copy)     NSString     *isPutGoods;       /**< 是否上架   0否 1是 */
@property (nonatomic, copy)     NSString     *storeRemainCount; /**< 可用库存数量 */

// 首单特价
@property (nonatomic, copy)   NSString    *specialOfferStatus;    // 是否特价（1是 0否）
@property (nonatomic, copy)   NSString    *specialOfferBuy;       // 是否购买（1是 0否）
@property (nonatomic, copy)   NSString    *specialOfferPrice;   // 商品或服务原价

@property (nonatomic, assign) BOOL isAbandonSpecialOfferUseRight;       // 是否放弃特价使用权利（基于同种商品的互斥原则，有的商品即使是特价，也不能使用）

- (CGFloat)calculationTotlePrice;
- (BOOL)isSpecialOfferGoods;
- (BOOL)isHasSpecialOfferRight;
- (BOOL)isUseSpecialOfferRight;
+ (void)resetSpecialOfferUseRight:(NSArray *)models;// 重置互斥特价商品使用状态（基于同种商品的互斥原则，有的商品即使是特价，也不能使用）
+ (CGFloat)calculationPrice:(NSArray *)models;
+ (CGFloat)calculationSpecialOfferPrice:(NSArray *)models;
+ (BOOL)isUseSpecialOffer:(NSArray *)models;
+ (BOOL)isHasSpecialOffer:(NSArray *)models;
+ (int)specialOffeCount:(NSArray *)models;
+ (BOOL)isSpecialOfferNoRight:(NSArray *)models;

@end
