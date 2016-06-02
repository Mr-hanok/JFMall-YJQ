//
//  PersonalInfo.h
//  CommunityApp
//
//  Created by 酒剑 笛箫 on 15/8/31.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface PersonalInfo : BaseModel

@property (nonatomic, copy) NSString    *ownerName;     //业主名字
@property (nonatomic, copy) NSString    *sex;           //业主性别
@property (nonatomic, copy) NSString    *ownerPhone;    //联系电话
@property (nonatomic, copy) NSString    *customPropert; //业主属性
@property (nonatomic, copy) NSString    *priviceId;     //省份
@property (nonatomic, copy) NSString    *cityId;        //城市

@end
