//
//  GrouponTicket.m
//  CommunityApp
//
//  Created by issuser on 15/7/16.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GrouponTicket.h"
@implementation ticketModel
-(id)initWithDictionary:(NSDictionary *)dictionary
{
    
    self = [super initWithDictionary:dictionary];
    if (self != nil) {
        _ticketId = [dictionary objectForKey:@"ticketId"];
        _ticketNo = [dictionary objectForKey:@"ticketNo"];
        _ticketStatus = [dictionary objectForKey:@"ticketStatus"];
        _isRefundTicket = [dictionary objectForKey:@"isRefundTicket"];
    }
    return self;
 
}
@end
@implementation GrouponTicket
-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self != nil) {
        _orderId = [dictionary objectForKey:@"orderId"];
        _orderNum= [dictionary objectForKey:@"orderNum"];
        _userId = [dictionary objectForKey:@"userId"];
        _address = [dictionary objectForKey:@"address"];
        _linkName = [dictionary objectForKey:@"linkName"];
        _linkTel = [dictionary objectForKey:@"linkTel"];
        _goodsId = [dictionary objectForKey:@"goodsId"];
        _gbTickets = [dictionary objectForKey:@"gbTickets"];
        //	ticketId    团购券
        //	ticketNo    团购券号
        //	ticketStatus   状态(0未使用  1已使用)
        //	isRefundTicket  是否可以退款(0否 1是)
        _gbTitle = [dictionary objectForKey:@"gbTitle"];
        _totalMoney = [dictionary objectForKey:@"totalMoney"];
        _couponsMoney = [dictionary objectForKey:@"couponsMoney"];
        _payMoney = [dictionary objectForKey:@"payMoney"];
        _needAppointment = [dictionary objectForKey:@"needAppointment"];
        _expDate = [dictionary objectForKey:@"expDate"];
        _isRefund = [dictionary objectForKey:@"isRefund"];
        _quantity = [dictionary objectForKey:@"quantity"];
        _createDate= [dictionary objectForKey:@"createDate"];
        _orderStatus = [dictionary objectForKey:@"orderStatus"];
        _supportBackAtAll = [dictionary objectForKey:@"supportBackAtAll"];
        _supportBackAtPast = [dictionary objectForKey:@"supportBackAtPast"];
        _quantityRefund= [dictionary objectForKey:@"quantityRefund"];
        _sellerId = [dictionary objectForKey:@"sellerId"];
        [self paraseTickets];
    }
    return self;
}
-(void)paraseTickets
{
    _ticketsList = [[NSMutableArray alloc]init];
    NSString* tickets = [_gbTickets copy];
    NSRange rang = {1,tickets.length-2};
    NSString* ticketsString  = [[tickets substringWithRange:rang] copy];//remove"[]"
    NSArray* ticketsArray = [ticketsString componentsSeparatedByString:@"}"];
    NSInteger loop = 0;
    for (NSString* ticket in ticketsArray) {
        if([ticket isEqualToString:@""])
            break;
      
        NSMutableDictionary* objDic = [[NSMutableDictionary alloc]init];
        NSString *strTemp = [ticket stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSInteger clip = 1;
        if (loop>0) {
            clip = 2;
        }
        NSRange rang = {clip,strTemp.length-clip};
        NSString* ticketString  = [[strTemp substringWithRange:rang] copy];//remove"{}"
        NSArray* ticketInfo = [ticketString componentsSeparatedByString:@","];
        for (NSString * string in ticketInfo) {
            NSArray* dic = [string componentsSeparatedByString:@":"] ;
            NSString* key = [dic objectAtIndex:0];
            NSString* value = [dic objectAtIndex:1];
            [objDic setObject:value.copy forKey:key.copy];
            
        }
        ticketModel*  Model = [[ticketModel alloc]initWithDictionary:objDic];
        [_ticketsList addObject:Model];
        loop++;
    }

    
}
@end
