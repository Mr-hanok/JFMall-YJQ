//
//  CouponsDetail.h
//  CommunityApp
//
//  Created by issuser on 15/7/28.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface CouponsDetail : BaseModel
@property (copy,nonatomic) NSString *batchNumber;       // 批号
@property (copy,nonatomic) NSString *buyNumber;         // 购买数量
@property (copy,nonatomic) NSString *conditionsPrice;   // 减免条件
@property (copy,nonatomic) NSString *couponsCode;       // 编号
@property (copy,nonatomic) NSString *cpTitle;           // 标题
@property (copy,nonatomic) NSString *cpType;            // 类型 1.现金券,2:折扣券,3:满减券,4:买赠券
@property (copy,nonatomic) NSString *createDate;        // 创建时间
@property (copy,nonatomic) NSString *creator;           // 创建人
@property (copy,nonatomic) NSString *generateNumber;    // 生成张数
@property (copy,nonatomic) NSString *preferentialPrice; // 优惠金额
@property (copy,nonatomic) NSString *sellerId;          // 商家ID，没有表示自营
@property (copy,nonatomic) NSString *useDirections;     // 使用说明
@end
