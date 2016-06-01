//
//  OrderPostRepair.h
//  CommunityApp
//
//  Created by iss on 15/6/19.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface OrderPostRepair : BaseModel
@property (copy,nonatomic) NSString *address;
@property (copy,nonatomic) NSString *createDate;
@property (copy,nonatomic) NSString *linkName;
@property (copy,nonatomic) NSString *linkTel;
@property (copy,nonatomic) NSString *orderId;
@property (copy,nonatomic) NSString *orderNum;
@property (copy,nonatomic) NSString *serviceId;
@property (copy,nonatomic) NSString *serviceName;
@property (copy,nonatomic) NSString *statu;
@property (copy,nonatomic) NSString *stateId;
@property (copy,nonatomic) NSString *type;
@property (copy,nonatomic) NSString *userId;
@property (copy,nonatomic) NSString *filePath;
@end
