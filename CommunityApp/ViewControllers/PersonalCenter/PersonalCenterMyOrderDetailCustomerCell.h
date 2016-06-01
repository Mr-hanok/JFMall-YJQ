//
//  UITableViewCell+PersonCenterMeCell.h
//  CommunityApp
//
//  Created by iss on 6/4/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  PersonalCenterMyOrderDetailCustomerCell:UITableViewCell

@property(strong,nonatomic)IBOutlet UILabel* service;
@property(strong,nonatomic)IBOutlet UILabel* num;

-(void)setCellText:(NSString*)service num:(NSString*)num;
@end
