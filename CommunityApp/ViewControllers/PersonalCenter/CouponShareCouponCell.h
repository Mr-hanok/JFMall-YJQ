//
//  CouponShareCouponCell.h
//  CommunityApp
//
//  Created by Andrew on 15/9/17.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ticketModel;

@interface CouponShareCouponCell : UITableViewCell

@property (nonatomic, strong) ticketModel *ticket;
@property (nonatomic, assign) NSInteger ticketIndex;

@end
