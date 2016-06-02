//
//  PropertyBillBuildingSelectViewController.h
//  CommunityApp
//
//  Created by iss on 7/17/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseViewController.h"

@interface PropertyBillBuildingSelectViewController : BaseViewController
@property (strong,nonatomic) NSArray* buildingList;
@property (nonatomic, copy) void(^selectBuilding)(NSInteger);
@end
