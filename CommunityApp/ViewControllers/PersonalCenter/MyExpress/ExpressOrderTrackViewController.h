//
//  ExpressOrderTrackViewController.h
//  CommunityApp
//
//  Created by 酒剑 笛箫 on 15/9/22.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "ExpressOrderModel.h"
#import "OrderTrackModel.h"

@interface ExpressOrderTrackViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *orderId;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;


@property (nonatomic, copy) NSString    *expressId;     // 快递订单ID

@property (nonatomic, retain) ExpressOrderModel *expressOrderModel; // 快递订单数据

@end
