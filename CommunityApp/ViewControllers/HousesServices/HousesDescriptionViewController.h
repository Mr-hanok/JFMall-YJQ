//
//  HousesDescriptionViewController.h
//  CommunityApp
//
//  Created by iss on 15/6/30.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"

@interface HousesDescriptionViewController : BaseViewController
@property (nonatomic, copy) void(^selecHouseDescriptBlock)(NSArray*);
@end
