//
//  PostDetailViewController.h
//  CommunityApp
//
//  Created by iss on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderTrackModel.h"
#import "OrderPostRepair.h"

@interface PostDetailViewController : BaseViewController
//订单id
@property (strong,nonatomic) IBOutlet UILabel *myLabelOrderId;

//服务名称
@property (strong,nonatomic) IBOutlet UILabel *labelServiceName;

//地址
@property (strong,nonatomic) IBOutlet UILabel *labelAddress;

//联系人
@property (strong,nonatomic) IBOutlet UILabel *labelLinkName;

//联系人电话
@property (strong,nonatomic) IBOutlet UILabel *labelLinkTel;

//创建时间
@property (strong,nonatomic) IBOutlet UILabel *labelCreateDate;

//处理状态
@property (strong,nonatomic) IBOutlet UILabel *labelState;

//订单详情数据
@property (nonatomic, retain) NSString *orderId;

@end
