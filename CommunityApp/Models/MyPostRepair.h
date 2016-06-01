//
//  MyPostRepair.h
//  CommunityApp
//
//  Created by iss on 15/6/18.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface MyPostRepair : BaseModel

@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *orderId;
@property (copy, nonatomic) NSString *createDate;
@property (copy, nonatomic) NSString *orderNum;
@property (copy, nonatomic) NSString *serviceName;
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *stateId;

@end
