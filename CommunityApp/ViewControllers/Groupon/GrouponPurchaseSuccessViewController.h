//
//  GrouponPurchaseSuccessViewController.h
//  CommunityApp
//
//  Created by issuser on 15/7/23.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "GrouponTicket.h"

@interface GrouponPurchaseSuccessViewController : BaseViewController
@property (strong,nonatomic) GrouponTicket* grouponTicket;

@property (nonatomic, retain) UIViewController *groupBuyListVC;

@end
