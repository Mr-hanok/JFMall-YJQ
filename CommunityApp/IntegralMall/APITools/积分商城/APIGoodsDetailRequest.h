//
//  APIGoodsDetailRequest.h
//  CommunityApp
//
//  Created by yuntai on 16/5/10.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIRequest.h"
/**
 *  商品详情
 */
@interface APIGoodsDetailRequest : APIRequest
- (void)setApiParamsWithGoodsId:(NSString *)goodid;
@end
