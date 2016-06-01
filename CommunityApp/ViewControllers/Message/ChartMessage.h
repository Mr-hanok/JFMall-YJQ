//
//  ChartMessage.h
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
typedef enum {
  
    kMessageFrom=0,
    kMessageTo,
    kMessageSys
 
}ChartMessageType;
#import <Foundation/Foundation.h>

@interface ChartMessage : NSObject
@property (nonatomic,assign) ChartMessageType messageType;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;//新闻内容（新闻描述）
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;//新闻链接
@property (nonatomic, copy) NSString *picUrl;//图片链接
@property (nonatomic, copy) NSDictionary *dict;
@property (nonatomic,copy)  NSString* contentType;//新闻还是文字
@end
