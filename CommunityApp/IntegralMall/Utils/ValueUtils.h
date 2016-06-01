//
//  ValueUtils.h
//  yilingdoctorCRM
//
//  Created by zhangxi on 14/10/31.
//  Copyright (c) 2014年 yuntai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValueUtils : NSObject

+ (NSString *)stringFromObject:(id)obj;
+ (NSNumber *)numberFromObject:(id)obj;

+ (NSString *)timeFormatter:(NSString *)timeStr;

+ (NSString *)timeFormatterWithTimeStamp:(int64_t )timeStamp;

+ (NSString *)timeFormatterForServiceWithTimeStamp:(NSTimeInterval )timeStamp;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
