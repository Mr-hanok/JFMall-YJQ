//
//  PersonalCenterMyOrderTrackViewController.h
//  CommunityApp
//
//  Created by iss on 6/10/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "MyOrderType.h"

@interface PersonalCenterMyOrderTrackViewController : BaseViewController
-(void)initData:(NSString*)orderId orderNum:(NSString*)orderNum orderState:(NSString*)orderState orderType:(OrderTypeEnum)orderType;
@end
