//
//  GrouponTicket.h
//  CommunityApp
//
//  Created by issuser on 15/7/16.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"
@interface ticketModel:BaseModel
@property (copy, nonatomic) NSString *ticketId ;//   团购券
@property (copy, nonatomic) NSString *ticketNo ;//    团购券号
@property (copy, nonatomic) NSString *ticketStatus ;//   状态(0未使用  1已使用)
@property (copy, nonatomic) NSString *isRefundTicket;//   是否可以退款(0否 1是)
@property (copy, nonatomic) NSString *refundState;  // 退款状态

@property (nonatomic, assign) BOOL   isSelected;    // 是否选中 NO:未选中；YES:选中
@end
@interface GrouponTicket : BaseModel

@property (copy, nonatomic) NSString *orderId ;//  订单Id
@property (copy, nonatomic) NSString *orderNum ;// 订单号
@property (copy, nonatomic) NSString *userId ;// 用户ID
@property (copy, nonatomic) NSString *address ;//  地址
@property (copy, nonatomic) NSString *linkName ;// 联系人名称
@property (copy, nonatomic) NSString *linkTel ;// 联系人电话
@property (copy, nonatomic) NSString *goodsId ;// 商品Id
@property (copy, nonatomic) NSString *gbTickets;// 团购券详情 JSONArray  map形式
@property (strong, nonatomic) NSMutableArray *ticketsList;
//	ticketId    团购券
//	ticketNo    团购券号
//	ticketStatus   状态(0未使用  1已使用)
//	isRefundTicket  是否可以退款(0否 1是)
@property (copy, nonatomic) NSString *gbTitle;// 团购标题
@property (copy, nonatomic) NSString *totalMoney;//  订单总价
@property (copy, nonatomic) NSString *couponsMoney ;//  优惠金额
@property (copy, nonatomic) NSString *payMoney ;//  实际支付金额
@property (copy, nonatomic) NSString *needAppointment ;//  需要预约 0否 1:是
@property (copy, nonatomic) NSString *expDate ;//  有效期至
@property (copy, nonatomic) NSString *isRefund;// 是否可以退款(0不可以 1可以)
@property (copy, nonatomic) NSString *quantity ;//  数量
@property (copy, nonatomic) NSString *createDate;//  下单日期
@property (copy, nonatomic) NSString *orderStatus ;//  订单状态
@property (copy, nonatomic) NSString *supportBackAtAll ;//  支持随时退 0否 1:是
@property (copy, nonatomic) NSString *supportBackAtPast ;//  支持过期退 0否 1:是
@property (copy, nonatomic) NSString *quantityRefund ;// 可退团购券数量

@property (copy, nonatomic) NSString *sellerId;     // 商家ID

@property (copy, nonatomic) NSString *gbUrl;        //团购图片Url

@end
