//
//  NewAddRoleInfoViewController.h
//  CommunityApp
//
//  Created by iss on 15/6/10.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "RoadData.h"

@interface NewAddRoleInfoViewController : BaseViewController
@property (retain,nonatomic) RoadData *roadData;
@property (retain,nonatomic) NSString *titleName;
@property (nonatomic, assign) BOOL authen;  /**< 是否是新增认证路址 */
@end
