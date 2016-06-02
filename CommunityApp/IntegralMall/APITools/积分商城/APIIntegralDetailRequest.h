//
//  APIIntegralDetailRequest.h
//  CommunityApp
//
//  Created by yuntai on 16/5/17.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIRequest.h"
typedef NS_ENUM(NSUInteger, IntegralDetailType)
{
    
    IntegralDetailTypeAll=0,
    IntegralDetailTypeIncome,
    IntegralDetailTypePayRecord,
    IntegralDetailTypeOutTime,
};

/**积分明细接口*/
@interface APIIntegralDetailRequest : APIRequest
- (void)setApiParamsWithType:(IntegralDetailType )type;
@end
