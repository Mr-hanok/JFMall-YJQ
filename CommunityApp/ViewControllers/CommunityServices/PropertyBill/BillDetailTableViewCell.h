//
//  BillDetailTableViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillListModel.h"

@interface BillDetailTableViewCell : UITableViewCell

/* 加载Cell数据
 * @parameter:array 账单详细数据,第一个元素费用类型和时间，第二个元素本期费用，第三个元素已交费用
 * @parameter:type  cell类型
 */
- (void)loadCellData:(BillListModel *)model;
@end
