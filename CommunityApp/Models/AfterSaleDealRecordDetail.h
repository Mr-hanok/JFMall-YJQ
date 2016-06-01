//
//  AfterSaleDealRecordDetail.h
//  CommunityApp
//
//  Created by issuser on 15/7/28.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface AfterSaleDealRecordDetail : BaseModel
@property (copy, nonatomic) NSString *afterSalesId;   //售后ID
@property (copy, nonatomic) NSString *operationId;    //操作人ID
@property (copy, nonatomic) NSString *operationName;  //操作人名称
@property (copy, nonatomic) NSString *operationTime;  //操作时间
@property (copy, nonatomic) NSString *attachment;     //附件url（,英文逗号窜起来）
@property (copy, nonatomic) NSString *content;        //内容描述
@end
