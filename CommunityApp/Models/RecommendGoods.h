//
//  RecommendGoods.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface RecommendGoods : BaseModel


@property (nonatomic, copy) NSString    *goodsId;
@property (nonatomic, copy) NSString    *goodsName;
@property (nonatomic, copy) NSString    *goodsPrice;
@property (nonatomic, copy) NSString    *goodsPic;

@end
