//
//  ServiceOrderViewController.h
//  CommunityApp
//
//  Created by iss on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//  服务预约画面

#import "BaseViewController.h"
#import "ServiceDetail.h"

@interface ServiceOrderViewController : BaseViewController
@property (retain, nonatomic) NSString* serviceId;
@property (retain, nonatomic) ServiceDetail *serviceDetail;
@end
