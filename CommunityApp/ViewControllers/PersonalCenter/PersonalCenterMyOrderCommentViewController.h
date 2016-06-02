//
//  PersonalCenterMyOrderCommentViewController.h
//  CommunityApp
//
//  Created by iss on 8/6/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderModel.h"
#import "MyOrderType.h"

@interface PersonalCenterMyOrderCommentViewController : BaseViewController
@property (copy,nonatomic) NSString* orderId;
@property (assign,nonatomic) OrderTypeEnum orderType;
@end
