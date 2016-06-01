//
//  LimitBuySelector.m
//  CommunityApp
//
//  Created by issuser on 15/8/20.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "LimitBuySelector.h"

@implementation LimitBuySelector

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        _categoryId = [dictionary objectForKey:@"categoryId"];
        _categoryName = [dictionary objectForKey:@"categoryName"];
        _isSelected = [dictionary objectForKey:@"isSelected"];
    }

    return self;
}

@end
