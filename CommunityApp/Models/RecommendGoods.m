//
//  RecommendGoods.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "RecommendGoods.h"

@implementation RecommendGoods

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        _goodsId = [dictionary objectForKey:@"goodsId"];
        _goodsName = [dictionary objectForKey:@"goodsName"];
        _goodsPrice = [dictionary objectForKey:@"goodsPrice"];
        _goodsPic = [dictionary objectForKey:@"goodsPic"];
    }
    
    return self;
}

@end
