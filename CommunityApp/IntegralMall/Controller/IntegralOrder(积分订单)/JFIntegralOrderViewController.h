//
//  JFIntegralOrderViewController.h
//  CommunityApp
//
//  Created by yuntai on 16/5/3.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFBaseViewController.h"
typedef NS_ENUM(NSUInteger, OrderSlideType)
{
    
    OrderSlideTypeAll=101,
    OrderSlideTypeSend,
    OrderSlideTypeReceive,
    OrderSlideTypeComplete,
};
/**积分订单页面*/
@interface JFIntegralOrderViewController : JFBaseViewController

@end
