//
//  AfterSaleApplyModel.h
//  CommunityApp
//
//  Created by issuser on 15/8/4.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"
typedef enum {
    OnlyUnKnown,
    OnlyReturn = 1, //退货
    OnlyRefund,     //退款
    ReturnAndRefund //退货并退款
} AfterSaleType;

@interface AfterSaleApplyModel : BaseModel
@property(nonatomic, copy) NSString *orderId;           //订单ID
@property(nonatomic, copy) NSString *goodsId;			//商品id
@property(nonatomic, assign) AfterSaleType afterSalesType;	//售后类型_固定输入2
@property(nonatomic, copy) NSString *afterSalesReason;	//售后原因
@property(nonatomic, copy) NSString *afterSaleReasonId;	//售后原因2
@property(nonatomic, copy) NSString *returnGoodsNum;	//商品数量
@property(nonatomic, copy) NSString *refundAmount;		//退款金额
@property(nonatomic, copy) NSString *details;			//详情
@property(nonatomic, copy) NSString *userId;			//客户id
@property(nonatomic, copy) NSString *sellerId;			//商家id
@property(nonatomic, copy) NSString *recordId;          //记录id
@property(nonatomic, copy) NSString *afterSalesId;      //售后id
@end
