//
//  APIOrderDelRequest.h
//  CommunityApp
//
//  Created by yuntai on 16/5/20.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIRequest.h"
/**删除订单接口*/
@interface APIOrderDelRequest : APIRequest
- (void)setApiParamsWithOrderId:(NSString *)orderid;
@end
