//
//  APIOrderCancalRequest.h
//  CommunityApp
//
//  Created by yuntai on 16/5/20.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIRequest.h"
/**取消订单请求*/
@interface APIOrderCancalRequest : APIRequest
- (void)setApiParamsWithOrderId:(NSString *)orderid;
@end
