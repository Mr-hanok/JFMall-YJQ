//
//  BuildingListModel.h
//  CommunityApp
//
//  Created by issuser on 15/7/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface BuildingListModel : BaseModel

@property (nonatomic, copy) NSString    *buildingId;    // 楼址ID
@property (nonatomic, copy) NSString    *address;       //  详细地址
@property (nonatomic, copy) NSString    *houseId;//       路址ID
@property (nonatomic, copy) NSString    *location;//        路址
@property (nonatomic, copy) NSString    *buildAddress;//    房源路址
@property (nonatomic, copy) NSString    *isDefault;//        默认路址（1-是，2-否）
@property (nonatomic, copy) NSString    *authType;//       认证状态（1:认证成功  2:待认证 3：拒绝认证 4：异常）
@end
