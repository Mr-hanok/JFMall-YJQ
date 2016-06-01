//
//  GrouponOrderSubmitViewController.h
//  CommunityApp
//
//  Created by iss on 8/3/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "GrouponOrder.h"

@interface GrouponOrderSubmitViewController : BaseViewController
@property (strong,nonatomic) GrouponOrder* gpOrder;
@property (nonatomic, retain) UIViewController *groupBuyListVC;
@end
