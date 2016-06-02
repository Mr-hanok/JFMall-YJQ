
//
//  JFOrderModel.m
//  CommunityApp
//
//  Created by yuntai on 16/5/19.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFOrderModel.h"

@implementation JFOrderModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.goods = [NSMutableArray array];
    }
    return self;
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goods" : [JFOrderGoodModel class] };
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"oid" : @"id"};
}
@end


@implementation JFOrderGoodModel

@end