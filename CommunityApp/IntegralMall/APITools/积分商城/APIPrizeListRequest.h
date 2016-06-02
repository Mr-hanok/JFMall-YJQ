//
//  APIPrizeListRequest.h
//  CommunityApp
//
//  Created by yuntai on 16/6/2.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIRequest.h"
/**中奖纪录接口*/
@interface APIPrizeListRequest : APIRequest
-(void)setApiParamsWithActivity_type:(NSString *)activity_type;
@end
