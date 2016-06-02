//
//  UITableViewCell+PersonCenterMeCell.h
//  CommunityApp
//
//  Created by iss on 6/4/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"


@interface  PersonalCenterMyOrderCell:UITableViewCell
-(void)setServiceCell:(ServiceOrderModel*)serviceOrder;
-(void)setCommodityCell:(materialsModel*)data  totalPrice:(NSString*)total;
@end
