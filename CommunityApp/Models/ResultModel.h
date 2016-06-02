//
//  ResultModel.h
//  CommunityApp
//
//  Created by issuser on 15/7/28.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface ResultModel : BaseModel
@property (copy,nonatomic) NSString *result;    // 结果（1：成功；0：失败）
@property (copy,nonatomic) NSString *msg;       // 失败信息（当result为0是返回一下失败原因）
@end
