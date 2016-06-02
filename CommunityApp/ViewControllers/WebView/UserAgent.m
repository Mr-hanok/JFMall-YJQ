//
//  UserAgent.m
//  CommunityApp
//
//  Created by 张艳清 on 15/12/7.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "UserAgent.h"
#import "Interface.h"
#import "LoginConfig.h"
@implementation UserAgent
+ (void)UserAgentMenthd
{
#pragma -mark 12-07 ios 修改web view的ua（未选择小区）
    UIWebView* tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *userAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *yjqiosStr = @";yjqios";
    if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0){
        if ([userAgent containsString:yjqiosStr]) {
            NSRange range = [userAgent rangeOfString:yjqiosStr];
            userAgent = [userAgent substringToIndex:range.location];
        }
    }else{
        NSRange range = [userAgent rangeOfString:yjqiosStr];
        if (range.location != NSNotFound) {
            userAgent = [userAgent substringToIndex:range.location];
        }
    }
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    NSString *userid = [[LoginConfig Instance]userID];
    NSString *ua = [NSString stringWithFormat:@"%@%@(%@,%@)",
                    userAgent,yjqiosStr,userid,projectId];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : ua, @"User-Agent" : ua}];


}
@end
