//
//  GrouponTicketTableViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/8/17.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrouponTicket.h"

@interface GrouponTicketTableViewCell : UITableViewCell
- (void)loadCellData:(ticketModel *)ticket forRow:(NSInteger)row;
@end
