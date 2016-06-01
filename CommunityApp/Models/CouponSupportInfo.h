//
//  CouponSupportInfo.h
//  CommunityApp
//
//  Created by 酒剑 笛箫 on 15/9/7.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface CouponSupportInfo : BaseModel

@property (nonatomic, copy) NSString *spSupport;    //商品
@property (nonatomic, copy) NSString *fwSupport;    //服务
@property (nonatomic, copy) NSString *tgSupport;    //团购

@end
