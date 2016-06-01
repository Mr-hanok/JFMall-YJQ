//
//  JFCategorysModel.m
//  CommunityApp
//
//  Created by yuntai on 16/5/10.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFCategorysModel.h"

@implementation JFCategorysModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.goodsList = [NSMutableArray array];
    }
    return self;
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goodsList" : [JFHomeGoodsModel class] };
}
+ (JFCategorysModel *)initJFCategorysModelWith:(NSDictionary *)dic{
    JFCategorysModel *model = [JFCategorysModel yy_modelWithDictionary:dic];
    return model;
}
@end



@implementation JFHomeGoodsModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"goodsId" : @"id"};
}
@end