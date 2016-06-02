//
//  GrouponOrder.h
//  CommunityApp
//
//  Created by issuser on 15/8/12.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface GrouponOrder : BaseModel

@property (nonatomic, copy) NSString *goodsName;//团购名称
@property (nonatomic, copy) NSString *creator;  //下单人姓名
@property (nonatomic, copy) NSString *linkName; //联系人
@property (nonatomic, copy) NSString *linkTel;  //联系电话
@property (nonatomic, copy) NSString *goodsIds; //（商品Id：团购单价：团购数量）
@property (nonatomic, copy) NSString *ownerid;  //下单人ID
@property (nonatomic, copy) NSString *sellerId; //商家ID
@property (nonatomic, copy) NSString *totalMoney;   //团购金额
@property (nonatomic, copy) NSString *couponsId;    //优惠券ID
@property (nonatomic, copy) NSString *couponsMoney; //优惠金额
@property (nonatomic, copy) NSString *payMoney;     //实际支付金额
@property (nonatomic, copy) NSString *groupBuyEndTime;  //团购结束时间

@end
