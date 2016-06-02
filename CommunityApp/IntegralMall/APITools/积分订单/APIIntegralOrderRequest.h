//
//  APIIntrgralOrderRequest.h
//  CommunityApp
//
//  Created by yuntai on 16/5/19.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIRequest.h"
/**积分订单列表请求*/
@interface APIIntegralOrderRequest : APIRequest
- (void)setApiParamsWithType:(NSString *)type;
@end
