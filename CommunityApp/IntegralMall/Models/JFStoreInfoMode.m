//
//  JFStoreInfoMode.m
//  CommunityApp
//
//  Created by yuntai on 16/4/22.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFStoreInfoMode.h"

@implementation JFStoreInfoMode
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.goodsArray = [NSMutableArray array];
    }
    return self;
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"storeid"      : @"id",
             @"storeName"    :@"store_name",
             @"goodsArray"   :@"gcs",
             @"goodsNum"     :@"count",
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goodsArray" : [JFGoodsInfoModel class] };
}

+ (JFStoreInfoMode *)initModelWithDic:(NSDictionary *)dic{
    JFStoreInfoMode *model = [JFStoreInfoMode yy_modelWithDictionary:dic];
    model.isSelect = NO;
    model.isEdite = NO;
    model.goodsNum = model.goodsArray.count;
    return model;
    
}

+ (JFStoreInfoMode *)initModelWithDic:(NSDictionary *)dic isEdite:(BOOL)isEdite{
    JFStoreInfoMode *model = [JFStoreInfoMode yy_modelWithDictionary:dic];
    model.isSelect = NO;
    model.isEdite = isEdite;
    model.goodsNum = model.goodsArray.count;
    if (model.isEdite) {
        for (JFGoodsInfoModel *m in model.goodsArray) {
            m.isEdite = YES;
        }
    }
    return model;

}
@end
