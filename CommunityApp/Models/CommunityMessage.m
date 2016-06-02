//
//  CommunityMessage.m
//  CommunityApp
//
//  Created by Andrew on 15/9/7.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "CommunityMessage.h"
#import "LoginConfig.h"

@implementation CommunityMessage

NSString *const kCommunityMessageTableName = @"CommunityMessageTable";

NSString *const kMessageTypePropertyNotice = @"propertyNotice";
NSString *const kMessageTypeLifeNews = @"lifeNews";
NSString *const kMessageTypeWarmTips = @"warmTips";
NSString *const kMessageTypeGovernmentAnnouncement = @"governmentAnnouncement";

- (instancetype)initWithXMPPMessage:(XMPPMessage *)message
{
    self = [super init];
    if (self) {
//        self.messageId = [[message attributeForName:@"id"] stringValue];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *userId = [userDefault objectForKey:User_UserId_Key];
        self.userId = userId;
//        self.messageFrom = message.fromStr;
//        self.messageTo = message.toStr;
//        self.messageType = [message property][@"MessageType"];
        self.content = [NSString stringWithFormat:@"%@", message];
        self.readFlag = @"0";

    }
    return self;
}

- (NSString *)createSql
{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'messageId' text, 'userId' text, 'messageFrom' text, 'messageTo' text, 'messageType' text, 'content' text, 'readFlag' text)", kCommunityMessageTableName];
    return sql;
}

- (NSString *)insertSql
{
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (messageId, userId, messageFrom, messageTo, messageType, content, readFlag) values (?, ?, ?, ?, ?, ?, ?)", kCommunityMessageTableName];
    return sql;
}

- (NSString *)updateSql
{
    NSString *sql = [NSString stringWithFormat:@"update %@ set userId = ?, messageFrom = ?, messageTo = ?, messageType = ?, content = ?, readFlag = ? where messageId = ?", kCommunityMessageTableName];
    return sql;
}

- (NSString *)deleteSql
{
    NSString *sql = @"";
    if (self.messageId.length == 0) {
        sql = [NSString stringWithFormat:@"delete from %@", kCommunityMessageTableName];
    }
    else {
        sql = [NSString stringWithFormat:@"delete from %@ where messageId = '%@'", kCommunityMessageTableName, self.messageId];
    }
    return sql;
}

- (NSString *)selectSql
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where messageId = '%@'", kCommunityMessageTableName, self.messageId];
    return sql;
}

- (NSString *)dataId
{
    return self.messageId;
}

- (NSString *)dataIdKey
{
    return @"messageId";
}

- (NSArray *)insertArguments
{
    NSArray *array = [NSArray arrayWithObjects:[Common vaildString:self.messageId], [Common vaildString:self.userId], [Common vaildString:self.messageFrom], [Common vaildString:self.messageTo], [Common vaildString:self.messageType], [Common vaildString:self.content], [Common vaildString:self.readFlag], nil];
    return array;
}

- (NSArray *)updateArguments
{
    NSArray *array = [NSArray arrayWithObjects:[Common vaildString:self.userId], [Common vaildString:self.messageFrom], [Common vaildString:self.messageTo], [Common vaildString:self.messageType], [Common vaildString:self.content], [Common vaildString:self.readFlag], [Common vaildString:self.messageId], nil];
    return array;
}

- (CommunityMessage *)convertFMResultSet:(FMResultSet *)result
{
    CommunityMessage *message = [[CommunityMessage alloc] init];
    message.messageId = [result stringForColumn:@"messageId"];
    message.userId = [result stringForColumn:@"userId"];
    message.messageFrom = [result stringForColumn:@"messageFrom"];
    message.messageTo = [result stringForColumn:@"messageTo"];
    message.messageType = [result stringForColumn:@"messageType"];
    message.content = [result stringForColumn:@"content"];
    message.readFlag = [result stringForColumn:@"readFlag"];
    return message;
}

+ (NSString *)tableName
{
    return kCommunityMessageTableName;
}

@end
