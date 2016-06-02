//
//  UITableViewCell+PersonCenterMeCell.h
//  CommunityApp
//
//  Created by iss on 6/4/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@class PersonalCenterMyOrderCommodityDetailCell;
@protocol PersonalCenterMyOrderCommodityDelegate<NSObject>
-(void)toCustomerService:(PersonalCenterMyOrderCommodityDetailCell*)cell;
@end
@interface  PersonalCenterMyOrderCommodityDetailCell:UITableViewCell
@property (assign,nonatomic) id<PersonalCenterMyOrderCommodityDelegate>delegate;
-(void)setCellText:(NSString*)icon service:(NSString*)service num:(NSString*)num;
@end
