//
//  APIConfirmRequest.h
//  CommunityApp
//
//  Created by yuntai on 16/5/17.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIRequest.h"
/**提交订单页面查询商品信息接口*/
@interface APIConfirmRequest : APIRequest
- (void)setApiParamsWithGoodIds:(NSString *)goodIds;

@end
