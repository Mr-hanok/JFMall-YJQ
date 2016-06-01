//
//  BillListModel.h
//  CommunityApp
//
//  Created by issuser on 15/7/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface BillListModel : BaseModel

@property (nonatomic, copy) NSString    *receivableId;      // 账款ID（应收账款ID）
@property (nonatomic, copy) NSString    *fiName;            // 费项名称
@property (nonatomic, copy) NSString    *billDate;          // 账单日期
@property (nonatomic, copy) NSString    *receivable;        // 应收账款(本期费用)
@property (nonatomic, copy) NSString    *settlementStatus;  // 结算状态(1-已结算，0-未结算)----物业缴费详情界面
@property (nonatomic, copy) NSString    *billType;// 结算状态(1-已结算，0-未结算)---物业缴费界面
@end
