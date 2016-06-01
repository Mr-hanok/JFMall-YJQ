//
//  MessageViewController.h
//  CommunityApp
//
//  Created by issuser on 15/6/2.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageModel.h"
@interface MessageViewController : BaseViewController
@property(assign,nonatomic) BOOL isFreeDiscuss;
-(NSString*)setMessagePicture:(MessageModel*)modelData;
-(NSString*)setMessageUlr:(MessageModel*)modelData;
-(NSString*)setMessagemsgid:(MessageModel*)modelData;

@end
