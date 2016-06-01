//
//  APIOrderConfirmRequest.h
//  CommunityApp
//
//  Created by yuntai on 16/5/20.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIRequest.h"
/**确认收货请求*/
@interface APIOrderConfirmRequest : APIRequest
- (void)setApiParamsWithOrderId:(NSString *)orderid;
@end
