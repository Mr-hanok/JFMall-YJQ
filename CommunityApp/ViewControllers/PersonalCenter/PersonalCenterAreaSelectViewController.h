//
//  PersonalCenterAreaSelectViewController.h
//  CommunityApp
//
//  Created by iss on 7/30/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "DistinctModel.h"
typedef enum
{
    PersonalCenterSel_Pro,
    PersonalCenterSel_City,
}PersonalCenterSelType;
@interface PersonalCenterAreaSelectViewController : BaseViewController
@property (copy,nonatomic)void(^ distinctData)(DistinctModel* pro,DistinctModel*city);
@end
