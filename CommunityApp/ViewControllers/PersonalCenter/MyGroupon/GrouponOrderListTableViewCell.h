//
//  GrouponOrderListTableViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/8/20.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrouponTicket.h"


@interface GrouponOrderListTableViewCell : UITableViewCell

// 加载Cell数据
- (void)loadCellData:(ticketModel *)model withNum:(NSInteger)num;

@end
