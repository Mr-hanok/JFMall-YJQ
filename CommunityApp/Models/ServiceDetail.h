//
//  ServiceDetail.h
//  CommunityApp
//
//  Created by issuser on 15/6/16.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface ServiceDetail : BaseModel

@property (nonatomic, copy) NSString    *serviceId;         //服务ID
@property (nonatomic, copy) NSString    *serviceName;       //服务名称
@property (nonatomic, copy) NSString    *servicePrice;      //服务价格
@property (nonatomic, copy) NSString    *serviceDesc;       //服务文字说明
@property (nonatomic, copy) NSString    *priceDesc;         //价格文字说明
@property (nonatomic, copy) NSString    *servicePicUrl;     //附件图片URL地址
@property (nonatomic, copy) NSString    *serviceTime;       //预约服务时间

@property (nonatomic, assign)NSInteger  appointmentType;    //预约类型（1为即时;2为预约）

@property (nonatomic, copy) NSString    *payService;        //先服务后付款，先付款后服务
@property (nonatomic, copy) NSString    *paymentType;       //支付方式
@property (nonatomic, copy) NSString    *supportCoupons;    //允许用的券

@end
