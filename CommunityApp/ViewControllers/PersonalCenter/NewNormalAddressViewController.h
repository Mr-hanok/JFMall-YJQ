//
//  NewAddRoleInfoViewController.h
//  CommunityApp
//
//  Created by iss on 15/6/10.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "RoadData.h"
#import "PostRepairEditViewController.h"
#import "NeighBorHoodModel.h"
@protocol NewNormalAddressViewControllerdelegate<NSObject>
@optional
//-(void)setSelectedPostAddAndDetailAndnumber:(NSString *)projectName andDetail:(NSString*)projectDetail andNum:(NSString *)number andName:(NSString*)contactName andProjectId:(NSString*)projectID andBuildingID:(NSString*)buildingID;
//
//
@end
@interface NewNormalAddressViewController : BaseViewController
@property (retain,nonatomic) RoadData *roadData;
@property (retain,nonatomic) NSString *titleName;

@property (nonatomic, assign) id<NewNormalAddressViewControllerdelegate> delegate;


@end
