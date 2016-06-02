//
//  AfterSaleDetail.m
//  CommunityApp
//
//  Created by issuser on 15/7/28.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "AfterSaleDetail.h"

@implementation AfterSaleDetail
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    
    if(self){
        self.afterSalesId = [dictionary objectForKey:@"afterSalesId"];  //售后ID
        self.afterSalesStateId = [dictionary objectForKey:@"afterSalesStateId"];    //售后状态ID
        self.afterSalesStateName = [dictionary objectForKey:@"afterSalesStateName"];//售后状态名称
        self.afterSalesTypeId = [dictionary objectForKey:@"afterSalesTypeId"];      //售后类型ID
        self.afterSalesTypeName = [dictionary objectForKey:@"afterSalesTypeName"];  //售后类型名称
        self.afterSalesReason = [dictionary objectForKey:@"afterSalesReason"];      //售后原因
        self.afterSaleReasonId = [dictionary objectForKey:@"afterSaleReasonId"];    //售后原因ID
        self.refundAmount = [dictionary objectForKey:@"refundAmount"];  //退款金额
        self.details = [dictionary objectForKey:@"details"];    //详情说明
        self.afterSaleNum = [dictionary objectForKey:@"afterSaleNum"];       //退款数量
        self.latestActionTitle = [dictionary objectForKey:@"latestActionTitle"];  //最新的动作标题
        self.allTicketsNum = [dictionary objectForKey:@"allTicketsNum"];
        self.sellerShop = [dictionary objectForKey:@"sellerShop"];
        self.attachments = [dictionary objectForKey:@"attachments"];

    }
    
    return self;
}

@end
