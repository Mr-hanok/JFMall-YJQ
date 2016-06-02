//
//  JFGoodsDetail.m
//  CommunityApp
//
//  Created by yuntai on 16/5/11.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFGoodsDetailModel.h"

#pragma mark - JFGoodsDetailModel
@implementation JFGoodsDetailModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.goods_specs = [NSMutableArray array];
        self.goods_photos = [NSMutableArray array];
    }
    return self;
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goods_specs" : [JFGoodsSpec class] };
}
+ (JFGoodsDetailModel *)initJFGoodsDetailModellWith:(NSDictionary *)dic{
    JFGoodsDetailModel *model = [JFGoodsDetailModel yy_modelWithDictionary:dic];
    model.goods_price = [ValueUtils stringFromObject:model.goods_price];
    model.store_price = [ValueUtils stringFromObject:model.store_price];
    return model;
}

@end

#pragma mark - JFGoodsSpec
@implementation JFGoodsSpec

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.gsps = [NSMutableArray array];
    }
    return self;
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"specId" : @"id"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"gsps" : [JFGoodsGsp class] };
}
@end

#pragma mark - JFGoodsGsp
@implementation JFGoodsGsp
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"gspId" : @"id"};
}
@end
