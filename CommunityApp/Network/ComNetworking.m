//
//  ComNetworking.m
//  CommonApp
//
//  Created by lipeng on 16/3/10.
//  Copyright © 2016年 common. All rights reserved.
//

#import "ComNetworking.h"
#import "AFHTTPSessionManager.h"

@implementation ComNetworking
{
    NSURLSessionDataTask *_requestTask;
}

- (instancetype)initWithBaseUrl:(NSString *)baseString path:(NSString *)pathString
{
    if (self = [super init]) {
        _urlBaseString = baseString;
        _urlPathString = pathString;
        _parameters = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addDataParam:(NSObject *)param forKey:(NSString *)keyString
{
    [_parameters setValue:param forKey:keyString];
}

- (void)addDataParamFromDictionary:(NSDictionary *)paramDic {
    [_parameters addEntriesFromDictionary:paramDic];
}

- (void)postRequestOnSuccess:(SuccessBlock)successBlock onFailed:(FailedBlock)failedBlock
{
    // 初始化Manager
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:_urlBaseString]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // post请求
    _requestTask = [manager POST:_urlPathString parameters:_parameters constructingBodyWithBlock:^(id  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseData) {
        if (successBlock) {
            successBlock(responseData);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)getRequestOnSuccess:(SuccessBlock)successBlock onFailed:(FailedBlock)failedBlock
{
    // 初始化Manager
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:_urlBaseString]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // get请求
    [manager GET:_urlPathString parameters:_parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseData) {
        if (successBlock) {
            successBlock(responseData);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)cancel
{
    [_requestTask cancel];
}

@end
