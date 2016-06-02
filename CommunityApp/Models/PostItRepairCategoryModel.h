//
//  PostItRepairCategoryModel.h
//  CommunityApp
//
//  Created by issuser on 15/6/15.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface PostItRepairCategoryModel : BaseModel

@property (nonatomic, copy) NSString    *serviceId;         //分类ID
@property (nonatomic, copy) NSString    *serviceName;       //分类名称
@property (nonatomic, copy) NSString    *serviceCode;       //分类编码
@property (nonatomic, copy) NSString    *serviceLogoUrl;    //分类logo图片地址
@property (nonatomic, copy) NSString    *parentId;          //父分类ID

@end
