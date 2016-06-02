//
//  CouponsDetail.m
//  CommunityApp
//
//  Created by issuser on 15/7/28.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "CouponsDetail.h"

@implementation CouponsDetail
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    
    if(self){
        self.batchNumber = [dictionary objectForKey:@"batchNumber"];            // 批号
        self.buyNumber = [dictionary objectForKey:@"buyNumber"];                // 购买数量
        self.conditionsPrice = [dictionary objectForKey:@"conditionsPrice"];    // 减免条件
        self.couponsCode = [dictionary objectForKey:@"couponsCode"];            // 编号
        self.cpTitle = [dictionary objectForKey:@"cpTitle"];                    // 标题
        self.cpType = [dictionary objectForKey:@"cpType"];                      // 类型 1.现金券,2:折扣券,3:满减券,4:买赠券
        self.createDate = [dictionary objectForKey:@"createDate"];              // 创建时间
        self.creator = [dictionary objectForKey:@"creator"];                    // 创建人
        self.generateNumber = [dictionary objectForKey:@"generateNumber"];      // 生成张数
        self.preferentialPrice = [dictionary objectForKey:@"preferentialPrice"];// 优惠金额
        self.sellerId = [dictionary objectForKey:@"sellerId"];                  // 商家id,没有表示自营
        self.useDirections = [dictionary objectForKey:@"useDirections"];        // 使用说明
    }
    
    return self;
}
@end
