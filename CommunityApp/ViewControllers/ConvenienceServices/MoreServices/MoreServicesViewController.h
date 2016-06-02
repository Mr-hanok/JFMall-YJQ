//
//  MoreServicesViewController.h
//  CommunityApp
//
//  Created by issuser on 15/6/7.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"

@interface MoreServicesViewController : BaseViewController

// 便民服务类别数组
@property (nonatomic, retain) NSMutableArray    *serviceArray;

@property (nonatomic, copy) NSString    *projectId;     //项目(小区）ID

@end
