//
//  PaymentHistoryModel.h
//  CommunityApp
//
//  Created by issuser on 15/7/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface PaymentHistoryModel : BaseModel

@property (nonatomic, copy) NSString    *payMentAmount;     // 缴费金额
@property (nonatomic, copy) NSString    *payMentDate;       // 缴费时间（yyyy-MM-dd）
@property (nonatomic, copy) NSString    *paymentTypeName;   // 缴费方式（名称）
@property (nonatomic, copy) NSString    *state;             // 状态（1：未确认 2：已确认 3：已结算）


@end
