//
//  GrouponList.m
//  CommunityApp
//
//  Created by issuser on 15/8/3.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GrouponList.h"

@implementation GrouponList
-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _goodsId = [dictionary objectForKey:@"goodsId"];        //团购id
        _goodsUrl = [dictionary objectForKey:@"goodsUrl"];      //首页图片
        _goodsName = [dictionary objectForKey:@"goodsName"];    //团购名称
        _label = [dictionary objectForKey:@"label"];            //标签
        _goodsPrice = [dictionary objectForKey:@"goodsPrice"];  //市场价
        _goodsActualPrice = [dictionary objectForKey:@"goodsActualPrice"];  //团购价
        // _goodsActualPrice = [dictionary objectForKey:@"goodsId"];        //使用说明
        _groupBuyDetail = [dictionary objectForKey:@"groupBuyDetail"];     //团购详情
        _needAppointment = [dictionary objectForKey:@"needAppointment"];    //是否预约
        _supportBack = [dictionary objectForKey:@"supportBack"];    //是否支持过期退，随时退（1-支持随时退 2-支持过期退 3-都支持 4-都不支持）
        _shopName = [dictionary objectForKey:@"shopName"];      //商铺名
        _totalPage = [dictionary objectForKey:@"totalPage"];    //总页数
        _hasNext = [dictionary objectForKey:@"hasNext"];        //是否有下一页
        
        _sellerId = [dictionary objectForKey:@"sellerId"];      //商家ID
        _groupBuyState = [dictionary objectForKey:@"groupBuyState"];
        _residueStartTime = [dictionary objectForKey:@"residueStartTime"];
        _residueEndTime = [dictionary objectForKey:@"residueEndTime"];
        
        _groupBuyStartTime = [dictionary objectForKey:@"groupBuyStartTime"];
        _groupBuyEndTime = [dictionary objectForKey:@"groupBuyEndTime"];
    }
    return self;
}
@end
