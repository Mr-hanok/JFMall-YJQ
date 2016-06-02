//
//  ExpressNoInsertViewController.h
//  CommunityApp
//
//  Created by issuser on 15/8/24.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "ExpressTypeModel.h"

@interface ExpressNoInsertViewController : BaseViewController
@property (nonatomic, copy) void(^ExpressTicket)(ExpressTypeModel *);
@end
