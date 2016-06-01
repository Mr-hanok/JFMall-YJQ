//
//  AfterSaleReasonViewController.h
//  CommunityApp
//
//  Created by issuser on 15/8/4.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "AfterSalesReason.h"

@interface AfterSaleReasonViewController : BaseViewController
@property (nonatomic, copy) void(^asReasonModel)(AfterSalesReason *);
@end
