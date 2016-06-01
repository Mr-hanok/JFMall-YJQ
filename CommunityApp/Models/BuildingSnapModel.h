//
//  BuildingSnapModel.h
//  CommunityApp
//
//  Created by issuser on 15/7/15.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface BuildingSnapModel : BaseModel

@property(nonatomic, copy)NSString *projectId;  	//ID
@property(nonatomic, copy)NSString *projectName;  	//名称
@property(nonatomic, copy)NSString *averagePrice;  	//均价
@property(nonatomic, copy)NSString *areaName;  		//区域名称
@property(nonatomic, copy)NSString *plate;  		//板块名称
@property(nonatomic, copy)NSString *pic;            //图片
@property(nonatomic, copy)NSString *salesStatusName;//销售状态名称（已售、待售）

@end
