//
//  UITableViewCell+PersonCenterMeCell.m
//  CommunityApp
//
//  Created by iss on 6/4/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterMyOrderDetailCustomerCell.h"

@implementation   PersonalCenterMyOrderDetailCustomerCell


-(void)setCellText:(NSString*)service num:(NSString*)num
{
    [_service setText:service];
    [_num  setText:[NSString stringWithFormat:@"数量:%@",num]];
}
@end
