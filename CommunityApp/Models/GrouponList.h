//
//  GrouponList.h
//  CommunityApp
//
//  Created by issuser on 15/8/3.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface GrouponList : BaseModel

@property (nonatomic, copy) NSString    *goodsId;           //团购id
@property (nonatomic, copy) NSString    *goodsUrl;          //首页图片
@property (nonatomic, copy) NSString    *goodsName;         //团购名称
@property (nonatomic, copy) NSString    *label;             //标签
@property (nonatomic, copy) NSString    *goodsPrice;        //市场价
@property (nonatomic, copy) NSString    *goodsActualPrice;  //团购价
// @property (nonatomic, copy) NSString    *goodsActualPrice;		//使用说明
@property (nonatomic, copy) NSString    *groupBuyDetail;    //团购详情
@property (nonatomic, copy) NSString    *needAppointment;   //是否预约
@property (nonatomic, copy) NSString    *supportBack;       //是否支持过期退，随时退（1-支持随时退 2-支持过期退 3-都支持 4-都不支持）
@property (nonatomic, copy) NSString    *shopName;			//商铺名
@property (nonatomic, copy) NSString    *totalPage;         //总页数
@property (nonatomic, copy) NSString    *hasNext;           //是否有下一页
@property (nonatomic, copy) NSString    *sellerId;          //商家ID

@property (nonatomic, copy) NSString    *groupBuyState;     //团购状态 1.已开始  2.已结束 3.未开始
@property (nonatomic, copy) NSString    *residueStartTime;  //团购剩余开始时间 (天，时，分，秒)
@property (nonatomic, copy) NSString    *residueEndTime;    //团购剩余结束时间 (天，时，分，秒)

@property (nonatomic ,copy) NSString    *groupBuyStartTime; //团购开始时间
@property (nonatomic ,copy) NSString    *groupBuyEndTime;   //团购结束时间

@end
