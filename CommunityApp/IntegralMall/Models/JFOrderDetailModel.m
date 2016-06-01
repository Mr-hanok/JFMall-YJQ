//
//  JFOrderDetailModel.m
//  CommunityApp
//
//  Created by yuntai on 16/5/20.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFOrderDetailModel.h"

@implementation JFOrderDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"gcs" : [JFOrderDetailGoodsModel class] };
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"oid" : @"id"};
}
@end


@implementation JFOrderDetailGoodsModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"gid" : @"id"};
}
@end