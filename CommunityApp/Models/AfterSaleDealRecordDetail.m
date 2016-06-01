//
//  AfterSaleDealRecordDetail.m
//  CommunityApp
//
//  Created by issuser on 15/7/28.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "AfterSaleDealRecordDetail.h"

@implementation AfterSaleDealRecordDetail
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    
    if(self){
        self.afterSalesId = [dictionary objectForKey:@"afterSalesId"];      //售后ID
        self.operationId = [dictionary objectForKey:@"operationId"];        //操作人ID
        self.operationName = [dictionary objectForKey:@"operationName"];    //操作人名称
        self.operationTime = [dictionary objectForKey:@"operationTime"];    //操作时间
        self.attachment = [dictionary objectForKey:@"attachment"];  //附件url（,英文逗号窜起来）
        self.content = [dictionary objectForKey:@"content"];        //内容描述
    }
    
    return self;
}



@end
