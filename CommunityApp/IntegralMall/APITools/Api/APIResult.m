//
//  APIResult.m
//  yilingdoctorCRM
//
//  Created by zhangxi on 14/10/27.
//  Copyright (c) 2014年 yuntai. All rights reserved.
//

#import "APIResult.h"

@implementation APIResult
- (BOOL)success
{
    return self.status == 0;
}

#pragma mark -
#pragma mark Constructor And Destructor
- (id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        
        @try {
            if (dic) {
                NSString *msg = [ValueUtils stringFromObject:dic[SDKKey_Msg]];
                if (msg.length == 0) {
                    msg = kDefaultNetWorkErrorString;
                }
                self.msg = msg;
                self.status = [[dic objectForKey:SDKKey_Status] intValue];
                NSDictionary *data = dic[@"dataobj"];
                self.dic = data;
                
            } else {
                self.msg = @"网络错误";
                
                self.status = kApiErrorInvalidNetwork;
                self.dic = nil;
            }
        }
        @catch (NSException *exception) {
            self.dic = dic;
            self.status = 0;
        }
        @finally {
            
        }
    }
    
    return self;
}

- (NSString *)updateTime
{
    if (self.success && [self.dic objectForKey:@"updateTime"] != nil) {
        return [NSString stringWithFormat:@"%@", [self.dic objectForKey:@"updateTime"]];
    } else {
        NSLog(@"----------返回updateTime错误");
        return nil;
    }
}

@end
