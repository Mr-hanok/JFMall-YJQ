//
//  MyPostRepairFollowViewController.h
//  CommunityApp
//
//  Created by iss on 15/6/15.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderTrackModel.h"
#import "MyPostRepair.h"

@interface MyPostRepairFollowViewController : BaseViewController

@property (strong,nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, retain) MyPostRepair *data;
    
@end
