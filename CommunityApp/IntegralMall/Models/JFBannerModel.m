//
//  JFBannerModel.m
//  CommunityApp
//
//  Created by yuntai on 16/5/10.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFBannerModel.h"

@implementation JFBannerModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.jump_url = @"";
    }
    return self;
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"kid" : @"id"};
}
+ (JFBannerModel *)initModelWith:(NSDictionary *)dic{
    JFBannerModel *model = [JFBannerModel yy_modelWithDictionary:dic];
    model.jump_url = [ValueUtils stringFromObject:model.jump_url];
    return model;
}
@end
