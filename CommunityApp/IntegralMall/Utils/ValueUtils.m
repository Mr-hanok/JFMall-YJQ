//
//  ValueUtils.m
//  yilingdoctorCRM
//
//  Created by zhangxi on 14/10/31.
//  Copyright (c) 2014年 yuntai. All rights reserved.
//

#import "ValueUtils.h"

@implementation ValueUtils

+ (NSString *)stringFromObject:(id)obj {
    if (obj == nil) {
        return @"";
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    } else if([obj isKindOfClass:[NSNull class]]) {
        return @"";
    }else if ([obj isKindOfClass:[NSArray class]] ||
              [obj isKindOfClass:[NSDictionary class]]) {
        return @"";
    } else {
        return [obj description];
    }
}

+ (NSNumber *)numberFromObject:(id)obj
{
    if ([obj isKindOfClass:[NSNumber class]]) {
        return obj;
    }
    if ([obj respondsToSelector:@selector(doubleValue)]) {
        return [NSNumber numberWithDouble:[obj doubleValue]];
    }
    return nil;
}

+ (NSString *)timeFormatter:(NSString *)timeStr {
    if (timeStr.length == 0) {
        return nil;
    }
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
    NSDate *inputDate = [inputFormatter dateFromString:timeStr];
    if (!inputDate) {
        return nil;
    }
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:inputDate];
    return currentDateStr;
}

+ (NSString *)timeFormatterWithTimeStamp:(int64_t )timeStamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

+ (NSString *)timeFormatterForServiceWithTimeStamp:(NSTimeInterval )timeStamp {
    NSString *result;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    NSString *todayStr = [dateFormatter stringFromDate:[NSDate date]];
    if ([todayStr isEqualToString:currentDateStr]) {
        [dateFormatter setDateFormat:@"HH:mm"];
        result = [dateFormatter stringFromDate:date];
    } else if ([[currentDateStr substringToIndex:4] isEqualToString:[todayStr substringToIndex:4]]) {
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        result = [dateFormatter stringFromDate:date];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        result = [dateFormatter stringFromDate:date];
    }
    return result;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
