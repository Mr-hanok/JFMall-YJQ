//
//  CommunityMessage.h
//  CommunityApp
//
//  Created by Andrew on 15/9/7.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@class XMPPMessage;

@interface CommunityMessage : BaseModel

extern NSString *const kCommunityMessageTableName;

extern NSString *const kMessageTypePropertyNotice;          /**< 消息类型 - 物业通知 */
extern NSString *const kMessageTypeLifeNews;                /**< 消息类型 — 生活资讯 */
extern NSString *const kMessageTypeWarmTips;                /**< 消息类型 - 温馨提示 */
extern NSString *const kMessageTypeGovernmentAnnouncement;  /**< 消息类型 - 政府公告*/

@property (nonatomic, strong) NSString *messageId;          /**< 消息ID */
@property (nonatomic, strong) NSString *userId;             /**< 用户Id */
@property (nonatomic, strong) NSString *messageFrom;        /**< 发送者 */
@property (nonatomic, strong) NSString *messageTo;          /**< 接收者 */
@property (nonatomic, strong) NSString *messageType;        /**< 消息类型 */
@property (nonatomic, strong) NSString *content;            /**< 消息内容，此处为XMPPMessage的字符串 */
@property (nonatomic, strong) NSString *readFlag;           /**< 已读标识， 0未读，1已读 */

- (instancetype)initWithXMPPMessage:(XMPPMessage *)message;

- (NSString *)createSql;
- (NSString *)insertSql;
- (NSString *)updateSql;
- (NSString *)deleteSql;
- (NSString *)selectSql;
- (NSString *)dataId;
- (NSString *)dataIdKey;
- (NSArray *)insertArguments;
- (NSArray *)updateArguments;
- (CommunityMessage *)convertFMResultSet:(FMResultSet *)result;
+ (NSString *)tableName;

@end
