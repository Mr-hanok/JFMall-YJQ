//
//  APIRequest.h
//  yilingdoctorCRM
//
//  Created by zhangxi on 14/10/27.
//  Copyright (c) 2014年 yuntai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIResult.h"
//#import "AccountManager.h"
//#import "UpdateTimeManager.h"

@class APIRequest;

#define SDKKey_Msg                    @"description"
#define SDKKey_Status                 @"code"

#define defaultWebAPITimeOutSeconds   30
#define defaultImageAPITimeOutSeconds 45

typedef enum ApiAddressType {
    kApiAddressTest                         =           1,      // 开发环境
    kApiAddressPre                          =           2,      // 灰度环境
    kApiAddressProduct                      =           3,      // 线上环境
}ApiAddressType;

typedef enum ApiErrorType {
    kApiErrorInvalidNetwork                 =           7000,       // 无效的网络
    kApiErrorInvalidJson                    =           7001,       // 无效的Json串
    kApiErrorNoResult                       =           7002,       // 返回了空字符串
    kApiErrorInvalidJsonDictionary          =           7003,       // 返回的Json串，不是转化成Dictionary
    kApiErrorInvalidApiResultFormat         =           7004,       // api的参数设置错误了，当前只支持xml和json格式
}ApiErrorType;

typedef enum ApiAccessType {
    kApiAccessGet,                      // Get方式
    kApiAccessPost,                     // Post方式
    kApiAccessPut,                      // put方式
    kApiAccessDelete,                   // delete方式
    kApiAccessDownload,                 // 下载
    kApiAccessUpload,                   // 上传
    kApiAccessMultiUpload,              // 多张图片上传
    kApiAccessUploadHeadimage           // 上传头像
}ApiAccessType;

typedef enum ApiCookieType {
    kApiCookieNone,                      // 没有Cookie
    kApiCookieRequied,                   // 必须有Cookie
    kApiCookieOptional,                  // 可有可无Cookie
    kApiCookieCustom,                    // 自由Cookie
    kApiCookieSaveCustom,                // 保存自由cookie
}ApiCookieType;

typedef enum ApiResultFormat {
    kApiResultJson,                     // Json格式
    kApiResultXml,                      // Xml格式
}ApiResultFormat;

@protocol APIRequestDelegate <NSObject>
@optional
- (void)serverApi_RequestFailed:(APIRequest *)api error:(NSError *)error;
- (void)serverApi_FinishedSuccessed:(APIRequest *)api result:(APIResult *)sr;
- (void)serverApi_FinishedFailed:(APIRequest *)api result:(APIResult *)sr;

//下载的代理
- (void)serverApi_DownloadSuccessed:(NSString *)filePath;
- (void)serverApi_DownloadFailed:(NSError *)error;

@end

@interface APIRequest : NSObject

#pragma mark - 基本属性
@property (nonatomic, readonly) ApiAccessType       accessType;// 请求类型
@property (nonatomic, readonly) ApiCookieType       cookieType;// cookie类型
@property (nonatomic, readonly) ApiResultFormat     resultFormat;// 请求返回的格式
@property (nonatomic, readonly) NSTimeInterval      timeout;// 请求超时时间
@property (nonatomic, readonly) NSString            *fullUrl;// 请求路径
@property (nonatomic, readonly) NSString            *serviceUrl;// 服务器地址
@property (nonatomic, readonly) NSString            *urlAction;// 请求地址
@property (nonatomic, readonly) NSString            *requestGetUrl;// 请求的get地址
@property (nonatomic, strong  ) NSMutableDictionary *params;// 参数
@property (nonatomic, weak    ) id<APIRequestDelegate > delegate;// 代理

#pragma mark - 下载相关
@property (nonatomic, strong) NSString *filePath;// 下载路径
@property (nonatomic, strong) NSArray  *filePathArray;// 下载路径数组

#pragma mark - 分页相关
@property (nonatomic, assign) NSInteger requestCurrentPage;// 当前请求页,Java后台从1开始, 微博分页从0开始
@property (nonatomic, assign) NSInteger requestMaxPage;// 最大请求页
@property (nonatomic, copy  ) NSString  *maxID;// 上一次请求最后一条数据的ID

#pragma mark - 基本方法
- (id)initWithDelegate:(id<APIRequestDelegate>)delegate;

/**
 *  @brief  公共参数
 */
- (void)appendBaseParams;

/**
 *  @brief  JSON解析方法
 *
 *  @param data NSData数据
 *
 *  @return 解析结果
 */
- (NSDictionary *)dictionaryWithJsonData:(NSData *)data;

#pragma mark - APIRequestDelegate回调方法
- (void)callBackFinishedWithDictionary:(NSDictionary *)dic;
- (void)callBackFailed:(NSError *)error;

//下载的回调
- (void)downloadSuccessedCallBack:(NSString *)filePath;
- (void)downloadFailedCallBack:(NSError *)error;

@end
