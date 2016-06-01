//
//  PersonalCenterMyOrderViewController.h
//  CommunityApp
//
//  Created by iss on 6/9/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "MyOrderType.h"

@interface PersonalCenterMyOrderViewController : BaseViewController
@property (assign,nonatomic) OrderTypeEnum orderType;
////
@property (strong,nonatomic)NSString *orderstr;
@end
