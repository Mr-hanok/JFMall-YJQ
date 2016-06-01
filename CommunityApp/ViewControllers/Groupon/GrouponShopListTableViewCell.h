//
//  GrouponShopListTableViewCell.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/25.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrouponShop.h"

@interface GrouponShopListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *shopTelno;
@property (weak, nonatomic) IBOutlet UILabel *shopAddress;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;


@property (nonatomic, copy) void(^dialToShopBlock)(NSString *telno);


- (void)loadCellData:(GrouponShop *)shop;

@end
