//
//  GroupBuyDetail.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/16.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface GroupBuyDetail : BaseModel

@property (nonatomic, copy) NSString    *goodsUrl;          //商品图片
@property (nonatomic, copy) NSString    *goodsDescription;  //使用说明
@property (nonatomic, copy) NSString    *goodsName;         //团购名称
@property (nonatomic, copy) NSString    *goodsPrice;        //团购金额
@property (nonatomic, copy) NSString    *groupBuyDetail;    //团购详情
@property (nonatomic, copy) NSString    *label;             //标签
@property (nonatomic, copy) NSString    *needAppointment;   //是否预约 0否 1是
@property (nonatomic, copy) NSString    *supportBack;       //是否支持过期退，随时退（1-支持随时退 2-					支持过期退 3-都支持 4-都不支持）
@property (nonatomic, copy) NSString    *shopName;          //名称,地址,电话 (以”,”分隔)
@property (nonatomic, copy) NSString    *details;           //图文详情
@property (nonatomic ,copy) NSString    *goodsActualPrice;  //商品市场价格
@property (nonatomic ,copy) NSString    *groupBuyStartTime; //团购开始时间
@property (nonatomic ,copy) NSString    *groupBuyEndTime;   //团购结束时间
@property (nonatomic, copy) NSString    *isFavorites;       //是否收藏
@property (nonatomic, copy) NSString    *supportCoupons;    //是否支持优惠券
@property (nonatomic, copy) NSString    *sellerId;          //商户ID

@end
