//
//  APIPrizeMsgReuqest.h
//  CommunityApp
//
//  Created by yuntai on 16/6/3.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIRequest.h"
/**查询奖品信息 加购物车之前*/
@interface APIPrizeMsgReuqest : APIRequest

-(void)setApiParamsWithLog_id:(NSString *)log_id;
@end
