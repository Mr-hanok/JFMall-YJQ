//
//  AfterSaleDetail.h
//  CommunityApp
//
//  Created by issuser on 15/7/28.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface AfterSaleDetail : BaseModel
@property (copy, nonatomic) NSString *afterSalesId;       //售后ID
@property (copy, nonatomic) NSString *afterSalesStateId;  //售后状态ID
@property (copy, nonatomic) NSString *afterSalesStateName;//售后状态名称
@property (copy, nonatomic) NSString *afterSalesTypeId;   //售后类型ID
@property (copy, nonatomic) NSString *afterSalesTypeName; //售后类型名称
@property (copy, nonatomic) NSString *afterSalesReason;   //售后原因
@property (copy, nonatomic) NSString *afterSaleReasonId;  //售后原因ID
@property (copy, nonatomic) NSString *refundAmount;       //退款金额
@property (copy, nonatomic) NSString *details;            //详情说明
@property (copy, nonatomic) NSString *afterSaleNum;       //退款数量
@property (copy, nonatomic) NSString *latestActionTitle;  //最新的动作标题
@property (copy, nonatomic) NSString *allTicketsNum;      //团购券ID
@property (copy, nonatomic) NSString *sellerShop;         //商家
@property (copy, nonatomic) NSString *attachments;         //图片
@end
