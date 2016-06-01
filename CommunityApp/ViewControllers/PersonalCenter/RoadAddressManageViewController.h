//
//  RoadAddressManageViewController.h
//  CommunityApp
//
//  Created by iss on 15/6/10.
//  Copyright (c) 2015年 iss. All rights reserved.
//  路址管理

#import "BaseViewController.h"
#import "RoadData.h"
#import "NewAddRoleInfoViewController.h"
typedef enum
{
    addressSel_Edit,
    addressSel_Default,
    addressSel_Auth,
}addressSelType;

typedef NS_ENUM(NSInteger, ShowDataType) {
    ShowDataTypeAll, /**< 显示全部 */
    ShowDataTypeAuth,   /**< 只显示认证 */
};

@interface RoadAddressManageViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign) addressSelType isAddressSel;
@property(copy,nonatomic)void(^selectRoadData)(RoadData* road);
@property(copy,nonatomic)void(^selectAddressProjectIdAndBuildingId)(NSString* addr, NSString *projectId, NSString *buildingId);
@property (nonatomic, assign) ShowDataType showType;
@end
