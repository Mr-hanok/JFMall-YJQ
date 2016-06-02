//
//  PersonalCenterMyOrderCouponDetailViewCell.h
//  CommunityApp
//
//  Created by iss on 7/22/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrouponTicket.h"

@interface PersonalCenterMyOrderCouponDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *checkBoxBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBoxWidth;

@property (nonatomic, copy) void(^selectGrouponsBlock)(BOOL isSelected);


-(void)loadCellData:(ticketModel*)ticketData atIndex:(NSInteger)atIndex isButtom:(BOOL)isButtom;

@end
