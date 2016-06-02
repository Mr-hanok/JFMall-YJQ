//
//  APIResult.h
//  yilingdoctorCRM
//
//  Created by zhangxi on 14/10/27.
//  Copyright (c) 2014年 yuntai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIResult : NSObject

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, readonly) BOOL success;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, readonly) NSString *updateTime;

/// 更新时间
- (NSString *)updateTime;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
