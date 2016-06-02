//
//  ServiceList.h
//  CommunityApp
//
//  Created by issuser on 15/6/19.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface ServiceList : BaseModel

@property (nonatomic, copy) NSString        *serviceId;         //服务ID
@property (nonatomic, copy) NSString        *serviceName;       //服务名称
@property (nonatomic, copy) NSString        *serviceLogoUrl;    //服务logo图片地址

@end
