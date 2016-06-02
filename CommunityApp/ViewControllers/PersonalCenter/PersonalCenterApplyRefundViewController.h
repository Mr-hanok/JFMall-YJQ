//
//  PersonalCenterApplyRefundViewController.h
//  CommunityApp
//
//  Created by iss on 7/16/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "GrouponTicket.h"


@interface PersonalCenterApplyRefundViewController : BaseViewController

@property (nonatomic, retain) NSArray   *selectedTicketsArray;

@property (nonatomic, retain) GrouponTicket     *grouponTicket;

@property (nonatomic, copy) NSString    *refundMoney;

@end
