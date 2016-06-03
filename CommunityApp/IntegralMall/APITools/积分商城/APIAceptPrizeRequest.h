//
//  APIAceptPrizeRequest.h
//  CommunityApp
//
//  Created by yuntai on 16/6/3.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIRequest.h"
/**接受奖品接口*/
@interface APIAceptPrizeRequest : APIRequest
-(void)setApiParamsWithLog_id:(NSString *)log_id;
@end
