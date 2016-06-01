//
//  JFGoodsInfoModel.m
//  CommunityApp
//
//  Created by yuntai on 16/4/21.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFGoodsInfoModel.h"

@implementation JFGoodsInfoModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isEdite = NO;
        self.isSelect = NO;
    }
    return self;
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"goodsId"      : @"id",
             @"goodsIntegral":@"price",
             @"goodsNum"     :@"count"
             };
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    JFGoodsInfoModel *model = [JFGoodsInfoModel yy_modelWithDictionary:dict];
    return  model;
}
@end
