//
//  AfterSaleApplyModel.m
//  CommunityApp
//
//  Created by issuser on 15/8/4.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "AfterSaleApplyModel.h"

@implementation AfterSaleApplyModel
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    
    if(self){
        self.orderId = [dictionary objectForKey:@"orderId"];                //订单ID
        self.goodsId = [dictionary objectForKey:@"goodsId"];                //团购id
        self.afterSalesType = [[dictionary objectForKey:@"afterSalesType"] integerValue];	//售后类型_固定输入2
        self.afterSalesReason = [dictionary objectForKey:@"afterSalesReason"];	//售后原因
        self.returnGoodsNum = [dictionary objectForKey:@"returnGoodsNum"];	//商品数量
        self.refundAmount = [dictionary objectForKey:@"refundAmount"];		//退款金额
        self.details = [dictionary objectForKey:@"details"];	//详情
        self.userId = [dictionary objectForKey:@"userId"];		//客户id
        self.sellerId = [dictionary objectForKey:@"sellerId"];	//商家id
        self.recordId = [dictionary objectForKey:@"recordId"];	//记录id
        self.afterSalesId =[dictionary objectForKey:@"afterSalesId"];	//售后id
        self.afterSalesId =[dictionary objectForKey:@"afterSaleReasonId"];	//售后原因2
 
    }
    
    return self;
}
- (id)init
{
    self = [super init];
    return self;
}
@end





