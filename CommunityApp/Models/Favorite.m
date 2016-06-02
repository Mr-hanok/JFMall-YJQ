//
//  Favorite.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "Favorite.h"

@implementation Favorite

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        _goodsId = [dictionary objectForKey:@"goodsId"];
        _goodsName = [dictionary objectForKey:@"goodsName"];
        _picUrl = [dictionary objectForKey:@"picUrl"];
        _salePrice = [dictionary objectForKey:@"salePrice"];
    }
    
    return self;
}

@end
