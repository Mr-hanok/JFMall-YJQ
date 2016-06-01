//
//  MessageModel.h
//  CommunityApp
//
//  Created by lsy on 15/12/6.
//  Copyright © 2015年 iss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface MessageModel : BaseModel
@property(nonatomic,copy)NSString*createTimeString;
@property(nonatomic,copy)NSString*msgIdString;
@property(nonatomic,copy)NSString*msgTypeString;//图文消息\文字
@property(nonatomic,copy)NSString*newsReadString;//已读\未读
@property(nonatomic,copy)NSString*newsTypeString;//物业\系统
@property(nonatomic,copy)NSString*pictureString;
@property(nonatomic,copy)NSString*pushStatusString;
@property(nonatomic,copy)NSString*titlelString;//[文字]测试物业通知
@property(nonatomic,copy)NSString*contentString;//内容
@property(nonatomic,copy)NSString*toModuleString;
@property(nonatomic,copy)NSString*toTypeString;
@property(nonatomic,copy)NSString*urlString;
@end
