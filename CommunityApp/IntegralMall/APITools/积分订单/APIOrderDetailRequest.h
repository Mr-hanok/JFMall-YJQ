//
//  APIOrderDetailRequest.h
//  CommunityApp
//
//  Created by yuntai on 16/5/20.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIRequest.h"
/**订单详情接口*/
@interface APIOrderDetailRequest : APIRequest
- (void)setApiParamsWithOrderId:(NSString *)orderid;
@end
