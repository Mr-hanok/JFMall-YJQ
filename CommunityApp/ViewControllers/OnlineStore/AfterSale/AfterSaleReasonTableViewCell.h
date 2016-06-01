//
//  AfterSaleReasonTableViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/8/4.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AfterSalesReason.h"

@interface AfterSaleReasonTableViewCell : UITableViewCell
- (void)loadCellData:(AfterSalesReason *)model;
@end
