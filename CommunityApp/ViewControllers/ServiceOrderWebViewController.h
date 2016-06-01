//
//  ServiceOrderWebViewController.h
//  CommunityApp
//
//  Created by 张艳清 on 15/11/30.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "MyOrderType.h"

@interface ServiceOrderWebViewController : BaseViewController
@property (nonatomic, copy) NSString    *url;
@property (nonatomic, copy) NSString    *filePath;
@property (nonatomic, copy) NSString    *navTitle;

@property (nonatomic, copy) NSString    *projectId;     //项目(小区）ID
@property (assign,nonatomic) OrderTypeEnum orderType;
@end
