//
//  APImOrderSubmitRequest.h
//  CommunityApp
//
//  Created by yuntai on 16/5/17.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIRequest.h"
/**提交订单请求*/
@interface APIOrderSubmitRequest : APIRequest

-(void)setApiParamsWithGoodIds:(NSString *)goodIds
                  cart_session:(NSString *)cart_session
                          name:(NSString *)name
                        mobile:(NSString *)mobile
                       address:(NSString *)address
                        log_id:(NSString *)log_id
                    order_flag:(NSString *)order_flag;
@end
