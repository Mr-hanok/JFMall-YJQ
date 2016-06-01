//
//  DoorToDoorServiceViewController.h
//  CommunityApp
//
//  Created by issuser on 15/8/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "MyOrderType.h"
@interface DoorToDoorServiceViewController : BaseViewController
@property (nonatomic, copy) NSString    *projectId;     //项目(小区）ID
@property (nonatomic, copy) NSString    *url;
@property (assign,nonatomic) OrderTypeEnum orderType;

@end
