//
//  MyGrouponTableViewCell.h
//  CommunityApp
//
//  Created by iss on 7/20/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrouponTicket.h"

@interface MyCouponsTableViewCell : UITableViewCell
-(void)loadCellData:(ticketModel*)ticketData atIndex:(NSInteger)atIndex isButtom:(BOOL)isButtom;
@end
