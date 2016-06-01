//
//  GoodsComment.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/9.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GoodsComment.h"

@implementation GoodsComment

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        _userPic = [dictionary objectForKey:@"userPic"];
        _userName = [dictionary objectForKey:@"userName"];
        _grade = [dictionary objectForKey:@"grade"];
        _goodsPrice = [dictionary objectForKey:@"goodsPrice"];
        _date = [dictionary objectForKey:@"date"];
        _desc = [dictionary objectForKey:@"desc"];
        _goodsPic = [dictionary objectForKey:@"goodsPic"];

    }
    
    return self;
}

@end
