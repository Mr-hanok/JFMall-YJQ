//
//  UITableViewCell+PersonCenterMeCell.h
//  CommunityApp
//
//  Created by iss on 6/4/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface  PersonalCenterMyOrderServiceDetailCell:UITableViewCell
-(void)setCell:(ServiceOrderModel*)data;
-(void)setCellText:(NSString*)icon service:(NSString*)service num:(NSString*)num;
@end
