//
//  RoadData.h
//  CommunityApp
//
//  Created by iss on 15/6/10.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface RoadData : BaseModel

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *isDefault;
@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *projectName;
@property (nonatomic, copy) NSString *relateId;
@property (nonatomic, copy) NSString *buildingId;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *authen;//是否认证
@property (nonatomic, copy) NSString *contactTel;
@property (nonatomic, copy) NSString *contactName;
@end
