//
//  ApiGoodsInventoryRequest.h
//  CommunityApp
//
//  Created by yuntai on 16/5/12.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIRequest.h"
/**获取商品库存*/
@interface ApiGoodsInventoryRequest : APIRequest
/**
 *  设置请求参数
 *
 *  @param goodId 商品id
 *  @param spec   商品规格id
 */
- (void)setApiParamsWithGoodId:(NSString *)goodId goodsSpec:(NSString *)spec;


@end
