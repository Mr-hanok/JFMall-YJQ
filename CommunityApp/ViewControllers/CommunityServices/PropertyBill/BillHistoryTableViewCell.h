//
//  BillHistoryTableViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/6/10.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentHistoryModel.h"

@interface BillHistoryTableViewCell : UITableViewCell


/* 加载Cell数据
 * @parameter:array 账单历史数据,第一个元素支付类型，第二个元素金额，第三个元素日期
 * @parameter:type  cell类型
 */
- (void)loadCellData:(PaymentHistoryModel *)model;

@end
