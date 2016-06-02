//
//  ExpressTypeModel.m
//  CommunityApp
//
//  Created by issuser on 15/8/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ExpressTypeModel.h"

@implementation ExpressTypeModel
-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _ExpressTypeId = [dictionary objectForKey:@"ExpressTypeId"];        // 快递ID
        _ExpressTypeName = [dictionary objectForKey:@"ExpressTypeName"];    // 快递名称
        _ExpressTypePrice = [dictionary objectForKey:@"ExpressTypePrice"];  // 快递价格
    }
    return self;
}

-(id)initWithArray:(NSArray *)array
{
    self = [super init];
    if (self && array.count == 3) {
        _ExpressTypeId = [array objectAtIndex:0];
        _ExpressTypeName = [array objectAtIndex:1];
        _ExpressTypePrice = [array objectAtIndex:2];
    }
    return self;
}


@end
