//
//  GrouponDetailViewController.h
//  CommunityApp
//
//  Created by issuser on 15/7/16.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "GrouponList.h"

@interface GrouponDetailViewController : BaseViewController
@property (nonatomic, copy) NSString *grouponId;

@property (nonatomic, retain) UIViewController *groupBuyListVC;
@end
