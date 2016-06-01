//
//  PersonalCenterCustomerClassViewController.h
//  CommunityApp
//
//  Created by iss on 6/8/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseViewController.h"

@interface PersonalCenterCustomerClassViewController : BaseViewController

@property(nonatomic, copy) void(^personalCenterResult)(NSString*);
@property(nonatomic,copy)void(^customPropertyId)(NSString*);

@end
