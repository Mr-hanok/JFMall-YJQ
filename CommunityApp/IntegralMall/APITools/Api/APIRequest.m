//
//  APIRequest.m
//  yilingdoctorCRM
//
//  Created by zhangxi on 14/10/27.
//  Copyright (c) 2014年 yuntai. All rights reserved.
//

#import "APIRequest.h"

@implementation APIRequest

- (id)initWithDelegate:(id<APIRequestDelegate>)delegate
{
    if (self = [self init]) {
        self.params = [NSMutableDictionary dictionary];
        self.delegate = delegate;
        self.requestCurrentPage = 0;
        self.requestMaxPage = NSIntegerMax;
        self.maxID = @"";
        JFPub_type
        User_userId_uId
    }
    return self;
}

// 默认的是Get方式进行访问
- (ApiAccessType)accessType
{
    return kApiAccessGet;
}

// 默认的是可选cookie
- (ApiCookieType)cookieType
{
    return kApiCookieOptional;
}

// 默认的是Json格式
- (ApiResultFormat)resultFormat
{
    return kApiResultJson;
}

// 默认的超时时间
- (NSTimeInterval)timeout
{
    return defaultWebAPITimeOutSeconds;
}

- (NSString *)serviceUrl {
    return SERVER_HOST_PRODUCT;
}

//fullUrl
- (NSString *)fullUrl {
    NSString *url = [NSString stringWithFormat:@"%@%@", self.serviceUrl, self.urlAction];
    return url;
}

- (NSString *)requestGetUrl {
    NSMutableString *requestStr = [NSMutableString stringWithString:self.fullUrl];
    [requestStr appendString:@"?"];
    
    for (NSString *key in self.params.allKeys) {
        [requestStr appendString:[NSString stringWithFormat:@"%@=%@&", key, self.params[key]]];
    }
    
    return requestStr;
}

- (void)callBackFinishedWithDictionary:(NSDictionary *)dic
{
    APIResult *sr = [[APIResult alloc] initWithDictionary:dic];
    if (sr.success) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(serverApi_FinishedSuccessed:result:)]) {
            [self.delegate serverApi_FinishedSuccessed:self result:sr];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(serverApi_FinishedFailed:result:)]) {
            [self.delegate serverApi_FinishedFailed:self result:sr];
        }
    }
}

- (void)callBackFailed:(NSError *)error
{
    NSLog(@"Request FailedError:%@", error);
    if ([self.delegate respondsToSelector:@selector(serverApi_RequestFailed:error:)]) {
        [self.delegate serverApi_RequestFailed:self error:error];
    }
}

//下载的回调
- (void)downloadSuccessedCallBack:(NSString *)filePath {
    if ([self.delegate respondsToSelector:@selector(serverApi_DownloadSuccessed:)]) {
        [self.delegate serverApi_DownloadSuccessed:filePath];
    }
}


- (void)downloadFailedCallBack:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(serverApi_DownloadFailed:)]) {
        [self.delegate serverApi_DownloadFailed:error];
    }
}


- (NSDictionary *)dictionaryWithJsonData:(NSData *)data
{
    NSString *msg = @"";
    NSString *extraMsg = @"";
    NSError *error = nil;
    ApiErrorType type = kApiErrorInvalidJson;
    if (data.length > 0) {
        id idJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (idJson == nil || error != nil) {
            extraMsg = [NSString stringWithFormat:@"后台返回错误了(请求路径：%@)：jsonString(这不是一个有效的json串):%@", self.fullUrl, error.localizedDescription];
            msg = @"服务器出错";
            type = kApiErrorInvalidJson;
        }
        else {
            return idJson;
        }
    } else {
        extraMsg = [NSString stringWithFormat:@"这是一个空字符串。后台没有返回任何东西(请求路径：%@)", self.fullUrl];
        msg = @"服务器出错";
        type = kApiErrorNoResult;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:msg forKey:SDKKey_Msg];
    [dic setValue:extraMsg forKey:@"extramsg"];
    [dic setValue:[NSNumber numberWithInt:type] forKey:SDKKey_Status];
    return dic;
}

- (void)appendBaseParams
{
//    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
//    NSLog(@"手机系统版本: %@", phoneVersion);
//    //设备名称
//    NSString* deviceName = [[UIDevice currentDevice] systemName];
//    NSLog(@"设备名称: %@",deviceName );
//    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    // 当前应用软件版本  比如：1.0.1
//    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSLog(@"当前应用软件版本:%@",appCurVersion);
//    // 当前应用版本号码   int类型
//    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
//    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    
//    if ([AccountManager sharedInstance].isLoginWeibo) {
//        [self.params setObject:[AccountManager sharedInstance].weiboModel.oauth_token forKey:@"oauth_token"];
//        [self.params setObject:[AccountManager sharedInstance].weiboModel.oauth_token_secret forKey:@"oauth_token_secret"];
//    }
}


@end
